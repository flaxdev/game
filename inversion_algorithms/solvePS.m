function [S ObjX] = solvePS(Sources, Stations, PSparameters, Terrain, isConstrained, ObjFun, hideplot)

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

fitnessfcn = @(x)new_fitnex(x,Sources, Stations, Terrain,mapobjfunc(ObjFun), Measured, Errors, Weight, Normal);


options = psoptimset('PollingOrder','Random',...
                     'PlotFcns',{@psplotbestf ,@psplotfuncount },...
                     'PlotInterval',50,...
                     'CacheSize',PSparameters.CacheSize,...
                     'InitialMeshSize',PSparameters.Mesh,...
                     'MeshContraction',PSparameters.Contraction,...
                     'MeshExpansion',PSparameters.Expansion,...
                     'InitialPenalty',PSparameters.InitPenalty,...
                     'MaxIter',PSparameters.NumIter,...
                     'MaxFunEvals',Inf,...
                     'TolMesh',1e-9,...
                     'PenaltyFactor',PSparameters.PenaltyFactor);

options = psoptimset(options, 'PollMethod',PSparameters.Poll);

if hideplot
    options = psoptimset(options, 'PlotInterval',Inf,...
                     'PlotFcns',[]);
end

if PSparameters.CacheOk
    options = psoptimset(options, 'Cache','on');
else 
    options = psoptimset(options, 'Cache','off');
end

if PSparameters.completepoll
    options = psoptimset(options, 'CompletePoll','on');
else 
    options = psoptimset(options, 'CompletePoll','off');
end


if strcmp(PSparameters.Search,'GPSPositiveBasisNp1')
    options = psoptimset(options, 'SearchMethod','GPSPositiveBasisNp1');
elseif strcmp(PSparameters.Search,'GPSPositiveBasis2N')
    options = psoptimset(options, 'SearchMethod','GPSPositiveBasis2N');
elseif strcmp(PSparameters.Search,'MADSPositiveBasisNp1')
    options = psoptimset(options, 'SearchMethod','MADSPositiveBasisNp1');
elseif strcmp(PSparameters.Search,'MADSPositiveBasis2N')
    options = psoptimset(options, 'SearchMethod','MADSPositiveBasis2N');
elseif strcmp(PSparameters.Search,'searchga')
    options = psoptimset(options, 'SearchMethod',@searchga);
elseif strcmp(PSparameters.Search,'searchlhs')
    options = psoptimset(options, 'SearchMethod',@searchlhs);
elseif strcmp(PSparameters.Search,'searchneldermead')
    options = psoptimset(options, 'SearchMethod',@searchneldermead);
end
    
warning('off','all');
if isConstrained                                 
    [x, fval] = patternsearch(fitnessfcn,XX,[],[],[],[],LB,UB,[],options);
else
    [x, fval] = patternsearch(fitnessfcn,XX,[],[],[],[],[],[],[],options);
end
warning('on','all');  

ObjX = fval;
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

