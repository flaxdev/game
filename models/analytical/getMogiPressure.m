function U = getMogiPressure(params, Stations, Terrain)

nu = Terrain.Poisson;
mu = Terrain.rmu;

%Compute displacements

	E = params(1)-Stations(2);
	N = params(2)-Stations(1);
    F = (Stations(3)-params(3));
    P = params(5);
    A = params(4);
         
	E2=E.^2;
	N2=N.^2;

    r = sqrt(E2+N2);
    
%	if max(max(A))/min(min(F)) > .1
%		disp('Warning: inaccurate results if F is not much greater than A.')
%	end

	y = (A.^3).*P./mu;
    et = (1-nu).*y./((F.^2 + r.^2).^1.5);
    
    Ur = r.*et;
    Uv = F.*et;
    alf = atan2(N,E);
    U = [-Ur*sin(alf), -Ur*cos(alf), Uv];
    