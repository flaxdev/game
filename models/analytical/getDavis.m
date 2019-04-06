% c       params(1)    = x0 (x-position of singularity)
% c       params(2)    = y0 (y-position of singularity)
% c       params(3)   = z0 (z-position of singularity)
% c       params(4)    = p0 (pressure applied to cavity walls)
% c       params(5)    = e1 (first Euler angle)
% c       params(6)    = e2 (second Euler angle)
% c       params(7)    = e3 (third Euler angle)
% c       params(8)    = ba (ratio of b-axis to a-axis)
% c       params(9)    = ca (ratio of c-axis to a-axis)
% c       params(10)   = Volume 
function U = getDavis(params, Stations, Terrain)
% global zref
    
% zref = 0;
pois = Terrain.Poisson;
rmu = Terrain.rmu;
par(1) = params(4);
par(2) = params(10);
par(3:10) = params([5:9,1:3]);

% par(1)    = P0;
% par(2)    = V;
% par(3)    = e1;
% par(4)    = e2;
% par(5)    = e3;
% par(6)    = ba;
% par(7)    = ca;
% par(8)    = x0;
% par(9)    = y0;
% par(10)   = z0;

pg(1)=pois/(1.0-pois);
pg(2)=2.0*pois*rmu/(1.0-2.0*pois);
pg(3)=1.0-2.0*pois;
pg(4)=pois/pg(3);

%tic
pc = ellinit(par,pg, pois, rmu);
%toc

U = davis(Stations,par,pc,pois);

%--------------------------------------------------------------------------
function pc = ellinit(par,pg, pois, rmu)

% global zref

% c
% c...  subroutine to initialize constants for a Davis point ellipsoid
% c
drad=pi/180.0;
p0=-par(1);
vol=par(2);
ba=par(6);
ca=par(7);
er1=par(3)*drad;
er2=par(4)*drad;
er3=par(5)*drad;
absq=1.0-ba*ba;
acsq=1.0-ca*ca;
bcsq=ba*ba-ca*ca;
argb=sqrt(absq);
argc=sqrt(acsq);
ac=1/ca;
th=asin(argc);
rk=1.0;
if(argc~=0)
    rk=argb/argc;
end
a=[1 ba ca];
qr=3.0/(8.0*pi*(1.0-pois));
rr=(1.0-2.0*pois)/(8.0*pi*(1.0-pois));
rlam=pg(2);
d=-par(10);%+zref;
rk0=2.0*rmu*(1.0+pois)/(3.0*(1.0-2.0*pois));
es=p0/(3.0*rk0);
if(ba==1 && ca==1)
    ri = [1 1 1]*4.0*pi/3.0;
    rri = [12.0*pi/15.0 4.0*pi/15.0 4.0*pi/15.0
           4.0*pi/15.0 12.0*pi/15.0 4.0*pi/15.0
           4.0*pi/15.0 4.0*pi/15.0 12.0*pi/15.0];
elseif(ba == 1)
    ri(1)=2.0*pi*ca*(acos(ca)-ca*argc)/(argc*acsq);
    ri(2)=ri(1);
    ri(3)=4.0*pi-ri(1)-ri(2);
    rri(1,3)=(ri(3)-ri(1))/(3.0*acsq);
    rri(1,2)=pi/3.0-0.25*rri(1,3);
    rri(1,1)=4.0*pi/3.0-rri(1,2)-rri(1,3);
    rri(2,3)=(ri(3)-ri(2))/(3.0*bcsq);
    rri(2,1)=rri(1,2);
    rri(3,1)=rri(1,3);
    rri(3,2)=rri(2,3);
    rri(2,2)=4.0*pi/(3.0*ba*ba)-rri(2,1)-rri(2,3);
    rri(3,3)=4.0*pi/(3.0*ca*ca)-rri(3,1)-rri(3,2);
    % c
    % c...  case 3 -- prolate spheroid
    % c
