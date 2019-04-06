function U = getMcTigue(params, Stations, Terrain)

nu = Terrain.Poisson;
G = Terrain.rmu;

%Compute displacements

	E=params(1)-Stations(2);
	N=params(2)-Stations(1);
	E2=E.^2;
	N2=N.^2;
    dP = params(5);
    a = params(4);
    d = (Stations(3)-params(3));
	d2=d^2;
	R=sqrt(d2+E2+N2);
    
    C = (a^3)*dP*(1-nu)/G;
    
	L = 1 + ((a/d)^3)*((1+nu)/(2*(-7+5*nu)) + 15*d2*(-2+nu)/(4*R*R*(-7+5*nu)) );
    
	K =C*L*R.^-3;
	U=[-N.*K, -E.*K, d*K];
