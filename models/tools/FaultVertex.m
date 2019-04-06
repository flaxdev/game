function [X,Y,Z] = FaultVertex(SingleFaultGeometry)

% FAULT GEOMETRY DEFINITION
%1 X(m, center top),  
%2 Y(m, center top),  
%3 Depth(m, top, positive upwards), 
%4 Azimuth, 
%5 Dip,
%6 SemiLength (m)
%7 Width (m)


AZIM = SingleFaultGeometry(4);
DIP = SingleFaultGeometry(5);

cx = SingleFaultGeometry(1);
cy = SingleFaultGeometry(2);
cz = SingleFaultGeometry(3);

AZIM = deg2rad(SingleFaultGeometry(4));
DIP = deg2rad(SingleFaultGeometry(5));
LEN2 = SingleFaultGeometry(6);
WID = SingleFaultGeometry(7);

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

X = x*cos(AZIM) + y*sin(AZIM);
Y = -x*sin(AZIM) + y*cos(AZIM);
Z = z;

X = X([1 4; 2 3]) + cx;
Y = Y([1 4; 2 3]) + cy;
Z = Z([1 4; 2 3]) + cz;

% .........................
% 
% 
% [xi, xf, yi, yf, zt, zb] = ConvertOkadaParams(SingleFaultGeometry);
% 
% zt = -zt;
% zb = -zb;
% 
% x0 = xi + (zb-zt)*cosd(DIP)*cosd(AZIM);
% y0 = yi - (zb-zt)*cosd(DIP)*sind(AZIM);
% 
% x1 = xf + (zb-zt)*cosd(DIP)*cosd(AZIM);
% y1 = yf - (zb-zt)*cosd(DIP)*sind(AZIM);
% 
% 
% 
% X = [xi x0
%      xf x1];
% 
% Y = [yi y0
%      yf y1];
%  
% Z = [zt, zb
%      zt, zb];
% 
% function [xi, xf, yi, yf, zt, zb] = ConvertOkadaParams(SingleFaultGeometry)
% 
% % FAULT GEOMETRY DEFINITION
% %1 X(m, center top),  
% %2 Y(m, center top),  
% %3 Depth(m, top, positive upwards), 
% %4 Azimuth, 
% %5 Dip,
% %6 SemiLength (m)
% %7 Width (m)
% 
% if SingleFaultGeometry(4)<0
%     SingleFaultGeometry(4) = SingleFaultGeometry(4) + 360;
% end
% 
% xi = SingleFaultGeometry(1) + SingleFaultGeometry(6)*cosd(90-SingleFaultGeometry(4));
% yi = SingleFaultGeometry(2) + SingleFaultGeometry(6)*sind(90-SingleFaultGeometry(4));
% 
% xf = SingleFaultGeometry(1) - SingleFaultGeometry(6)*cosd(90-SingleFaultGeometry(4));
% yf = SingleFaultGeometry(2) - SingleFaultGeometry(6)*sind(90-SingleFaultGeometry(4));
% 
% 
% if SingleFaultGeometry(5) > 90
%     s = xi; xi = xf; xf = s;
%     s = yi; yi = yf; yf = s;
%     SingleFaultGeometry(5) = 180-SingleFaultGeometry(5);
% end    
% 
% zt = -SingleFaultGeometry(3);
% 
% zb = -SingleFaultGeometry(3) + SingleFaultGeometry(7)*sind(SingleFaultGeometry(5));
% 
% 
%     