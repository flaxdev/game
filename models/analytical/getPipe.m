function U = getPipe(params, Stations, Terrain)

nu = Terrain.Poisson;
pir = Terrain.rmu;
%Compute displacements

	E=params(1)-Stations(2);
	N=params(2)-Stations(1);
    
    c1 = - (Stations(3) - params(3));
    c2 = - (Stations(3) - params(4));
    
    d = params(5);
    
    P = params(6);
    
    a2 = E^2 + N^2;
    n = 1/3;
    m = 0.75*P*d*d/pir;
    
    
    R1 = sqrt(a2 + c1^2);
    R2 = sqrt(a2 + c2^2);
    
    Hoz = (2*(1-2*nu)/a2)*(c2/R2 - c1/R1) - (n/a2)*( (c2/R2)^3 - 2*nu*c2/R2 - (c1/R1)^3 + 2*nu*c1/R1 );
    
    Ver = 2*(1-2*nu)*(1/R2 - 1/R1) - n*( (3-2*nu)/R2 - a2/(R2^3) - (3-2*nu)/R1 + a2/(R1^3) );
    
	U= m*[N*Hoz, E*Hoz, -Ver];