elseif(ba == ca)
    ri(2)=2.0*pi*ca*ca*(ac*ac*argc-log(ac+sqrt(ac*ac-1.0)))/(argc*acsq);
    ri(3)=ri(2);
    ri(1)=4.0*pi-ri(2)-ri(3);
    rri(1,2)=(ri(2)-ri(1))/(3.0*absq);
    rri(1,3)=(ri(3)-ri(1))/(3.0*acsq);
    rri(1,1)=4.0*pi/3.0-rri(1,2)-rri(1,3);
    rri(2,3)=pi/(3.0*ba*ba)-0.25*rri(1,2);
    rri(2,1)=rri(1,2);
    rri(2,2)=4.0*pi/(3.0*ba*ba)-rri(2,1)-rri(2,3);
    rri(3,1)=rri(1,3);
    rri(3,2)=rri(2,3);
    rri(3,3)=4.0*pi/(3.0*ca*ca)-rri(3,1)-rri(3,2);
    % c
    % c...  case 4 -- triaxial ellipsoid
    % c
else
    sinth = sin(th);
    costh2 = cos(th)^2;
    q=(1.-sinth*rk)*(1.+sinth*rk);
    elle = sinth*(rf(costh2,q)-((sinth*rk)^2)*rd(costh2,q,1)/3);

    ri(1)=4.0*pi*ba*ca*(sinth*rf(costh2,1-sinth*rk*sinth*rk)-elle)/(absq*argc);
    ri(3)=4.0*pi*ba*ca*(ba*argc/ca-elle)/(bcsq*argc);
    ri(2)=4.0*pi-ri(1)-ri(3);
    rri(1,2)=(ri(2)-ri(1))/(3.0*absq);
    rri(1,3)=(ri(3)-ri(1))/(3.0*acsq);
    rri(1,1)=4.0*pi/3.0-rri(1,2)-rri(1,3);
    rri(2,3)=(ri(3)-ri(2))/(3.0*bcsq);
    rri(2,1)=rri(1,2);
    rri(2,2)=4.0*pi/(3.0*ba*ba)-rri(2,1)-rri(2,3);
    rri(3,1)=rri(1,3);
    rri(3,2)=rri(2,3);
    rri(3,3)=4.0*pi/(3.0*ca*ca)-rri(3,1)-rri(3,2);
end
% c
% c...  form s-matrix
% c
ee =[es es es];
ss = zeros(3,3);
for i=1:3
    for j=1:3
        sgn= 2*(i==j)-1.0;
%         if(i==j)
%             sgn=1.0;
%         end
        ss(i,j)=qr*a(j)*a(j)*rri(i,j)+sgn*rr*ri(i);
    end
    ss(i,i)=ss(i,i)-1.0;
end
% c
% c...  invert to obtain normal strains, then compute normal stresses from
% c     Hooke's law
% c
[ss,indx] = ludcmp(ss);
% ee = lubksb(ss,indx,ee);
%----------------

ii=0;
for i=1:3
    ll=indx(i);
    sum=ee(ll);
%     e(ll)=ee(i);
    if ii
        for j=ii:(i-1)
            sum=sum-ss(i,j)*ee(j);
        end
    elseif (sum~=0)
        ii=i;
    end
    ee(i)=sum;
end
for i=3:-1:1
    sum=ee(i);
    for j=(i+1):3
        sum=sum-ss(i,j)*ee(j);
    end
    ee(i)=sum/ss(i,i);
end
%-------------
etot=ee(1)+ee(2)+ee(3);
tmp=rlam*etot+2.0*rmu*ee;
% c
% c...  form rotation matrix from Euler angles
% c
se1=sin(er1);
se2=sin(er2);
se3=sin(er3);
ce1=cos(er1);
ce2=cos(er2);
ce3=cos(er3);
r11= ce2*ce3-se2*ce1*se3;
r12=-ce2*se3-se2*ce1*ce3;
r13= se2*se1;
r21= se2*ce3+ce2*ce1*se3;
r22=-se2*se3+ce2*ce1*ce3;
r23=-ce2*se1;
r31= se1*se3;
r32= se1*ce3;
r33= ce1;
% c
% c...  rotate from principal axis coordinates to local coordinates
% c
pc(1)=r11*r11*tmp(1)+r12*r12*tmp(2)+r13*r13*tmp(3);
pc(2)=r21*r21*tmp(1)+r22*r22*tmp(2)+r23*r23*tmp(3);
pc(3)=r31*r31*tmp(1)+r32*r32*tmp(2)+r33*r33*tmp(3);
pc(4)=-(r11*r21*tmp(1)+r12*r22*tmp(2)+r13*r23*tmp(3));
pc(5)=-(r31*r11*tmp(1)+r32*r12*tmp(2)+r33*r13*tmp(3));
pc(6)=r21*r31*tmp(1)+r22*r32*tmp(2)+r23*r33*tmp(3);
% c
% c...  define constants
% c
pc(7)=d;
pc(8)=0.25*vol/(pi*rmu);
pc(9)=0.5*vol/(pi*rmu);
pc(10)=1.0-2.0*pois;
pc(11)=pois/(1.0-pois);
pc(12)=rlam;
pc(13)=2.0*rmu;

