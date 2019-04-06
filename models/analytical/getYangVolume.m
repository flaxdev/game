function U = getYangVolume(params, Stations, Terrain)

nu = Terrain.Poisson;
rmu = Terrain.rmu;
%Compute displacements

param(1) = params(1)/1000;
param(2) = params(2)/1000;
param(3) = -(params(3)-Stations(3))/1000;

% Per Tiampo et al. 2000
Pa3 = params(4)*rmu/(params(5)^2)/pi;

% vuole la pressione P
param(4) = params(8)/(rmu*1e-5); % li trasformo in mu * 10-5 Pa
param(5) = ((Pa3/abs(params(8)))^(1/3))/1000;
param(6) = params(5);
param(7) = params(6);
param(8) = params(7);


coord = [Stations(2); Stations(1)]/1000;

[u]=yang_source(param,coord,nu);

U=[u(2), u(1), u(3)]/100;

function [u]=yang_source(param,coord,nu)
%   yang_source        - displacement due to a Yang source (simplified, no topo, equal Lame const)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Surface Displacements Due to a Yang source
% Falk Amelung, Mar 2002. 
% based on Yuri Fialko's fcn_yangM.m
%
% SIMPLIFIED:  Yuri allows for topo and different lame's parameter #########
%
%  Input:
%        param    8*1 parameters for yang source
%                     param(1) :  x-coordinate of center of source (km)
%                     param(2) :  y-coordinate of center of source (km)
%                     param(3) :  depth of center of source
%                     param(4) :  excess pressure, mu*10^(-5) Pa
%                     param(5) :  major axis, km
%                     param(6) :  ratio min-axis/may-axis  [0.01:0.99]
%                     param(7) :  strike (degree)
%                     param(8) :  plunge (degree)
%
%        coord   2*N  array  with x,y coordinates of datavec
%                     where the model displacement will be computed
%        
%  Output:
%        u        3*N array with displacement coordinates   [ux uy uz]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% start of Falk's changes %%%%


param(7)=deg2rad(param(7)); param(8)=deg2rad(param(8));
param(6)=param(5)*param(6);
as=param;
x=coord(1,:);
y=coord(2,:);
matrl(1)=1 ;
matrl(2)=1 ;
matrl(3)=nu ;
tp=zeros(size(x));
%%% end of Falk's changes %%%%

% Calculate range displacement 
mu=matrl(2);
nu=matrl(3);

% Store some commonly used parameters
coeffs(1)=1/(16*mu*(1-nu));
coeffs(2)=3-4*nu;
coeffs(3)=4*(1-nu)*(1-2*nu);

[ix,iy]=size(x);
U1r=zeros(ix,iy);
U2r=zeros(ix,iy);
U1=zeros(ix,iy);
U2=zeros(ix,iy);
U3=zeros(ix,iy);

% explicitly assign source parameters
%as
 xs    = as(1);     % center x
 ys    = as(2);     % center y
 z0    = as(3);     % center depth (positive)
 P     = as(4);     % excess pressure, mu*10^(-5) Pa
 a     = as(5);     % major axis, km
 b     = as(6);     % minor axis, km
 phi   = as(7);     % strike, rad  (0-pi)
 theta = as(8);     % plunge, rad  (0-2*pi)
 xn=x-xs;
 yn=y-ys;
 e_theta(1)=sin(theta);
 e_theta(2)=cos(theta);
 cosp=cos(phi);
 sinp=sin(phi);
 c=sqrt(a^2-b^2);
 minx=min(min(x));
 maxx=max(max(x));
 miny=min(min(y));
 maxy=max(max(y));
% if xs < minx | xs > maxx | ys < miny | ys > maxy % source is outside the grid
%  P=0;
% end

% Speroid quantities
 [sph]=spheroid(a,b,c,matrl,phi,theta,P);

% Rotate points
 xp=xn*cosp + yn*sinp;
 yp=yn*cosp - xn*sinp;

% Calculate model at integration limits
 xi=c;
 [Up1,Up2,Up3]=yang(sph,xi,z0,xp,yp,0,matrl,e_theta,coeffs,tp);
 xi=-xi;
 [Um1,Um2,Um3]=yang(sph,xi,z0,xp,yp,0,matrl,e_theta,coeffs,tp);

% Sum
 U1r=-Up1+Um1;
 U2r=-Up2+Um2;
