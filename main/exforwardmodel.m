get( estimerr,'Value')
function [handles, err, ModelsOut, Measured,Errors,Weight,Nfittedparameters] = forwardmodel(Sources, Stations, Sensors, Terrain, errorcalc, NEstimation)

for j=1:length(Sensors)
    forwardouts{j} = [];
end

err = [];

if not(exist('NEstimation','var'))
    NEstimation = 1;
end

wh = waitbar(0);
for itrials = 1:NEstimation
    MySources = Sources;
    for i=1:length(MySources)
        if errorcalc
            MySources(i).Parameters = Sources(i).Parameters + randn(size(Sources(i).Parameters)).*Sources(i).EParameters;
        else
            MySources(i).Parameters = Sources(i).Parameters;
        end
    end
    for j=1:length(Sensors)
        O = 0;
        if strcmp(Sensors(j).Type,'Displacement')
            O = allDisplacement(MySources,Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Altimeter')
            O = allLevelling(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Tiltmeter')
            O = allTiltmeter(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Paxes')
            O = allPaxes(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'HorizDisplacement')
            O = allHorizDisplacement(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Earthquake')
            O = allEarthquake(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Strainmeter')
            O = allStrainmeter(MySources, Sensors(j).Coordinates, Terrain);
        elseif strcmp( Sensors(j).Type,'Baseline')
            O = allBaseline(MySources, Sensors(j).Coordinates, Terrain);
        end
        forwardouts{j} = [forwardouts{j}; O];
    end
    waitbar(itrials/NEstimation,wh);
end

close(wh);
for j=1:length(Sensors)
    if size(forwardouts{j},1)>1
         Sensors(j).Measurements = nanmean(forwardouts{j});
         Sensors(j).Errors = nanstd(forwardouts{j});
    else
         Sensors(j).Measurements = forwardouts{j};
         Sensors(j).Errors = zeros(size(Sensors(j).Measurements));
    end
end

ModelsOut = [];
Measured = [];
Errors = [];
Weight = [];

% [Measured Errors Weight Normal] = mergedata( Stations);

for i=1:length(Stations)
    for j=1:length(Sensors)
        if strcmp(Stations(i).Name, Sensors(j).Name)
            if strcmp( Sensors(j).Type,'Paxes')
                ad = angleBetweenAxis( Sensors(j).Measurements(1), Sensors(j).Measurements(2),  Stations(i).Measurements(1), Stations(i).Measurements(2));
                ModelsOut = [ModelsOut; 0; abs(sind(ad))];
                VModelsOut(j).out =  Sensors(j).Measurements(:);
                Measured = [Measured; 0; 0];
                Errors = [Errors; 1; abs(sum(sind( Stations(i).Errors(:))))];
                Weight = [Weight; ones(size( Stations(i).Measurements(:)))* Stations(i).Weight];
            else
                ModelsOut = [ModelsOut;  Sensors(j).Measurements(:)];
                VModelsOut(j).out =  Sensors(j).Measurements(:);
                Measured = [Measured;  Stations(i).Measurements(:)];
                Errors = [Errors;  Stations(i).Errors(:)];
                Weight = [Weight; ones(size( Stations(i).Measurements(:)))* Stations(i).Weight];
            end
        end
    end
end

if ( DoBaselines)
    tmpModelsOut = [];
    tmpMeasured = [];
    tmpErrors = [];
    tmpWeight = [];
    
    for j=1:length( Stations)
        if strcmp( Stations(j).Type, 'Displacement')
            for i=(j+1):length( Stations)
                if strcmp( Stations(i).Type, 'Displacement')
                    mainbsl =  Stations(i).Coordinates -  Stations(j).Coordinates;
                    
                    measbsl = mainbsl +  Stations(i).Measurements -  Stations(j).Measurements;
                    
                    tmpMeasured =  [tmpMeasured; norm(measbsl)];
                    
                    modebsl = mainbsl + VModelsOut(i).out' - VModelsOut(j).out';
                    
                    tmpModelsOut = [tmpModelsOut; norm(modebsl)];
                    
                    tmpErrors =   [tmpErrors; mean( Stations(j).Errors+ Stations(i).Errors)];
                    
                    tmpWeight =   [tmpWeight; mean([ Stations(j).Weight, Stations(i).Weight])];
                end
            end
        else
            tmpModelsOut = [tmpModelsOut; ModelsOut(1: Stations(j).NMeasurements)];
            tmpMeasured =  [tmpMeasured; Measured(1: Stations(j).NMeasurements)];
            tmpErrors =   [tmpErrors; Errors(1: Stations(j).NMeasurements)];
            tmpWeight =   [tmpWeight; Weight(1: Stations(j).NMeasurements)];
        end
        ModelsOut(1: Stations(j).NMeasurements) = [];
        Measured(1: Stations(j).NMeasurements) = [];
        Errors(1: Stations(j).NMeasurements) = [];
        Weight(1: Stations(j).NMeasurements) = [];
    end
    
    
    ModelsOut = tmpModelsOut;
    Measured = tmpMeasured;
    Errors = tmpErrors;
    Weight = tmpWeight;
    
end

Nfittedparameters = 0;
for i=1:length( Sources)
    if ( Sources(i).IsActive)
        for k=1: Sources(i).NParameters
            if  Sources(i).ActiveParameters(k)
                Nfittedparameters = Nfittedparameters + 1;
            end
        end
    end
end

if ~isempty(ModelsOut) && ~isempty(Measured)
    %     err = getmisfit(ModelsOut./Normal,Measured./Normal,Errors,Weight,mapobjfunc( ObjFunction));
    err = getmisfit(ModelsOut,Measured,Errors,Weight,Nfittedparameters,mapobjfunc( ObjFunction));
end