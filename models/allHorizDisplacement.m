function U = allHorizDisplacement(Sources,Point, Terrain)
%Point [N E U]
%output = [N E]

U = allDisplacement(Sources,Point, Terrain);
U = U(1:2);
