function [handles, err, ModelsOut, OutErrors, Measured, MeasureErrors,Weight,Nfittedparameters] = ForwardModel(handles)

for j=1:length(handles.Sensors)
    Sensors{j} = [];
end

err = [];

if get(handles.estimerr,'Value')
    NEstimation = handles.NEstimation;
else
    NEstimation = 1;
end
if any([handles.Sources.IsActive])
    
    wh = waitbar(0);
    for itrials = 1:NEstimation
        MySources = handles.Sources;
        for i=1:length(handles.Sources)
            if get(handles.estimerr,'Value')
                MySources(i).Parameters = handles.Sources(i).Parameters + randn(size(handles.Sources(i).Parameters)).*handles.Sources(i).EParameters;
            else
                MySources(i).Parameters = handles.Sources(i).Parameters;
            end
        end
        for j=1:length(handles.Sensors)
            O = 0;
            if strcmp(handles.Sensors(j).Type,'Displacement')
                O = allDisplacement(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Altimeter')
                O = allLevelling(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Tiltmeter')
                O = allTiltmeter(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Paxes')
                O = allPaxes(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'HorizDisplacement')
                O = allHorizDisplacement(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Earthquake')
                O = allEarthquake(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Strainmeter')
                O = allStrainmeter(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Baseline')
                O = allBaseline(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            elseif strcmp(handles.Sensors(j).Type,'Gravity')
                O = allGravity(MySources,handles.Sensors(j).Coordinates, handles.Terrain);
            end
            Sensors{j} = [Sensors{j}; O];
        end
        waitbar(itrials/NEstimation,wh);
    end
    
    close(wh);
    
    
    for j=1:length(handles.Sensors)
        if size(Sensors{j},1)>1
            handles.Sensors(j).Measurements = nanmean(Sensors{j});
            handles.Sensors(j).Errors = nanstd(Sensors{j});
        else
            handles.Sensors(j).Measurements = Sensors{j};
            handles.Sensors(j).Errors = zeros(size(handles.Sensors(j).Measurements));
        end
    end
else
    
    for j=1:length(handles.Sensors)
        handles.Sensors(j).Measurements = nan(1,handles.Sensors(j).NMeasurements);
        handles.Sensors(j).Errors = nan(1,handles.Sensors(j).NMeasurements);
    end
end
ModelsOut = [];
OutErrors = [];
Measured = [];
MeasureErrors = [];
Weight = [];

% [Measured Errors Weight Normal] = mergedata(handles.Stations);

for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            if strcmp(handles.Sensors(j).Type,'Paxes')
                ad = angleBetweenAxis(handles.Sensors(j).Measurements(1),handles.Sensors(j).Measurements(2), handles.Stations(i).Measurements(1),handles.Stations(i).Measurements(2));
                ModelsOut = [ModelsOut; 0; abs(sind(ad))];
                VModelsOut(j).out = handles.Sensors(j).Measurements(:);
                Measured = [Measured; 0; 0];
                OutErrors = [OutErrors; 0; 0];
                MeasureErrors = [MeasureErrors; 1; abs(sum(sind(handles.Stations(i).Errors(:))))];
                Weight = [Weight; ones(size(handles.Stations(i).Measurements(:)))*handles.Stations(i).Weight];
            else
                ModelsOut = [ModelsOut; handles.Sensors(j).Measurements(:)];
                OutErrors = [OutErrors; handles.Sensors(j).Errors(:)];
                VModelsOut(j).out = handles.Sensors(j).Measurements(:);
                Measured = [Measured; handles.Stations(i).Measurements(:)];
                MeasureErrors = [MeasureErrors; handles.Stations(i).Errors(:)];
                Weight = [Weight; ones(size(handles.Stations(i).Measurements(:)))*handles.Stations(i).Weight];
            end
        end
    end
end


Nfittedparameters = 0;
for i=1:length(handles.Sources)
    if (handles.Sources(i).IsActive)
        for k=1:handles.Sources(i).NParameters
            if handles.Sources(i).ActiveParameters(k)
                Nfittedparameters = Nfittedparameters + 1;
            end
        end
    end
end

if ~isempty(ModelsOut) && ~isempty(Measured)
    %     err = getmisfit(ModelsOut./Normal,Measured./Normal,Errors,Weight,mapobjfunc(handles.ObjFunction));
    err = getmisfit(ModelsOut,Measured,MeasureErrors,Weight,Nfittedparameters,mapobjfunc(handles.ObjFunction));
end