function [S, ObjX, reason, output, population, scores] = solveGA(Sources, Stations, GAparameters, Terrain, isConstrained, ObjFun, hideplot)

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

INITX = repmat(LB,GAparameters.PopulationSize,1) + rand(GAparameters.PopulationSize,length(LB)).*repmat(UB-LB,GAparameters.PopulationSize,1);
INITX(1:max(1,floor(GAparameters.PopulationSize/5)),:) = repmat(XX,max(1,floor(GAparameters.PopulationSize/5)),1);

[Measured, Errors, Weight, Normal] = mergedata(Stations);
problem.fitnessfcn = @(x)new_fitnex(x,Sources, Stations, Terrain,mapobjfunc(ObjFun), Measured, Errors, Weight, Normal);

problem.nvars = nvars;

NPops = repmat(GAparameters.PopulationSize,1,GAparameters.NumIslands);

options = gaoptimset('CrossoverFraction',GAparameters.Crossover,...
                     'EliteCount',GAparameters.Elite,...
                     'Generations',GAparameters.Generations,...
                     'InitialPopulation',INITX,...
                     'MigrationFraction',GAparameters.Migration,...
                     'MigrationInterval',floor(GAparameters.MigrationInterval),...
                     'MigrationDirection',GAparameters.MigrationDirection,...
                     'StallGenLimit',Inf,...
                     'StallTimeLimit',Inf,...
                     'PlotInterval',10,...
                     'PlotFcns',@gaplotbestf,...
                     'PopulationSize',NPops,...
                     'PopInitRange',[LB;UB]);
          
if hideplot
    options = gaoptimset(options, 'PlotInterval',Inf,...
                     'PlotFcns',[]);
end
    
if strcmp(GAparameters.CrossType,'Scattered')
    options = gaoptimset(options, 'CrossoverFcn',@crossoverscattered);
elseif strcmp(GAparameters.CrossType,'Single point')
    options = gaoptimset(options, 'CrossoverFcn',@crossoversinglepoint);
elseif strcmp(GAparameters.CrossType,'Two point')
    options = gaoptimset(options, 'CrossoverFcn',@crossovertwopoint);
elseif strcmp(GAparameters.CrossType,'Intermediate')
    options = gaoptimset(options, 'CrossoverFcn',{@crossoverintermediate,GAparameters.CrossParam});
elseif strcmp(GAparameters.CrossType,'Heuristic')
    options = gaoptimset(options, 'CrossoverFcn',{@crossoverheuristic,GAparameters.CrossParam});
elseif strcmp(GAparameters.CrossType,'Arithmetic')
    options = gaoptimset(options, 'CrossoverFcn',@crossoverarithmetic);
end

if strcmp(GAparameters.SelectionType,'Stochastic uniform')
    options = gaoptimset(options, 'SelectionFcn',@selectionstochunif);
elseif strcmp(GAparameters.SelectionType,'Remainder')
    options = gaoptimset(options, 'SelectionFcn',@selectionremainder);
elseif strcmp(GAparameters.SelectionType,'Uniform')
    options = gaoptimset(options, 'SelectionFcn',@selectionuniform);
elseif strcmp(GAparameters.SelectionType,'Tournament')
    options = gaoptimset(options, 'SelectionFcn',{@selectiontournament,GAparameters.SelectionParam});
elseif strcmp(GAparameters.SelectionType,'Roulette')
    options = gaoptimset(options, 'SelectionFcn',@selectionroulette);
end

if strcmp(GAparameters.MutationType,'Gaussian')
    options = gaoptimset(options, 'MutationFcn',{@mutationgaussian,GAparameters.MutationParam1,GAparameters.MutationParam2});
elseif strcmp(GAparameters.MutationType,'Uniform ')
    options = gaoptimset(options, 'MutationFcn',{@mutationuniform,GAparameters.MutationParam1});
elseif strcmp(GAparameters.MutationType,'Adaptive Feasible')
    options = gaoptimset(options, 'MutationFcn',@mutationadaptfeasible);
end



if isConstrained
    options = gaoptimset(options, 'MutationFcn',@mutationadaptfeasible);
    problem.LB = LB;
    problem.UB = UB;
    problem.Aineq=[];
    problem.Bineq=[];
    problem.Aeq=[];
    problem.Beq=[];
    problem.nonlcon=[];
end           

    
problem.options = options;

warning('off','all');
[x, fval, reason, output, population, scores] = ga(problem);
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

