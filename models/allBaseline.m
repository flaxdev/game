function s = allBaseline(Sources, Point, Terrain)
%Point [N E U]



Ua = allDisplacement(Sources, Point(1:3), Terrain);
Ub = allDisplacement(Sources, Point(4:6), Terrain);

d0 = norm(Point(1:3)-Point(4:6));
d = norm((Point(1:3)+Ua)-(Point(4:6)+Ub));

s = d-d0;