function U = allLevelling(Sources,Point, Terrain)
%Point [U]
%output = [U]

U = allDisplacement(Sources,Point, Terrain);
U = U(3);
