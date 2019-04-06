function game

clear
path(path,'inversion_algorithms');
path(path,'fitness');
path(path,'models');
path(path,'models/tools');
path(path,'models/analytical');
path(path,'sources');
path(path,'sources/graphical');
path(path,'stations');
path(path,'stations/tools');
path(path,'EarthQuakes');
path(path,'main');
path(path,'main/tools');
path(path,'DEM');
path(path,'pole');
rng(160976);

try
    main
catch e
    msgbox(['The identifier was: ',e.identifier,' ',e.message], 'Error','error');
end
