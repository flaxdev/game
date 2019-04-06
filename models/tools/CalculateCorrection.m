function Uc = CalculateCorrection(Sources, Point, Terrain)

h = Point(3);
Point(3) = 0;

[u1_1 u1_2 u2_1 u2_2 u3_1 u3_2] = CalcDerivAtPoint(Sources, Point, Terrain);

% h = griddata(Terrain.DEM.X(:), Terrain.DEM.Y(:), Terrain.DEM.H(:), Point(2), Point(1));

Uc(1) =  h*u3_1*0.2;
Uc(2) =  h*u3_2*0.2;

Uc(3) =  -(Terrain.Poisson/(1-Terrain.Poisson))*h.*(u1_1 + u2_2);