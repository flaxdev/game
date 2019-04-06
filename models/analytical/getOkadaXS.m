function U = getOkadaXS(params, Stations, Terrain)

% ###################################
X = Stations(2);
Y = Stations(1);
Z = Stations(3);

X0 = params(1);
Y0 = params(2);
Z0 = params(3);

L = params(6);
W = params(7);

plunge = params(11);
strike = params(4);
dip = params(5);
opening = params(10);

Stks = params(8);
Dips = params(9);

% rake = atand(-Dips/Stks);
% if isnan(rake)
%     rake = 0;
% end
% slip = sqrt(Dips^2 + Stks^2);

nu = Terrain.Poisson;
% ###################################
if (Z0>=0) && (Z>=Z0)
    [ue,un,uv]=RDdispSurf(X,Y,X0,Y0,Z-Z0,L,W,plunge,dip,strike, Stks,Dips,opening,nu);
elseif (Z0>=0) && (Z<Z0)
    [ue,un,uv]=RDdispHS(X,Y,Z-Z0,X0,Y0,0,L,W,plunge,dip,strike, Stks,Dips,opening,nu);
elseif (Z0<0) && (Z>=0)
    [ue,un,uv]=RDdispSurf(X,Y,X0,Y0,Z-Z0,L,W,plunge,dip,strike, Stks,Dips,opening,nu);
elseif (Z0<0) && (Z<0)
    [ue,un,uv]=RDdispHS(X,Y,Z,X0,Y0,-Z0,L,W,plunge,dip,strike, Stks,Dips,opening,nu);
end

U = [un, ue, uv];