%--------------------------------------------------------------------------
function U = davis(Stations,par,pc, pois)
% c***********************************************************************
% c    The following routines and functions are used in computing the
% c    displacements due to a 'point ellipsoid' as described by Davis
% % c    [1986].

nstats = size(Stations,1);
U = zeros(nstats,3);
rr = zeros(1,4);
rr1 = zeros(1,2);

d = pc(7);

for istats = 1:nstats
    x = Stations(istats,2);
    y = Stations(istats,1);
    pc(7) = d +  Stations(istats,3);
    %tic
    xx(1)=x-par(8);
    xx(2)=par(9)-y;
    rs=xx(1)*xx(1)+xx(2)*xx(2);
    % d=;
    % ds=;
    rr(1)=sqrt(rs+pc(7)*pc(7)); rr(2)=rr(1)*rr(1); rr(3)=rr(2)*rr(1); rr(4)=rr(3)*rr(1); % rr(5)=rr(4)*rr(1); rr(6)=rr(5)*rr(1); rr(7)=rr(6)*rr(1); rr(8)=rr(7)*rr(1); rr(9)=rr(8)*rr(1);
    rr1(1)=rr(1)+pc(7); rr1(2)=rr1(1)*rr1(1); %rr1(3)=rr1(2)*rr1(1); rr1(4)=rr1(3)*rr1(1); rr1(5)=rr1(4)*rr1(1); rr1(6)=rr1(5)*rr1(1); rr1(7)=rr1(6)*rr1(1); rr1(8)=rr1(7)*rr1(1); rr1(9)=rr1(8)*rr1(1);
    rr2=2.0*rr(1)+pc(7);
    rr3=3.0*rr(1)+pc(7);

    %toc
    %tic
    % c
    % c...  compute contributions from first displacement function
    % c
    W=pc(8)/rr(1)*(-1.0/rr(2)+3.0*xx(1)*xx(1)/rr(4)+pc(10)/rr1(2)*(3.0-xx(1)*xx(1)*rr3/(rr(2)*rr1(1))));
    u0(1)=xx(1)*W*pc(1);
    W=pc(8)/rr(1)*(-1.0/rr(2)+3.0*xx(2)*xx(2)/rr(4)+pc(10)/rr1(2)*(1.0-xx(2)*xx(2)*rr3/(rr(2)*rr1(1))));
    u0(1)=u0(1)+xx(1)*W*pc(2);
    W=pc(8)/rr(1)*(-1.0/rr(2)+3.0*xx(1)*xx(1)/rr(4)+pc(10)/rr1(2)*(1.0-xx(1)*xx(1)*rr3/(rr(2)*rr1(1))));
    u0(2)=xx(2)*W*pc(1);
    W=pc(8)/rr(1)*(-1.0/rr(2)+3.0*xx(2)*xx(2)/rr(4)+pc(10)/rr1(2)*(3.0-xx(2)*xx(2)*rr3/(rr(2)*rr1(1))));
    u0(2)=u0(2)+xx(2)*W*pc(2);
    %toc
    %tic
    % c
    % c...  compute contributions from second displacement function
    % c
    W=pc(8)/rr(1)*(pc(7)/rr(2)-3.0*xx(1)*xx(1)*pc(7)/rr(4)-pc(10)/rr1(1)*(1.0-xx(1)*xx(1)*rr2/(rr(2)*rr1(1))));
    u0(3)=W*pc(1);
    W=pc(8)/rr(1)*(pc(7)/rr(2)-3.0*xx(2)*xx(2)*pc(7)/rr(4)-pc(10)/rr1(1)*(1.0-xx(2)*xx(2)*rr2/(rr(2)*rr1(1))));
    u0(3)=u0(3)+W*pc(2);
    %toc
    %tic
    % c
    % c...  compute contributions from third displacement function
    % c
    W=pc(8)/rr(3)*(3.0*pc(7)*pc(7)/rr(2)-2.0*pois);
    u0(1)=u0(1)+xx(1)*W*pc(3);
    u0(2)=u0(2)+xx(2)*W*pc(3);
    % c
    % c...  compute contributions from fourth displacement function
    % c

    W=pc(7)*pc(8)/rr(3)*(-3.0*pc(7)*pc(7)/rr(2)+2.0*pois);
    u0(3)=u0(3)+W*pc(3);

    W=pc(9)/rr(1)*(3.0*xx(1)*xx(1)/rr(4)+pc(10)/rr1(2)*(1.0-xx(1)*xx(1)*rr3/(rr(2)*rr1(1))));
    u0(1)=u0(1)+pc(4)*xx(2)*W;
    W=pc(9)/rr(1)*(3.0*xx(2)*xx(2)/rr(4)+pc(10)/rr1(2)*(1.0-xx(2)*xx(2)*rr3/(rr(2)*rr1(1))));
    u0(2)=u0(2)+pc(4)*xx(1)*W;
    %toc
    %tic
    % c
    % c...  compute contributions from sixth displacement function
    % c
    W=pc(9)/rr(3)*(-3.0*pc(7)/rr(2)+pc(10)/rr1(2)*rr2);
    u0(3)=u0(3)+pc(4)*xx(1)*xx(2)*W;

    W=-3.0*pc(7)/rr(3)*pc(9)/rr(2);
    U(istats,2)=u0(1)+(pc(5)*xx(1)*xx(1)+pc(6)*xx(1)*xx(2))*W;
    u0(2)=u0(2)+(pc(5)*xx(2)*xx(1)+pc(6)*xx(2)*xx(2))*W;


    %toc
    %tic
    % c
    % c...  compute contributions from eighth displacement function
    % c
    W=pc(7)*pc(9)/rr(2)*3.0*pc(7)/rr(3);
    u0(3)=u0(3)+(pc(5)*xx(1)+pc(6)*xx(2))*W;
    % c
    % c...  compute solution and corrections from 1st and 2nd derivatives,
    % c     transforming to coordinate system with z-axis positive upward
    % c     and y-axis positive north
    % c
    U(istats,1)=-u0(2);
    U(istats,3)=-u0(3);
