function U = getPenny(params, Stations, Terrain)

persistent fi psi t Wt ph

nu = Terrain.Poisson;
rmu = Terrain.rmu;

E=params(1)-Stations(2);
N=params(2)-Stations(1);
H = - (params(3)-Stations(3));
R = params(4);
if R==0
    disp('Error: Radius cannot be 0');
    R = eps;
end
dP = params(5);

h = H/R;
r = sqrt(E.^2 + N.^2)/R;
if (r==0)
    r = 0.01/R;
end
coeff = 2*(1-nu)*R.*dP./rmu; 

% Matlab routine for calculating surface displacements due to a
% uniformly pressurized horizontal penny-shaped crack
% for details, see the 2001 GJI paper.
% v. 1.0 Yuri Fialko 7/11/2000

% The following parameters need to be user-supplied:   
nis=2;       % number of sub-intervals on [0,1] on which integration is done
             % using a 16-point Gauss quadrature (i.e., total of nis*16 points)
epsilon=1e-5;    % solution accuracy for Fredholm integral equations (stop 
             % iterations when relative change is less than eps)
% h=1;         % dimensionless crack depth (Depth/Radius ratio)
% r=[0:0.1:3]; % observation points at the surface 

% Solve a coupled system of Fredholm eqs. of 2nd kind for basis functions fi,psi
% t and Wt are nodes and weights of the num. integration quadrature
if isempty(ph) || (h~=ph)
 ph = h;
 [fi,psi,t,Wt]=fredholm(ph,nis,epsilon);
end

 [Uv,Ur]=intgr(r,fi,psi,h,Wt,t);  %calculate vertical and radial displ.
 alf = atan2(N,E);
 U = coeff*[-Ur*sin(alf), -Ur*cos(alf), -Uv];


 %-------------------------------------------------------------------------
 %----------
function [fi,psi,t,Wt]=fredholm(h,m,er)
% function [fi,psi,t,Wt]=fredholm(h,m,er)
% fi,psi: basis functions
% t: interval of integration
% m: size(t)
%er=1e-7;
lamda=2/pi;
[Root Weight] = RtWt();
NumLegendreTerms=length(Root);
t=zeros(1,m*NumLegendreTerms);
Wt=t;
for k=1:m
 for i=1:NumLegendreTerms
  d1=1/m;
  t1=d1*(k-1);
  r1=d1*k;
  j=NumLegendreTerms*(k-1)+i;
  t(j)=Root(i)*(r1-t1)*0.5+(r1+t1)*0.5;
  Wt(j)=0.5/m*Weight(i);
 end
end
fi1=-lamda*t;
psi1=zeros(size(t));
fi=zeros(size(t));
psi=zeros(size(t));
res=1e9;

while res > er
 for i=1:m*NumLegendreTerms
  fi(i)=-t(i)+sum(Wt.*(fi1.*fpkernel(h,t(i),t,1)+...,
         psi1.*fpkernel(h,t(i),t,3)));
  psi(i)=sum(Wt.*(psi1.*fpkernel(h,t(i),t,2)+...,
         fi1.*fpkernel(h,t(i),t,4)));
 end
 fi=fi*lamda;  psi=psi*lamda;
 % find maximum relative change
 [fim,im]=max(abs(fi1-fi));
 fim=fim/abs(fi(im));
 [psim,im]=max(abs(psi1-psi));
 psim=psim/abs(psi(im));
 res=max([fim psim]);
 fi1=fi;
 psi1=psi;
end %while
 

function [Uz,Ur]=intgr(r,fi,psi,h,Wt,t)
% function [Uz,Ur]=intgr(r,fi,psi,h,Wt,t)
% Uz(r),Ur(r) - vertical and radial displacements
% fi,psi: basis functions
% t: interval of integration

[s1,s2]=size(r);
Uz=zeros(size(r));
Ur=Uz;

for i=1:s1
 for j=1:s2
  Uz(i,j)= sum(Wt.*(fi.*(Q(h,t,r(i,j),1)+h*Q(h,t,r(i,j),2))+...,
            psi.*(Q(h,t,r(i,j),1)./t-Q(h,t,r(i,j),3))));
  Ur(i,j)=sum(Wt.*(psi.*((Q(h,t,r(i,j),4)-h*Q(h,t,r(i,j),5))./t-...,
           Q(h,t,r(i,j),6)+h*Q(h,t,r(i,j),7))-...,
           h*fi.*Q(h,t,r(i,j),8)));
 end
end

function [K]=Q(h,t,r,n)
% Kernels calculation 
K=[];
E=h^2+r^2-t.^2;
D=(E.^2+4*h^2*t.^2).^(0.5);
D3=D.^3;
%i=sqrt(-1);

switch n
case 1	%Q1
 K=sqrt(2)*h*t./(D.*sqrt(D+E));

case 2	%Q2
 K=1/sqrt(2)./D3.*(h*sqrt(D-E).*(2*E+D)-t.*sqrt(D+E).*(2*E-D));

case 3	%Q3
 K=1/sqrt(2)./D3.*(h*sqrt(D+E).*(2*E-D)+t.*sqrt(D-E).*(2*E+D));

case 4	%Q4
 K=t/r-sqrt(D-E)/r/sqrt(2);
% K=imag(sqrt(E+2*i*h.*t)/r);

