function handles = SortSyncStationSensors(handles)


Swap = zeros(length(handles.Stations),1);
for i=1:length(handles.Stations)
    for j=1:length(handles.Sensors)
        if strcmp(handles.Stations(i).Name,handles.Sensors(j).Name)
            Swap(i) = j;
        end
    end
end


thereis = Swap>0;
orderedStations = [handles.Stations(thereis), handles.Stations(not(thereis))];

Swap(Swap==0) = [];

thereis = zeros(length(handles.Sensors),1);
thereis(Swap) = 1;
orderedSensors = [handles.Sensors(Swap), handles.Sensors(not(thereis))];

handles.Stations = orderedStations;
handles.Sensors = orderedSensors;