end
% %toc
% %tic

%--------------------------------------------------------------------------

% function b = lubksb(a,indx,b)
% % c
% % c...  routine to perform backsubstitution for an LU decomposition from
% % c     Numerical Recipes
% % c
% ii=0;
% for i=1:3
%     ll=indx(i);
%     sum=b(ll);
%     b(ll)=b(i);
%     if ii
%         for j=ii:(i-1)
%             sum=sum-a(i,j)*b(j);
%         end
%     elseif (sum~=0)
%         ii=i;
%     end
%     b(i)=sum;
% end
% for i=3:-1:1
%     sum=b(i);
%     for j=(i+1):3
%         sum=sum-a(i,j)*b(j);
%     end
%     b(i)=sum/a(i,i);
% end
%--------------------------------------------------------------------------
function [a,indx,d] = ludcmp(a)
% c
% c...  routine to perform an LU decomposition from Numerical Recipes
% c
% NMAX=500;
TINY=1.0e-20;
%       REAL*8 vv(NMAX)
d=1;
vv = zeros(1,3);
for i=1:3
    aamax =max([abs(a(i,1)),abs(a(i,2)),abs(a(i,3))]);
    if (aamax==0)
        disp('singular matrix in ludcmp');
    end
    vv(i)=1/aamax;
end
indx = zeros(1,3);
for j=1:3
    imax = j;
    for i=1:(j-1)
        sum=a(i,j);
        for k=1:(i-1)
            sum=sum-a(i,k)*a(k,j);
        end
        a(i,j)=sum;
    end
    aamax=0.;
    for i=j:3
        sum=a(i,j);
        for k=1:(j-1)
            sum=sum-a(i,k)*a(k,j);
        end
        a(i,j)=sum;
        dum=vv(i)*abs(sum);
        if (dum>=aamax)
            imax=i;
            aamax=dum;
        end
    end
    if (j~=imax)
        dum=a(imax,1);
        a(imax,1)=a(j,1);
        a(j,1)=dum;
        dum=a(imax,2);
        a(imax,2)=a(j,2);
        a(j,2)=dum;
        dum=a(imax,3);
        a(imax,3)=a(j,3);
        a(j,3)=dum;        
        d=-d;
        vv(imax)=vv(j);
    end
    indx(j)=imax;
    if(a(j,j)==0)
        a(j,j)=TINY;
    end
    if(j~=3)
        dum=1/a(j,j);
        for i=(j+1):3
            a(i,j)=a(i,j)*dum;
        end
    end
