function [S ObjX] = solveNLSQ(Sources, Stations, NLSQparameters, Terrain, isConstrained, hideplot)

% Source{i} is a vector of sources of signal type i (displacements, tilting,
% tremor etc).
% Source{1} represent the real sources parameters while Source{i>1} are
% used only for the model-signal function
% Stations{i} is a matrix with the coordinates of the recording stations of signal type i
% Measurements{i} is a matrix of measurements of signal type i at the
% respectively stations

% nTypeOfSignals = length(Sources);

nvars = 0;
LB = [];
UB = [];
XX = [];

if not(exist('hideplot','var'))
    hideplot = 0;
end

for j=1:length(Sources)
    if (Sources(j).IsActive)
        for i=1:Sources(j).NParameters
            if Sources(j).ActiveParameters(i)
                nvars = nvars + 1;
                LB = [LB,Sources(j).LowBoundaries(i)];
                UB = [UB,Sources(j).UpBoundaries(i)];
                XX = [XX,Sources(j).Parameters(i)];
            end
        end
    end
end

[Measured Errors Weight Normal] = mergedata(Stations);

F = @(x)fNLSQ(x, Sources, Stations, Terrain, Measured, Errors, Weight);


options = optimset('PlotFcns',@optimplotresnorm,...
    'MaxIter',300,...
    'MaxFunEvals',Inf);

if hideplot
    options = optimset(options, 'PlotFcns',[]);
end

warning('off','all');
if isConstrained
    [x, ObjX] = lsqnonlin(F,XX,LB,UB,options);
else
    [x, ObjX] = lsqnonlin(F,XX,[],[],options);
end
warning('on','all');

S = Sources;
ivar = 0;
for j=1:length(S)
    if (S(j).IsActive)
        for i=1:Sources(j).NParameters
            if Sources(j).ActiveParameters(i)
                ivar = ivar+1;
                S(j).Parameters(i) = x(ivar);
                S(j).EParameters(i) = 0;
            end
        end
    else
        S(j).EParameters = zeros(size(S(j).EParameters));
    end
end
