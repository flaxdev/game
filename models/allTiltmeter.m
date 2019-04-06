function T = allTiltmeter(Sources, Point, Terrain)
%Point [N E U]
%output = [Nmicroradians Emicroradians]


microd = 1;

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) - microd;
U1 = allDisplacement(Sources, TmpPoint, Terrain);

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) + microd;
U2 = allDisplacement(Sources, TmpPoint, Terrain);

T(2) = ((U2(3)-U1(3))/(2*microd))*1e6;

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) - microd;
U1 = allDisplacement(Sources, TmpPoint, Terrain);

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) + microd;
U2 = allDisplacement(Sources, TmpPoint, Terrain);

T(1) = ((U2(3)-U1(3))/(2*microd))*1e6;

