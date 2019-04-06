function [X,Y,Z] = graphOkadaSource(source)

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);

AZIM = deg2rad(source.Parameters(4));
DIP = deg2rad(source.Parameters(5));
LEN2 = source.Parameters(6)/2;
WID = source.Parameters(7);

x(1) = 0;
y(1) = LEN2;
z(1) = 0;

x(2) = 0;
y(2) = -LEN2;
z(2) = 0;

x(3) = WID*cos(DIP)*sign(DIP);
y(3) = y(2);
z(3) = 0 - WID*sin(DIP)*sign(DIP);

x(4) = x(3);
y(4) = y(1);
z(4) = z(3);

x(5) = x(1);
y(5) = y(1);
z(5) = z(1);

sX = linspace(min(x),max(x),20);
sY = linspace(min(y),max(y),20);

[XX,YY] = meshgrid(sX,sY);

Z = z(1) + (z(3)-z(1))*XX/x(3);

YY = YY;
ZZ = Z;

X = XX*cos(AZIM) + YY*sin(AZIM);
Y = -XX*sin(AZIM) + YY*cos(AZIM);
Z = ZZ;

X = X + cx;
Y = Y + cy;
Z = Z + cz;

% plot3(x,y,z)
% X = x;
% Y = y;
% Z = z;

