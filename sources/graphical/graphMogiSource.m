function [X,Y,Z] = graphMogiSource(source)

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);
V = source.Parameters(4);

r = (abs(V)*3/(4*pi))^(1/2);

[x,y,z] = sphere(20); 


X = r*x+cx;
Y = r*y+cy;
Z = r*z+cz;

gg = 3;