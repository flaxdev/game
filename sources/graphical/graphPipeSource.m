function [X,Y,Z] = graphPipeSource(source)


E=source.Parameters(1);
N=source.Parameters(2);

c1 = source.Parameters(3);
c2 = source.Parameters(4);

d = source.Parameters(5);


[x,y,z] = ellipsoid(0,0,0,d,d,c1-c2,20);

X = x+E;
Y = y+N;
Z = z+(c1+c2)/2;