case 5	%Q5
 K=-(h*sqrt(D-E)-t.*sqrt(D+E))./D/r/sqrt(2);

case 6	%Q6
 K=1/r-(h*sqrt(D+E)+t.*sqrt(D-E))./D/r/sqrt(2);
% K=1/r-real((h-i*t)/r./sqrt(E-2*i*h.*t));

case 7	%Q7
 K=r*sqrt(D+E).*(2*E-D)./D3/sqrt(2);
% K=real(r.*(E-2*i*h.*t).^(-3/2));

case 8	%Q8
 K=r*sqrt(D-E).*(2*E+D)./D3/sqrt(2);
% K=imag(r.*(E-2*i*h.*t).^(-3/2));

case 41	%Q4*r
 K=t-sqrt(D-E)/sqrt(2);
% K=imag(sqrt(E+2*i*h.*t)/r);

case 51	%Q5*r
 K=-(h*sqrt(D-E)-t.*sqrt(D+E))./D/sqrt(2);

case 61	%Q6*r
 K=1-(h*sqrt(D+E)+t.*sqrt(D-E))./D/sqrt(2);

end %switch n

    function [Root Weight] = RtWt()
        
        %{------------------------------------------------------------------}
%{- These numbers are the zeros and weight factors of the          -}
%{- NumLegendreTermsth order Legendre Polynomial.  The numbers are -}
%{- taken from Abramowitz, Milton and Stegum, Irene. "Handbook of  -}
%{- Mathematical Functions with Formulas, Graphs and Mathematical  -}
%{- Tables." Washington DC: National Bureau of Standards, Applied  -}
%{- Mathematics Series, 55. 1972.                                  -}
%{-                                                                -}
%{- These numbers satisfy the following:                           -}
%{-                                                                -}
%{-     Integral from -1 to 1 of f(X) dx                           -}
%{-                  equals                                        -}
%{-     Sum from I=1 to NumLegendreTerms of                        -}
%{-                Legendre[I].Weight * f(Legendre[I].Root)        -}
%{------------------------------------------------------------------}
Root=[-0.989400934991649932596 ...,
 -0.944575023073232576078 ...,
 -0.865631202387831743880 ...,
 -0.755404408355003033895 ...,
 -0.617876244402643748447 ...,
 -0.458016777657227386342 ...,
 -0.281603550779258913230 ...,
 -0.095012509837637440185 ...,
 0.095012509837637440185 ...,
 0.281603550779258913230 ...,
 0.458016777657227386342 ...,
 0.617876244402643748447 ...,
 0.755404408355003033895 ...,
 0.865631202387831743880 ...,
 0.944575023073232576078 ...,
 0.989400934991649932596];

Weight=[0.027152459411754094852 ...,
 0.062253523938647892863 ...,
 0.095158511682492784810 ...,
 0.124628971255533872052 ...,
 0.149595988816576732081 ...,
 0.169156519395002538189 ...,
 0.182603415044923588867 ...,
 0.189450610455068496285 ...,
 0.189450610455068496285 ...,
 0.182603415044923588867 ...,
 0.169156519395002538189 ...,
 0.149595988816576732081 ...,
 0.124628971255533872052 ...,
 0.095158511682492784810 ...,
 0.062253523938647892863 ...,
 0.027152459411754094852];

function [K]=fpkernel(h,t,r,n)
% Kernels calculation 
p=4*h^2;
K=[];
%[dumb,nr]=size(r);
%[dumb,nt]=size(t);

switch n
case 1	%KN
 K=p*h*(KG(t-r,p)-KG(t+r,p));

case 2	%KN1
 Dlt=1e-6;
 a=t+r;
 b=t-r;
 y=a.^2;
 z=b.^2;
 g=2*p*h*(p^2+6*p*(t.^2+r.^2)+5*(a.*b).^2);
 s=((p+z).*(p+y)).^2;
 s=g./s;
 trbl=-4*h/(p+t.^2)*ones(size(t));
 rs=find(r>Dlt);
 if t<Dlt
  trbl=-4*h./(p+r.^2);
 else 
  trbl(rs)=h/t./r(rs).*log((p+z(rs))./(p+y(rs)));
 end
 K=trbl+s+h*(KERN(b,p)+KERN(a,p));

case 3	%KM

 y=(t+r).^2; z=(t-r).^2;
 a=((p+y).*(p+z)).^2;
 c=t+r;  d=t-r;
 b=p*t*((3*p^2-(c.*d).^2+2*p*(t^2+r.^2))./a);
 a=p/2*(c.*KG(c,p)+d.*KG(d,p));
 K=b-a;

case 4	%%KM1(t,r)=KM(r,t);

 y=(t+r).^2; z=(t-r).^2;
 a=((p+y).*(p+z)).^2;
 c=t+r; d=-t+r;
 b=p*r.*((3*p^2-(c.*d).^2+2*p*(t^2+r.^2))./a);
 a=p/2*(c.*KG(c,p)+d.*KG(d,p));
 K=b-a;

end %switch n

function [fKG]=KG(s,p)
             z=s.^2;
             y=p+z;
             fKG=(3*p-z)./y.^3;

function [fKERN]=KERN(w,p)
	     u=(p+w.^2).^3;
	     fKERN=2*(p^2/2+w.^4-p*w.^2/2)./u;