% Rotate horiz. displacements back to the orig. coordinate system:
 U1=U1r*cosp-U2r*sinp+U1;
 U2=U1r*sinp+U2r*cosp+U2;
 U3=Up3-Um3+U3;

u=[U1;U2;U3];


function [sph]=spheroid(a,b,c,matrl,phi,theta,P)
% Calculate spheroid parameters and save in output vector sph

lamda=matrl(1);
mu=matrl(2);
nu=matrl(3);
% Model expressions
ac=(a-c)/(a+c);
L1=log(ac);
%L1=log((a-c)/(a+c));
iia=2/a/c^2 + L1/c^3;
iiaa=2/3/a^3/c^2 + 2/a/c^4 + L1/c^5;
coef1=-2*pi*a*b^2;
Ia=coef1*iia;
Iaa=coef1*iiaa;
u=8*pi*(1-nu);
Q=3/u;
R=(1-2*nu)/u;
a11=2*R*(Ia-4*pi);
a12=-2*R*(Ia+4*pi);
a21=Q*a^2*Iaa + R*Ia - 1;
a22=-(Q*a^2*Iaa + Ia*(2*R-Q));
coef2=3*lamda+2*mu;
w=1/(a11*a22-a12*a21);
e11=(3*a22-a12)*P*w/coef2;
e22=(a11-3*a21)*P*w/coef2;
Pdila=2*mu*(e11-e22);
Pstar=lamda*e11 + 2*(lamda+mu)*e22;
a1=-2*b^2*Pdila;
b1=3*b^2*Pdila/c^2 + 2*(1-2*nu)*Pstar; % !PL version had (1-nu) in the 2nd term!

sph(1)  = a;
sph(2)  = b;
sph(3)  = c;
sph(4)  = phi;
sph(5)  = theta;
sph(6)  = Pstar;
sph(7)  = Pdila;
sph(8)  = a1;
sph(9)  = b1;
sph(10) = P;


function [u1,u2,u3]=yang(sph,xi,z0,x,y,z,matrl,e_theta,coeffs,tp)
% Calculate the double force (star) and dilatation (dila) displacements U
% for a SPHEROIDAL pressure source in an elastic halfspace 
% (based on Yang et al., vol 93, JGR, 4249-4257, 1988) with arbitrary plunge (theta)
% of the long axis of the spheroid (theta = 90, prolate; theta = 0, oblate).
% Evaluate at for xi.
%
% Inputs: theta: dip angle of source
%             P: pressure change in magma chamber
%             a: semimajor axis of spheroid
%             b: semiminor axis of spheriod
%            xi: evaluate integrals at +- c
%            z0: depth of source (allowed to vary with topo)
%             x: x location of point on surface
%             y: y location of point on surface
% Output: rd: calculated range displacement
% NOTE: the x, y locations assume a source at origin
% ALSO: the units need to be in mks units so input x, y, and z0
%       in km will be changed into meters
% NOTE: In the expressions of Yang et al. the spheroid dips parallel to the y axis
%       at x=0. We will assume (initially) that it is also centered at y=0.
epsn=1e-15;

% Get spheroid information
a     = sph(1);
b     = sph(2);
c     = sph(3);
phi   = sph(4);
theta = sph(5);
Pstar = sph(6);
Pdila = sph(7);
a1    = sph(8);
b1    = sph(9);
P     = sph(10);

sinth = e_theta(1);
costh = e_theta(2);

%Poisson's ratio, Young's modulus, and the Lame coeffiecents mu and lamda
nu=matrl(3);

nu4=coeffs(2);
nu2=1-2*nu;
nu1=1-nu;
coeff=a*b^2/c^3*coeffs(1);

% Introduce new coordinates and parameters (Yang et al., 1988, page 4251):
xi2=xi*costh;
xi3=xi*sinth;
y0=0;
%z=0;
z00=tp+z0;
x1=x;
x2=y-y0;
x3=z-z00;
xbar3=z+z00;
y1=x1;
y2=x2-xi2;
y3=x3-xi3;
ybar3=xbar3+xi3;
r2=x2*sinth-x3*costh;
q2=x2*sinth+xbar3*costh;
r3=x2*costh+x3*sinth;
q3=-x2*costh+xbar3*sinth;
rbar3=r3-xi;
qbar3=q3+xi;
R1=(y1.^2+y2.^2+y3.^2).^(0.5);
R2=(y1.^2+y2.^2+ybar3.^2).^(0.5);

