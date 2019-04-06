function [X,Y,Z] = graphOpenPipeSource(source)


E=source.Parameters(1);
N=source.Parameters(2);

c0 = source.Parameters(3);
c2 = source.Parameters(5);

d = source.Parameters(6);


[x,y,z] = ellipsoid(0,0,0,d,d,c0-c2,20);

X = x+E;
Y = y+N;
Z = z+(c0+c2)/2;