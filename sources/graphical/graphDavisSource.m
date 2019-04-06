function [X,Y,Z] = graphDavisSource(source)

e1 = -source.Parameters(5)*pi/180;
e2 = -source.Parameters(6)*pi/180;
e3 = -source.Parameters(7)*pi/180;

ba = source.Parameters(8);
ca = source.Parameters(9);

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);

a = (sqrt(abs(source.Parameters(10)*source.Parameters(4)))*3/((pi*4)*ba*ca))^(1/3);

[x,y,z] = ellipsoid(0,0,0,a,a*ba,a*ca,20);


% quasi giusti
% % % % % % % % % % % ch = cos(e1); sh = sin(e1);
% % % % % % % % % % % ca = cos(e2); sa = sin(e2);
% % % % % % % % % % % cb = cos(e3); sb = sin(e3);
% % % % % % % % % % % 
% % % % % % % % % % % R = [ch*ca, -ch*sa*cb + sh*sb, ch*sa*sb + sh*cb
% % % % % % % % % % %     sa, ca*cb, -ca*sb
% % % % % % % % % % %     -sh*ca, sh*sa*cb + ch*sb, - sh*sa*sb + ch*cb];
% % % % % % % % % % % 

A = [1 0 0 ; 0 cos(e1) sin(e1) ; 0 -sin(e1) cos(e1)];
B = [cos(e2) sin(e2) 0; -sin(e2) cos(e2) 0; 0 0 1];
C = [cos(e3) 0 sin(e3); 0 1 0; -sin(e3) 0 cos(e3)];

R = (C*B*A);


for i=1:size(x,1)
    for j=1:size(x,2)
        xyz = [x(i,j); y(i,j); z(i,j)];
        XYZ = (R*xyz);
%         x(i,j) = XYZ(2);
%         y(i,j) = XYZ(3);
%         z(i,j) = XYZ(1);
        x(i,j) = XYZ(1);
        y(i,j) = XYZ(2);
        z(i,j) = XYZ(3);
    end
end


X = x+cx;
Y = y+cy;
Z = z+cz;