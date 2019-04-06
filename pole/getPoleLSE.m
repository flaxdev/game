function [latitude longitude omega] = getPoleLSE(ITRF)

R = 6378137;
[L, A, C] = setLinearEq(ITRF,R);


C_ = C^-1;
W = ((A' * C_ * A)^-1)*(A')*C_*L;
CW = (A' * C_ * A)^-1;
CW = CW*1e12;

nW = norm(W);

X = R * W(1)/nW;
Y = R * W(2)/nW;
Z = R * W(3)/nW;

[latitude, longitude] = ecef2geo([X,Y,Z]);

lat = latitude *pi/180;
lon = longitude *pi/180;

RT = [ -sin(lat)*cos(lon)  -sin(lat)*sin(lon)   cos(lat)
       -sin(lon)               cos(lon)           0
       cos(lat)*cos(lon)    cos(lat)*sin(lon)    sin(lat)];
   
L = R*RT*W;

omega = 180*norm(L)/1e-6/pi;
