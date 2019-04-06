function EarthQuakes = readEarthQuakesDB(filename)

fid = fopen(filename,'r');

tline = fgets(fid);

C = textscan(fid,'%10s%11s%f%f%f%f%f%s','delimiter', ';');

fclose(fid);

Mag = nanmean([1.23*C{6}' - 0.54;C{7}'])';  

EarthQuakes = [C{3},C{4},C{5},Mag,datenum([char(C{1}),repmat(' ',size(C{1},1),1),char(C{2})],'dd/mm/yyyy HH:MM:SS')];


