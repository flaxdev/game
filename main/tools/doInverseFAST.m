function [Si] = doInverseFAST(Sources, Stations, Terrain, ObjFun, whatalgorithm, Parameters, contrained, M)

nvars = 0;
LB = [];
UB = [];

ksigma = 2;

for j=1:length(Stations)
    for i=1:Stations(j).NMeasurements
        nvars = nvars + 1;
        LB = [LB,Stations(j).Measurements(i)-ksigma*Stations(j).Errors(i)];
        UB = [UB,Stations(j).Measurements(i)+ksigma*Stations(j).Errors(i)];
    end
end

% retrieve the number of input variables
k = length(LB);

% set the number of discrete intervals for numerical integration of (13)
% increasing this parameter makes more precise the numerical integration
% M = 5;

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

nouts = 0;
for j=1:length(Sources)
    if (Sources(j).IsActive)
        for i=1:Sources(j).NParameters
            if Sources(j).ActiveParameters(i)
                nouts = nouts + 1;
            end
        end
    end
end


Y = nan(N,nouts);

% calculate the output of the model at input sample points
wh = waitbar(0,'calculating');
for j=1:N
    MyStations = Stations;
    MySource = Sources;
    for s=1:length(MySource)
        ranges = (MySource(s).UpBoundaries - MySource(s).LowBoundaries);
        randvals = ranges.*rand(1,MySource(s).NParameters) + MySource(s).LowBoundaries;
        MySource(s).Parameters = (randvals + MySource(s).Parameters)/2;
        MySource(s).Parameters(not(MySource(s).ActiveParameters)) = Sources(s).Parameters(not(MySource(s).ActiveParameters));
    end
    ivar = 0;
    for u=1:length(MyStations)
        for q=1:MyStations(u).NMeasurements
            ivar = ivar + 1;
            MyStations(u).Measurements(q) = X(j,ivar);
        end
    end
    
    if strcmp(whatalgorithm,'GA')
        [os, fval]= solveGA(MySource, MyStations, Parameters, Terrain, contrained, ObjFun, 1);
    elseif strcmp(whatalgorithm,'PS')
        [os, fval]= solvePS(MySource, MyStations, Parameters, Terrain, contrained, ObjFun, 1);
    elseif strcmp(whatalgorithm,'NLSQ')
        [os, fval]= solveNLSQ(MySource, MyStations, Parameters, Terrain, contrained, 1);
    end
    ivar = 0;
    for u=1:length(os)
        if (os(u).IsActive)
            for h=1:os(u).NParameters
                if os(u).ActiveParameters(h)
                    ivar = ivar + 1;
                    Y(j,ivar) = os(u).Parameters(h);
                end
            end
        end
    end
    waitbar(j/N,wh, [num2str(j),'/',num2str(N)]);
end
close(wh);

Si = nan(k,nouts);

for io = 1:nouts
    A = zeros(N,1);
    B = zeros(N,1);
    N0 = q+1;
    
    
    % ----
    f1  = sum( reshape(Y(2:end, io),2,(N-1)/2) );
    fdiff = -diff( reshape(Y(2:end, io),2,(N-1)/2) );
    
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
        Si(i,io) = 2*(A(I)'*A(I) + B(I)'*B(I)) / V;
    end
    
end

% grouped per station
Sis = nan(length(Stations),nouts);
ivar = 1;
Inames = {};
for j=1:length(Stations)
    nv = Stations(j).NMeasurements;
    Sis(j,:) = nansum(Si((ivar:(ivar+nv-1)),:));
    ivar = ivar + nv;
    Inames{end+1} = Stations(j).Name;
end


iouts = 0;
for j=1:length(Sources)
    if (Sources(j).IsActive)
        for i=1:Sources(j).NParameters
            if Sources(j).ActiveParameters(i)
                iouts = iouts + 1;
                Oname = [char(Sources(j).Type),'/',char(Sources(j).ParameterNames(i))];
                figure
                bar(1:length(Inames),Sis(:,iouts));
                set(gca,'XTick',1:length(Inames))
                set(gca,'XTickLabel',Inames);
                xtickangle(90);
                title(Oname);
            end
        end
    end
end


SiM = nansum(Sis,2);

figure
bar(1:length(Inames),SiM);
set(gca,'XTick',1:length(Inames))
set(gca,'XTickLabel',Inames);
xtickangle(90);
title('Global Model');
