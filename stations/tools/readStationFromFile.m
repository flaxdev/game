function [fid, Station] = readStationFromFile(fid)

Station.Type = strtrim(fgets(fid));
Station.Name = strtrim(fgets(fid));
Station.CoordinateType = strtrim(fgets(fid));
S = fgets(fid);
Station.Coordinates = str2num(S);

for i=1:length(Station.Coordinates)
    Station.NameCoordinates{i} = strtrim(fgets(fid));
end

Station.NMeasurements = str2num(fgets(fid));
for i=1:Station.NMeasurements
    S = fgets(fid);
    [token, remain] = strtok(S,' ');
    Station.NameMeasurements{i} = strtrim(token);
    [token, remain] = strtok(remain,' ');
    Station.Measurements(i) = str2num(token);
    [token, remain] = strtok(remain,' ');
    Station.Errors(i) = str2num(token);
end
Station.Weight = str2num(fgets(fid));
