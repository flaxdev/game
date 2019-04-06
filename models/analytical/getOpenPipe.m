function U = getOpenPipe(params, Stations, Terrain)

nu = Terrain.Poisson;
pir = Terrain.rmu;
%Compute displacements

	E=params(1)-Stations(2);
	N=params(2)-Stations(1);
    
    c0 = (Stations(3) - params(3));
    c1 = (Stations(3) - params(4));
    c2 = (Stations(3) - params(5));
    
    alpha = params(6);
       
    dP = -params(7);
    
    
    
    b = alpha*dP/pir;
    
    
    r2 = E^2 + N^2;
    R0 = sqrt(r2 + c0^2);
    R1 = sqrt(r2 + c1^2);
    R2 = sqrt(r2 + c2^2);
    
    Hoz1 = 0.5*b*alpha*((c1/R1)^3 - 2*c1*(1+nu)/R1 + ((c2^3)*(1+2*nu) + 2*c2*r2*(1+nu))/(R2^3) )/r2;
    
    Ver1 = -0.5*b*alpha*((c1^2)/(R1^3) - 2*nu/R1 + (2*nu*R2^2 - c2^2)/(R2^3));
    
	U= [N*Hoz1, E*Hoz1, -Ver1];
    
    
    Hoz2 = 0.5*b*alpha*(-(c0^2)/(R0^3) + 2*nu/R0 + (c1^2 - 2*(c1^2 + r2)*nu)/(R1^3))/c1;
    Ver2 = - 0.5*b*alpha*((c0/R0)^3 - (c1/R1)^3 + c1*(2*nu-1)/R1 + c0*(1-2*nu)/R0 + (2*nu-1)*log(c0+R0) - (2*nu-1)*log(c1+R1) )/c1;
    
	U= U + [N*Hoz2, E*Hoz2, -Ver2];
    
