function [X,Y,Z] = graphMogiPressureSource(source)

cx = source.Parameters(1);
cy = source.Parameters(2);
cz = source.Parameters(3);
r = source.Parameters(4);

[x,y,z] = sphere(20); 


X = r*x+cx;
Y = r*y+cy;
Z = r*z+cz;

