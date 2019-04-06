function [Si] = doFAST(Sources, Stations, Terrain, ObjFun)

nvars = 0;
LB = [];
UB = [];


for j=1:length(Sources)
    if (Sources(j).IsActive)
        for i=1:Sources(j).NParameters
            if Sources(j).ActiveParameters(i)
                nvars = nvars + 1;
                LB = [LB,Sources(j).LowBoundaries(i)];
                UB = [UB,Sources(j).UpBoundaries(i)];
            end
        end
    end
end

[Measured, Errors, Weight, Normal] = mergedata(Stations);
fitnessfcn = @(x)new_fitnex(x,Sources, Stations, Terrain,mapobjfunc(ObjFun), Measured, Errors, Weight, Normal);

% retrieve the number of input variables
k = length(LB);

% set the number of discrete intervals for numerical integration of (13)
% increasing this parameter makes more precise the numerical integration
M = 100;

% read the table of incommensurate frequencies for k variables
W = fnc_FAST_getFreqs(k);

% set the maximum integer frequency
Wmax = W(k);

% calculate the Nyquist frequency and multiply it for the number of
% intervals
N = 2*M*Wmax+1;

q = (N-1)/2;

% set the variable of integration
S = pi/2*(2*(1:N)-N-1)/N;
alpha = W'*S;

% calculate the new input variables, see (10)
NormedX = 0.5 + asin(sin(alpha'))/pi;

% retrieve the corresponding inputs for the new input variables. 
N = size(NormedX,1);

r = repmat(LB,N,1);
R = repmat(UB,N,1);

% map the normalized input variables into real input variables for the model
X = NormedX.*(R-r) + r;

Y = nan(N,1);

% calculate the output of the model at input sample points
wh = waitbar(0,'calculating');
for j=1:N
    Y(j) = fitnessfcn(X(j,:));
    waitbar(j/N,wh);
end
close(wh);

A = zeros(N,1);
B = zeros(N,1);
N0 = q+1;


% ----
f1  = sum( reshape(Y(2:end),2,(N-1)/2) ); 
fdiff = -diff( reshape(Y(2:end),2,(N-1)/2) );  

for j=1:N
    if mod(j,2)==0 % compute the real part of the Fourier coefficients
        sj = Y(1) ;
        for g=1:(N-1)/2
            sj = sj + f1(g)*cos(j*g*pi/N) ;
        end
        A(j) = sj/N ;
    else % compute the imaginary part of the Fourier coefficients
        sj = 0 ;
        for g=1:(N-1)/2
            sj = sj + fdiff(g)*sin(j*g*pi/N) ;
        end
        B(j) = sj/N ;
    end
end

% compute the total variance by summing the squares of the Fourier
% coefficients
V = 2*(A'*A + B'*B);

% calculate the sensitivity coefficients for each input variable
for i=1:k
     I = (1:M)*W(i) ;
     Si(i) = 2*(A(I)'*A(I) + B(I)'*B(I)) / V;
end


