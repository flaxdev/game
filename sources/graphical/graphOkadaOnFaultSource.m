function [X,Y,Z] = graphOkadaOnFaultSource(source)

% point = [(-source.Parameters(5)) (source.Parameters(4)) 0];
% 
% rot1 = [cosd(source.Parameters(3)), sind(source.Parameters(3)), 0
%         -sind(source.Parameters(3)), cosd(source.Parameters(3)), 0
%         0,0,1];
%     
% rot2 = [cosd(source.Parameters(6)), 0, sind(source.Parameters(6))
%         0,1,0
%         -sind(source.Parameters(6)), 0, cosd(source.Parameters(6))];
% 
% newpoint = point*rot1*rot2;

% vectxy = source.Parameters(5)*cosd(source.Parameters(6))*[sind(source.Parameters(3)), cosd(source.Parameters(3))];
% cx = source.Parameters(1) + source.Parameters(4)*cosd(90-source.Parameters(3)) + vectxy(1);
% cy = source.Parameters(2) + source.Parameters(4)*sind(90-source.Parameters(3)) + vectxy(2);
% cz = source.Parameters(5)*sind(source.Parameters(6));

% cx = source.Parameters(1) + newpoint(1);
% cy = source.Parameters(2) + newpoint(2);
% cz = -newpoint(3);
% 
cx = source.Parameters(1) + source.Parameters(4)*cosd(90-source.Parameters(3)) + source.Parameters(5)*cosd(source.Parameters(6))*cosd(-source.Parameters(3));
cy = source.Parameters(2) + source.Parameters(4)*sind(90-source.Parameters(3)) + source.Parameters(5)*cosd(source.Parameters(6))*sind(-source.Parameters(3));
cz = source.Parameters(5)*sind(source.Parameters(6));


AZIM = deg2rad(source.Parameters(3));
DIP = deg2rad(source.Parameters(6));
LEN2 = source.Parameters(7);
WID = source.Parameters(8);
SLOPE = 0;

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

YY = YY*cos(SLOPE) + Z*sin(SLOPE);
ZZ = - YY*sin(SLOPE) + Z*cos(SLOPE);

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

