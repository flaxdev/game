function [X,Y,Z] = graphYangVolumeSource(source)

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);

% Per Tiampo et al. 2000
Pa3 = source.Parameters(4)*30e9/(source.Parameters(5)^2)/pi;

a = ((Pa3/abs(source.Parameters(8)))^(1/3));
ra = source.Parameters(5);
stk = -source.Parameters(6);
pln = source.Parameters(7);

[x,y,z] = ellipsoid(0,0,0,ra,1,ra,20);

A = [cosd(stk) -sind(stk) 0; sind(stk) cosd(stk) 0; 0 0 1];
B = [1 0 0; 0 cosd(pln) sind(pln);0 -sind(pln) cosd(pln)];

R = (A*B);


for i=1:size(x,1)
    for j=1:size(x,2)
        xyz = [x(i,j); y(i,j); z(i,j)];
        XYZ = (R*xyz);
        x(i,j) = XYZ(1);
        y(i,j) = XYZ(2);
        z(i,j) = XYZ(3);
    end
end



X = a*x+cx;
Y = a*y+cy;
Z = a*z+cz;