end
%--------------------------------------------------------------------------
function out = rd(xt,yt,zt)
% c
% c...  routine to find ellip%tic integrals from Numerical Recipes
% c
ERRTOL=.05;
% TINY=1e-25;
% BIG=4.5E21;
C1=3/14;
% C2=1/6;
C3=9/22;
C4=3/26;
C5=.25*C3;
C6=1.5*C4;

% if(min(x,y)<0 || min(x+y,z)<TINY || max([x,y,z])>BIG)
%     disp('invalid arguments in rd');
% end
% xt=x;
% yt=y;
% zt=z;
sum=0.;
sqrtx=sqrt(xt);
sqrty=sqrt(yt);
sqrtz=sqrt(zt);
alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz;
sum=sum+1/(sqrtz*(zt+alamb));
fac=.25;
xt=.25*(xt+alamb);
yt=.25*(yt+alamb);
zt=.25*(zt+alamb);
ave=.2*(xt+yt+3*zt);
delx=(ave-xt)/ave;
dely=(ave-yt)/ave;
delz=(ave-zt)/ave;
while(max([abs(delx),abs(dely),abs(delz)])>ERRTOL)
    sqrtx=sqrt(xt);
    sqrty=sqrt(yt);
    sqrtz=sqrt(zt);
    alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz;
    sum=sum+fac/(sqrtz*(zt+alamb));
    fac=.25*fac;
    xt=.25*(xt+alamb);
    yt=.25*(yt+alamb);
    zt=.25*(zt+alamb);
    ave=.2*(xt+yt+3.*zt);
    delx=(ave-xt)/ave;
    dely=(ave-yt)/ave;
    delz=(ave-zt)/ave;
end
ea=delx*dely;
eb=delz*delz;
ec=ea-eb;
ed=ea-6.*eb;
ee=ed+ec+ec;
out=3*sum+fac*(1.+ed*(-C1+C5*ed-C6*delz*ee)+delz*(ee/6+delz*(-C3*ec+delz*C4*ea)))/(ave*sqrt(ave));
%--------------------------------------------------------------------------
function out = rf(xt,yt)
% c
% c...  routine to find ellip%tic integrals from Numerical Recipes
% c
ERRTOL=.08;
% TINY=1.5e-38;
% BIG=3.E37;
C1=1/24;
C3=3/44;
C4=1/14;

% if(min([x,y,z])<0 || min([x+y,x+z,y+z])<TINY || max([x,y,z])>BIG)
%     disp('invalid arguments in rf');
% end
% xt=x;
% yt=y;
% zt=z;
zt=1;
sqrtx=sqrt(xt);
sqrty=sqrt(yt);
sqrtz=1;
alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz;
xt=.25*(xt+alamb);
yt=.25*(yt+alamb);
zt=.25*(zt+alamb);
ave=(xt+yt+zt)/3;
delx=(ave-xt)/ave;
dely=(ave-yt)/ave;
delz=(ave-zt)/ave;
while(max([abs(delx),abs(dely),abs(delz)])>ERRTOL) % 
    sqrtx=sqrt(xt);
    sqrty=sqrt(yt);
    sqrtz=sqrt(zt);
    alamb=sqrtx*(sqrty+sqrtz)+sqrty*sqrtz;
    xt=.25*(xt+alamb);
    yt=.25*(yt+alamb);
    zt=.25*(zt+alamb);
    ave=(xt+yt+zt)/3;
    delx=(ave-xt)/ave;
    dely=(ave-yt)/ave;
    delz=(ave-zt)/ave;
end
e2=delx*dely-delz*delz;
e3=delx*dely*delz;
out=(1.+(C1*e2-0.1-C3*e3)*e2+C4*e3)/sqrt(ave);




%--------------------------------------------------------------------------
