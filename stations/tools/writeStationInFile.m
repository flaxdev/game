function fid = writeStationInFile(fid,Station)

fprintf(fid,'%s\n',Station.Type);
fprintf(fid,'%s\n',Station.Name);
fprintf(fid,'%s\n',Station.CoordinateType);
fprintf(fid,'%f ',Station.Coordinates);
fprintf(fid,'\n');
for i=1:length(Station.Coordinates)
    fprintf(fid,'%s\n',Station.NameCoordinates{i});
end
fprintf(fid,'%d\n',Station.NMeasurements);
for i=1:Station.NMeasurements
    fprintf(fid,'%s %f %f\n',Station.NameMeasurements{i},Station.Measurements(i),Station.Errors(i));
end
fprintf(fid,'%f\n',Station.Weight);