function [X,Y,Z] = getDemMesh(filename,east,north)

load(filename);

if nargin==1
    east = DEM.East;
    north = DEM.North;
end

E = linspace(DEM.East(1),DEM.East(2),size(DEM.Height,1));
N = linspace(DEM.North(1),DEM.North(2),size(DEM.Height,2));

ieast = find((E>= east(1)) & (E<= east(2)));
inorth = find((N>= north(1)) & (N<= north(2)));

Z = DEM.Height(ieast,:);
Z = Z(:,inorth);

[Y,X] = meshgrid(N(inorth),E(ieast));
