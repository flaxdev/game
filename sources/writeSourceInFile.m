function fid = writeSourceInFile(fid,Source)

fprintf(fid,'%s\n',Source.Type);
fprintf(fid,'%d\n',Source.NParameters);
for i=1:Source.NParameters
    fprintf(fid,'%s %f %f %f %f %f\n',Source.ParameterNames{i},Source.Parameters(i),Source.EParameters(i),Source.LowBoundaries(i),Source.UpBoundaries(i),Source.ActiveParameters(i));
end
fprintf(fid,'%d\n',Source.IsActive);