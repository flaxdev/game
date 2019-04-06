function s = allStrainmeter(Sources, Point, Terrain)
%Point [N E U]
%output = microstrain

deltam = 1;


% X East
TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) - deltam;
U_1 = allDisplacement(Sources, TmpPoint, Terrain);
% reformat the vector XYZ (ENU)
U_1 = U_1([2 1 3]);


TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) + deltam;
U1 = allDisplacement(Sources, TmpPoint, Terrain);
% reformat the vector XYZ (ENU)
U1 = U1([2 1 3]);

TX = (U1-U_1)/(2*deltam);
dx = U1(1)-U_1(1);

% Y North
TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) - deltam;
U_1 = allDisplacement(Sources, TmpPoint, Terrain);
% reformat the vector XYZ (ENU)
U_1 = U_1([2 1 3]);

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) + deltam;
U1 = allDisplacement(Sources, TmpPoint, Terrain);
% reformat the vector XYZ (ENU)
U1 = U1([2 1 3]);

TY = (U1-U_1)/(2*deltam);
dy = U1(2)-U_1(2);

% % Z Up
% TmpPoint = Point;
% TmpPoint(3) = TmpPoint(3) - deltam;
% U_1 = allDisplacement(Sources, TmpPoint, Terrain);
% % reformat the vector XYZ (ENU)
% U_1 = U_1([2 1 3]);
% 
% TmpPoint = Point;
% TmpPoint(3) = TmpPoint(3) + deltam;
% U1 = allDisplacement(Sources, TmpPoint, Terrain);
% % reformat the vector XYZ (ENU)
% U1 = U1([2 1 3]);
% 
% TZ = -(U1-U_1)/(2*deltam);
% dz = -(U1(3)-U_1(3));
% 
% % Tensore
% T = [TX(1),               (TY(1)+TX(2))/2,         (TZ(1)+TX(3))/2
%     (TX(2)+TY(1))/2,             TY(2),            (TZ(2)+TY(3))/2             
%     (TX(3)+TZ(1))/2,      (TY(3)+TZ(2))/2,              TZ(3)];              

%%
% For most of the problems, the planar surface of
% the elastic half-space  is free of
% out-of-plane stress and is
% called the free surface.
s = (TX(1)+TY(2))*1e6*(1-2*Terrain.Poisson)/(1-Terrain.Poisson);


