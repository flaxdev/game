function U = getMogi(params, Stations, Terrain)

nu = Terrain.Poisson;
%Compute displacements 
% params(4) = dV
% 
% ref https://earth.esa.int/documents/10174/643007/D5T1a_2_WRIGHT_LTC2013.pdf
	E=params(1)-Stations(2);
	N=params(2)-Stations(1);
	E2=E.^2;
	N2=N.^2;
	d2=(Stations(3)-params(3))^2;
	C=(nu-1)*params(4)/pi;
	R=sqrt(d2+E2+N2);
	R3=C*R.^-3;
	U=[N.*R3, E.*R3, -(Stations(3)-params(3))*R3];
