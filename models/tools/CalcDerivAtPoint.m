function [u1_1 u1_2 u2_1 u2_2 u3_1 u3_2] = CalcDerivAtPoint(Sources,Point, Terrain)

%Point [N E U]
% Output 1 = North
%        2 = East
%        3 = Up

delta = 100; %m

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) - delta;
Ua = allDisplacement(Sources, TmpPoint, Terrain, 0);

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) + delta;
Ub = allDisplacement(Sources, TmpPoint, Terrain, 0);

u1_1 = ((Ub(1)-Ua(1))/(2*delta));
u2_1 = ((Ub(2)-Ua(2))/(2*delta));
u3_1 = ((Ub(3)-Ua(3))/(2*delta));

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) - delta;
Ua = allDisplacement(Sources, TmpPoint, Terrain, 0);

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) + delta;
Ub = allDisplacement(Sources, TmpPoint, Terrain, 0);

u1_2 = ((Ub(1)-Ua(1))/(2*delta));
u2_2 = ((Ub(2)-Ua(2))/(2*delta));
u3_2 = ((Ub(3)-Ua(3))/(2*delta));


