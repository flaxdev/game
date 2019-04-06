function [fid Source] = readSourceFromFile(fid)

Source = newSourcebyType(strtrim(fgets(fid)));
Source.NParameters = str2num(fgets(fid));
for i=1:Source.NParameters
    S = fgets(fid);
    [token, remain] = strtok(S,' ');
    Source.ParameterNames{i} = strtrim(token);
    [token, remain] = strtok(remain,' ');
    Source.Parameters(i) = str2num(token);
    [token, remain] = strtok(remain,' ');
    Source.EParameters(i) = str2num(token);
    [token, remain] = strtok(remain,' ');
    Source.LowBoundaries(i) = str2num(token);
    [token, remain] = strtok(remain,' ');
    Source.UpBoundaries(i) = str2num(token);
    [token, remain] = strtok(remain,' ');
    Source.ActiveParameters(i) = str2num(token);
end
Source.IsActive = str2num(fgets(fid));