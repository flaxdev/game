function [u v w] = mctigue3Ddispl(x0,y0,z0,P_G,a,nu,x,y,z)
% 3D Green's function for spherical source
% 
% all parameters are in SI (MKS) units
% u         horizontal (East component) deformation
% v         horizontal (North component) deformation
% w         vertical (Up component) deformation
% x0,y0     coordinates of the center of the sphere 
% z0        depth of the center of the sphere (positive downward and
%              defined as distance below the reference surface)
% P_G       dimensionless excess pressure (pressure/shear modulus)
% a         radius of the sphere
% nu        Poisson's ratio
% x,y       benchmark location
% z         depth within the crust (z=0 is the free surface)
% 
% Reference ***************************************************************
% McTigue, D.F. (1987). Elastic Stress and Deformation Near a Finite 
% Spherical Magma Body: Resolution of the Point Source Paradox. J. Geophys.
% Res. 92, 12,931-12,940.
% *************************************************************************
% USGS Software Disclaimer 
% The software and related documentation were developed by the U.S. 
% Geological Survey (USGS) for use by the USGS in fulfilling its mission. 
% The software can be used, copied, modified, and distributed without any 
% fee or cost. Use of appropriate credit is requested. 
%
% The USGS provides no warranty, expressed or implied, as to the correctness 
% of the furnished software or the suitability for any purpose. The software 
% has been tested, but as with any complex software, there could be undetected 
% errors. Users who find errors are requested to report them to the USGS. 
% The USGS has limited resources to assist non-USGS users; however, we make 
% an attempt to fix reported problems and help whenever possible. 
%==========================================================================


% translate the coordinates of the points where the displacement is computed
% in the coordinates system centered in (x0,y0)
xxn = x - x0;
yyn = y - y0;

% radial distance from source center to points where we compute ur and uz
r = sqrt(xxn.^2+yyn.^2);

% dimensionless parameters used in the formulas
rho = r/z0; e = a/z0; zeta = z/z0; 


% DIMENSIONLESS DISPLACEMENT **********************************************

% leading order solution for a pressurized sphere in an unbounded region
% based on equation (11) of McTigue (1987)
uz0 = e^3*0.25*(1-zeta)./(rho.^2+(1-zeta).^2).^1.5;                           % return equation (14) when zeta=0
%uz0 = e^3*0.25./(rho.^2+(1-zeta).^2).^1.5;                           % return equation (14) when zeta=0
ur0 = e^3*0.25*rho./(rho.^2+(1-zeta).^2).^1.5;                               % return equation (15) when zeta=0


% first free surface correction, equations (A7), (A8), (A17) and (A18) 
% return equation (22) and (23) when csi = 0
Auz1 = zeros(length(zeta),length(rho));
Aur1 = zeros(length(zeta),length(rho));
for i=1:length(zeta)
    for j=1:length(rho)
    Auz1(i,j) = quadl(@(xx) mctigueA7A17(xx,nu,rho(j),zeta(i)),0,50);
    Aur1(i,j) = quadl(@(xx) mctigueA8A18(xx,nu,rho(j),zeta(i)),0,50);
    end;
end;


% higher order cavity correction, equations (38) and (39)
R = sqrt(rho.^2+(1-zeta).^2);
sint = rho./R; cost = (1-zeta)./R;
C3 = [e*(1+nu)/(12*(1-nu)) 5*e^3*(2-nu)/(24*(7-5*nu))];                     % equation (40)
D3 = [-e^3*(1+nu)/12 e^5*(2-nu)/(4*(7-nu))];                                % equation (41)
P0 = 1; P2 = 0.5*(3*cost.^2-1);                                             % Legendre polynomials (after Wikipedia)
dP0 = 0; dP2 = 3*cost;
ur38 = -0.5*P0*D3(1)./R.^2 + (C3(2)*(5-4*nu)-1.5*D3(2)./R.^2).*P2./R.^2;    % equation (38)
ut39 = -(2*C3(1)*(1-nu)-0.5*D3(1)./R.^2)*dP0 -...   
                            (C3(2)*(1-2*nu)+0.5*D3(2)./R.^2).*dP2./R.^2;    % equation (39)
ut39 = ut39.*sint;
Auz3 = ur38.*cost - ut39.*sint;                                             % surface displacement, return equation (46) when zeta=0
Aur3 = ur38.*sint + ut39.*cost;                                             % surface displacement, return equation (47) when zeta=0

% sixth order surface correction, return equation (50) and (51) when zeta=0
Auz6 = zeros(length(zeta),length(rho));
Aur6 = zeros(length(zeta),length(rho));
for i=1:length(zeta)
    for j=1:length(rho)
    Auz6(i,j) = quadl(@(xx) mctigueA7A17a(xx,nu,rho(j),zeta(i)),0,50);
    Aur6(i,j) = quadl(@(xx) mctigueA8A18a(xx,nu,rho(j),zeta(i)),0,50);
    end;
end;

% total surface displacement, return equation (52) and (53) when zeta = 0
if size(uz0,1) == size(Auz1,2)
    Auz1 = Auz1';
    Aur1 = Aur1';
end;
if size(uz0,1) == size(Auz6,2)
    Auz6 = Auz6';
    Aur6 = Aur6';
end;
uz = uz0 + e^3*Auz1 + e^3*Auz3 + e^6*Auz6;
%uz = e^3*Auz6;
ur = ur0 + e^3*Aur1 + e^3*Aur3 + e^6*Aur6;

% displacement components
u = ur.*xxn./r;         % East
v = ur.*yyn./r;         % North
w = uz;                 % Up    
% *************************************************************************

% DIMENSIONAL DISPLACEMENT ************************************************
u = u*P_G*z0;
v = v*P_G*z0;
w = w*P_G*z0;
% *************************************************************************