C0=y0*costh+z00*sinth;  % da rivedere
%C0=z00/sinth; 

betatop=(costh*q2+(1+sinth)*(R2+qbar3));
betabottom=costh*y1;
%atnbeta=atan2(betatop,betabottom);
%atnbeta=atan(betatop./betabottom);
nz=find(abs(betabottom)~=0);
atnbeta=pi/2*sign(betatop);
atnbeta(nz)=atan(betatop(nz)./betabottom(nz));

% Set up other parameters for dipping spheroid (Yang et al., 1988, page 4252):
% precalculate some repeatedly used natural logs:
Rr=R1+rbar3;
Rq=R2+qbar3;
Ry=R2+ybar3;
lRr=log(Rr);
lRq=log(Rq);
lRy=log(Ry);

A1star=a1./(R1.*Rr) + b1*(lRr+(r3+xi)./Rr);
Abar1star=-a1./(R2.*Rq) - b1*(lRq+(q3-xi)./Rq);
A1=xi./R1 + lRr;
Abar1=xi./R2 - lRq;
A2=R1-r3.*lRr;
Abar2=R2 - q3.*lRq;
A3=xi*rbar3./R1 + R1;
Abar3=xi*qbar3./R2 -R2;

B=xi*(xi+C0)./R2 - Abar2 - C0.*lRq;
Bstar=a1./R1 + 2*b1*A2 + coeffs(2)*(a1./R2 + 2*b1*Abar2);
F1=0;
F1star=0;
F2=0;
F2star=0;
% Skip if displacement calculated at surface (z=0)
if z ~= 0
  F1=-2*sinth*z*(xi*(xi+C0)./R2.^3 + (R2+xi+C0)./(R2.*(Rq)) + ...
     4*(1-nu)*(R2+xi)./(R2.*(Rq)));
  F1star=2*z*(costh*q2.*(a1*(2*Rq)./(R2.^3.*(Rq).^2) - ...
         b1*(R2+2*xi)./(R2.*(Rq).^2)) + ...
         sinth*(a1./R2.^3 -2*b1*(R2+xi)./(R2.*(Rq))));
  F2=-2*sinth*z*(xi*(xi+C0).*qbar3./R2.^3 + C0./R2 + (5-4*nu)*Abar1);
  F2star=2*z*(a1*ybar3./R2^3 - ...
         2*b1*(sinth*Abar1 + costh*q2.*(R2+xi)./(R2.*Rq)));
end

% calculate little f's
ff1=xi*y1./Ry + 3/(costh)^2*(y1.*lRy*sinth - ...
    y1.*lRq + 2*q2.*atnbeta) + 2*y1.*lRq - 4*xbar3.*atnbeta/costh;
ff2=xi*y2./Ry + 3/(costh)^2*(q2.*lRq*sinth - ...
    q2.*lRy + 2*y1.*atnbeta*sinth + costh*(R2-ybar3)) - ...
    2*costh*Abar2 + 2/costh*(xbar3.*lRy - q3.*lRq);
ff3=(q2.*lRq - q2.*lRy*sinth + 2*y1.*atnbeta)/costh + ...
    2*sinth*Abar2 + q3.*lRy - xi;

% Assemble into x, y, z displacements (1,2,3):
u1=coeff*(A1star + nu4*Abar1star + F1star).*y1;
u2=coeff*(sinth*(A1star.*r2+(nu4*Abar1star+F1star).*q2) + ...
       costh*(Bstar-F2star) + 2*sinth*costh*z*Abar1star);
u3=coeff*(-costh*(Abar1star.*r2+(nu4*Abar1star-F1star).*q2) + ...
       sinth*(Bstar+F2star) + 2*(costh)^2*z*Abar1star);
u1=u1+2*coeff*Pdila*((A1 + nu4*Abar1 + F1).*y1 -coeffs(3)*ff1);
u2=u2+2*coeff*Pdila*(sinth*(A1.*r2+(nu4*Abar1+F1).*q2) - ...
       coeffs(3)*ff2 + 4*nu1*costh*(A2+Abar2) + ...
       costh*(A3 - nu4*Abar3 - F2));
u3=u3+2*coeff*Pdila*(costh*(-A1.*r2 + (nu4*Abar1 + F1).*q2) + ...
       coeffs(3)*ff3 + 4*nu1*sinth*(A2+Abar2) + ...
       sinth*(A3 + nu4*Abar3 + F2 - 2*nu4*B));

