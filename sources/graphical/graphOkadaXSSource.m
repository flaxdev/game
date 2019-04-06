function [X,Y,Z] = graphOkadaXSSource(source)

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);

X = 0;
Y = 0;

X0 = source.Parameters(1);
Y0 = source.Parameters(2);
depth = -source.Parameters(3);

L = source.Parameters(6);
W = source.Parameters(7);

plunge = source.Parameters(11);
strike = source.Parameters(4);
dip = source.Parameters(5);
opening = source.Parameters(10);

Stks = source.Parameters(8);
Dips = source.Parameters(9);

rake = atand(Dips/Stks);
slip = sqrt(Dips^2 + Stks^2);

nu = 0.25;
% ###################################


[~,~,~, P1, P2, P3, P4]=RDdispSurf(X,Y,X0,Y0,depth,L,W,plunge,dip,strike, rake,slip,opening,nu);


x = [P1(1), P2(1), P3(1), P4(1), P1(1)];
y = [P1(2), P2(2), P3(2), P4(2), P1(2)];
z = [P1(3), P2(3), P3(3), P4(3), P1(3)];

X = repmat(x,4,1)';
Y = repmat(y',1,4);
Z = repmat(z',1,4);

% 
% 
% sX = linspace(min(x),max(x),20);
% sY = linspace(min(y),max(y),20);
% 
% [XX,YY] = meshgrid(sX,sY);
% 
% Z = z(1) + (z(3)-z(1))*XX/x(3);
% 
% YY = YY*cos(SLOPE) + Z*sin(SLOPE);
% ZZ = - YY*sin(SLOPE) + Z*cos(SLOPE);
% 
% X = XX*cos(AZIM) + YY*sin(AZIM);
% Y = -XX*sin(AZIM) + YY*cos(AZIM);
% Z = ZZ;
% 
% X = X + cx;
% Y = Y + cy;
% Z = Z + cz;
% 
% % plot3(x,y,z)
% % X = x;
% % Y = y;
% % Z = z;
% 
