function U = getSill(params, Stations, Terrain)

nu = Terrain.Poisson;
rmu = Terrain.rmu;


%Compute displacements
x = Stations(2);
y = Stations(1);
z = -Stations(3);

x0 = params(1);
y0 = params(2);
z0 = -params(3);
a = params(4); % radius
P = params(5); P_G = P/rmu;
  
    [u, v, w] = fialkodisp(x0,y0,z0,P_G,a,nu,x,y,z);
     U = [v, u, w];
     

    