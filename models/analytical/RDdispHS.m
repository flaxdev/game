function [ue,un,uv, P1, P2, P3, P4, nogood]=RDdispHS(X,Y,Z,X0,Y0,depth,L,W,plunge,dip,strike,stkslip,dipslip,opening,nu)

% RDdispHS
% calculates displacements associated with a rectangular dislocation in an
% elastic half-space.
%
% RD: Rectangular Dislocation
% EFCS: Earth-Fixed Coordinate System
% RDCS: Rectangular Dislocation Coordinate System
% ADCS: Angular Dislocation Coordinate System
% (The origin of the RDCS is the RD centroid. The axes of the RDCS are
% aligned with the strike, dip and normal vectors of the RD, respectively.)
%
% INPUTS
% X, Y and Z:
% Coordinates of calculation points in EFCS (East, North, Up). X, Y and Z
% must have the same size.
%
% X0, Y0 and depth:
% Horizontal coordinates (in EFCS) and depth of the "RD reference point".
% The depth must be a positive value. The RD reference point is specified
% by the "RefPoint" value (see below). X0, Y0 and depth have the same unit
% as X, Y and Z.
%
% L and W:
% The length and width of the RD (see the note on the RD geometry in the
% following). L and W have the same unit as X, Y and Z.
%
% plunge, dip and strike:
% Rotation angles that specify the orientation of the RD in space (see the
% note on the RD geometry in the following). The input values must be in
% degrees.
%
% rake:
% The angle between the slip direction on the RD, and the intersection of
% the extended RD plane and the XY plane (of the EFCS). The input value
% must be in degrees.
% Note that rake is completely independent of the plunge angle!
%
% slip:
% The RD slip value (norm of the Burgers vector projection onto the RD
% plane).
%
% opening:
% The RD opening (tensile component of the Burgers vector).
%
% nu:
% Poisson's ratio.
%
% RefPoint:
% specifies the RD reference point. The RefPoint can take the following
% values:
% 1) 'Pc' is the RD centroid,
% 2) 'P1' is the first RD vertex,
% 3) 'P2' is the second RD vertex,
% 4) 'P3' is the third RD vertex,
% 5) 'P4' is the fourth RD vertex,
% 6) 'mP12' or 'mP21' is the midpoint of the P1P2,
% 7) 'mP23' or 'mP32' is the midpoint of the P2P3,
% 8) 'mP34' or 'mP43' is the midpoint of the P3P4,
% 9) 'mP14' or 'mP41' is the midpoint of the P1P4. See Figure 2 in the
% reference journal article (cited below) for the geometry of the RD and
% its vertices.
% The coordinates of the RD reference point in EFCS are (X0,Y0,-depth).
% (see the note on the RD geometry in the following).
%
%
%
% *** A note on the RD geometry ***
% To specify the orientation and location of any arbitrary RD in space we
% start with an initial RD that has two edges of length "W" along the X
% axis and has two edges of length "L" along the Y axis and its centroid is
% located on the origin of the EFCS, respectively. We apply the following
% rotations to this initial RD:
% 1) a "clockwise" rotation about the Z axis by an angle "plunge",
% 2) an "anticlockwise" rotation about the Y axis by an angle "dip",
% 3) a "clockwise" rotation about the Z axis by an angle "strike".
% This fixes the orientation of the RD in space. We then fix the location
% of the RD by applying a translation that places the RD reference point at
% the point (X0,Y0,-depth).
%
%
% OUTPUTS
% ue, un and uv:
% Calculated displacement vector components in EFCS. ue, un and uv have the
% same unit as slip and opening in inputs.
%
%
% Example: Calculate and plot the first component of displacement vector
% on a regular grid.
%
% [X,Y,Z] = meshgrid(-10:.05:10,-8:.05:8,-1);
% X0 = 3; Y0 = 1; depth = 5; L = 2; W = 1; plunge = 10; dip = 45;
% strike = 30; rake = 20; slip = 1; opening = 0.15; nu = 0.25;
% RefPoint = 'Pc';
% [ue,un,uv] = RDdispHS(X,Y,Z,X0,Y0,depth,L,W,plunge,dip,strike,rake,...
% slip,opening,nu,RefPoint);
% figure
% surf(X,Y,reshape(ue,size(X)),'edgecolor','none')
% view(2)
% axis equal
% axis tight
% set(gcf,'renderer','painters')

% Reference journal article:
% Nikkhoo, M., Walter, T. R., Lundgren, P. R., Prats-Iraola, P. (2016):
% Compound dislocation models (CDMs) for volcano deformation analyses.
% Submitted to Geophysical Journal International

% Copyright (c) 2016 Mehdi Nikkhoo
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files
% (the "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

% I appreciate any comments or bug reports.

% Mehdi Nikkhoo
% created: 2013.1.31
% Last modified: 2016.10.18
%
% Section 2.1, Physics of Earthquakes and Volcanoes
% Department 2, Geophysics
% Helmholtz Centre Potsdam
% German Research Centre for Geosciences (GFZ)
%
% email:
% mehdi.nikkhoo@gfz-potsdam.de
% mehdi.nikkhoo@gmail.com
%
% website:
% http://www.volcanodeformation.com

Ts = opening; % Tensile-slip
Ss = stkslip; % Strike-slip
Ds = dipslip; % Dip-slip

X = X(:);
Y = Y(:);
Z = Z(:);

Rz1 = [cosd(plunge) sind(plunge) 0;-sind(plunge) cosd(plunge) 0;0 0 1];
Ry = [cosd(dip) 0 sind(dip);0 1 0;-sind(dip) 0 cosd(dip)];
Rz2 = [cosd(strike) sind(strike) 0;-sind(strike) cosd(strike) 0;0 0 1];
Rt = Rz2*Ry*Rz1;

Pt1 = [-W/2 L/2 0]';
Pt2 = [-W/2 -L/2 0]';
Pt3 = [W/2 -L/2 0]';
Pt4 = [W/2 L/2 0]';

Ptr = [-W/2 0 0]';

Pr = [X0,Y0,-depth]'-Rt*Ptr;
P1 = Rt*Pt1+Pr;
P2 = Rt*Pt2+Pr;
P3 = Rt*Pt3+Pr;
P4 = Rt*Pt4+Pr;

nogood = false;
if any([P1(3) P2(3) P3(3) P4(3)]>0)
    nogood = true;
    ue = NaN; un = NaN; uv = NaN;
    return
elseif any(Z>0)
    nogood = true;
    ue = NaN; un = NaN; uv = NaN;
    return
elseif P1(3)==0 && P2(3)==0 && P3(3)==0 && P4(3)==0
    ue = zeros(size(X));
    un = zeros(size(X));
    uv = zeros(size(X));
    return
end

% Calculate unit strike, dip and normal to the RD vectors:
eZ = [0 0 1]';
Vnorm = Rt*eZ;
Vstrike = [sind(strike) cosd(strike) 0]';
Vdip = cross(Vnorm,Vstrike);

% Calculate main dislocation contribution to displacements
[ueMS,unMS,uvMS] = RDdispFS(X,Y,Z,P1,P2,P3,P4,Vnorm,Vstrike,Vdip,Ss,Ds,...
    Ts,nu);

% Calculate harmonic function contribution to displacements
[ueFSC,unFSC,uvFSC] = RDdisp_HarFunc(X,Y,Z,P1,P2,P3,P4,Vnorm,Vstrike,...
    Vdip,Ss,Ds,Ts,nu);

% Calculate image dislocation contribution to displacements
P1(3) = -P1(3);
P2(3) = -P2(3);
P3(3) = -P3(3);
P4(3) = -P4(3);
Vnorm(1:2) = -Vnorm(1:2);
Vstrike = -Vstrike;
Vdip = cross(Vnorm,Vstrike);
[ueIS,unIS,uvIS] = RDdispFS(X,Y,Z,P1,P2,P3,P4,Vnorm,Vstrike,Vdip,Ss,Ds,...
    Ts,nu);

% Calculate the complete displacement vector components in EFCS
ue = ueMS+ueIS+ueFSC;
un = unMS+unIS+unFSC;
uv = uvMS+uvIS+uvFSC;


function [ue,un,uv]=RDdispFS(X,Y,Z,P1,P2,P3,P4,Vnorm,Vstrike,Vdip,Ss,Ds,...
    Ts,nu)
% RDdispFS calculates displacements associated with a rectangular
% dislocation in an elastic full-space.

bx = Ts; % Tensile-slip
by = Ss; % Strike-slip
bz = Ds; % Dip-slip

Pm = (P1+P2+P3+P4)/4;

% Transform coordinates and slip vector components from EFCS into RDCS
p1 = zeros(3,1);
p2 = zeros(3,1);
p3 = zeros(3,1);
p4 = zeros(3,1);

At = [Vnorm Vstrike Vdip]';
[x,y,z] = CoordTrans(X'-Pm(1),Y'-Pm(2),Z'-Pm(3),At);
[p1(1),p1(2),p1(3)] = CoordTrans(P1(1)-Pm(1),P1(2)-Pm(2),P1(3)-Pm(3),At);
[p2(1),p2(2),p2(3)] = CoordTrans(P2(1)-Pm(1),P2(2)-Pm(2),P2(3)-Pm(3),At);
[p3(1),p3(2),p3(3)] = CoordTrans(P3(1)-Pm(1),P3(2)-Pm(2),P3(3)-Pm(3),At);
[p4(1),p4(2),p4(3)] = CoordTrans(P4(1)-Pm(1),P4(2)-Pm(2),P4(3)-Pm(3),At);

% Calculate the unit vectors along RD sides in RDCS
e12 = (p2-p1)/norm(p2-p1);
e23 = (p3-p2)/norm(p3-p2);
e34 = (p4-p3)/norm(p4-p3);
e14 = (p4-p1)/norm(p4-p1);

% Determine the best arteact-free configuration for each calculation point
Rectmode = rectmodefinder(y,z,x,p1(2:3),p2(2:3),p3(2:3),p4(2:3));
casepLog = Rectmode==1;
casenLog = Rectmode==-1;
casezLog = Rectmode==0;
xp = x(casepLog);
yp = y(casepLog);
zp = z(casepLog);
xn = x(casenLog);
yn = y(casenLog);
zn = z(casenLog);

% Configuration I
if nnz(casepLog)~=0
    % Calculate first angular dislocation contribution
    [u1Tp,v1Tp,w1Tp] = RDSetupD(xp,yp,zp,bx,by,bz,nu,p1,e14);
    % Calculate second angular dislocation contribution
    [u2Tp,v2Tp,w2Tp] = RDSetupD(xp,yp,zp,bx,by,bz,nu,p2,-e12);
    % Calculate third angular dislocation contribution
    [u3Tp,v3Tp,w3Tp] = RDSetupD(xp,yp,zp,bx,by,bz,nu,p3,-e23);
    % Calculate fourth angular dislocation contribution
    [u4Tp,v4Tp,w4Tp] = RDSetupD(xp,yp,zp,bx,by,bz,nu,p4,-e34);
end

% Configuration II
if nnz(casenLog)~=0
    % Calculate first angular dislocation contribution
    [u1Tn,v1Tn,w1Tn] = RDSetupD(xn,yn,zn,bx,by,bz,nu,p1,-e14);
    % Calculate second angular dislocation contribution
    [u2Tn,v2Tn,w2Tn] = RDSetupD(xn,yn,zn,bx,by,bz,nu,p2,e12);
    % Calculate third angular dislocation contribution
    [u3Tn,v3Tn,w3Tn] = RDSetupD(xn,yn,zn,bx,by,bz,nu,p3,e23);
    % Calculate fourth angular dislocation contribution
    [u4Tn,v4Tn,w4Tn] = RDSetupD(xn,yn,zn,bx,by,bz,nu,p4,e34);
end

% Calculate the "incomplete" displacement vector components in RDCS
if nnz(casepLog)~=0
    u(casepLog,1) = u1Tp+u2Tp+u3Tp+u4Tp;
    v(casepLog,1) = v1Tp+v2Tp+v3Tp+v4Tp;
    w(casepLog,1) = w1Tp+w2Tp+w3Tp+w4Tp;
end
if nnz(casenLog)~=0
    u(casenLog,1) = u1Tn+u2Tn+u3Tn+u4Tn;
    v(casenLog,1) = v1Tn+v2Tn+v3Tn+v4Tn;
    w(casenLog,1) = w1Tn+w2Tn+w3Tn+w4Tn;
end
if nnz(casezLog)~=0
    u(casezLog,1) = nan;
    v(casezLog,1) = nan;
    w(casezLog,1) = nan;
end

% Calculate the Burgers' function contribution corresponding to the RD
Fi = BurgersFuncRD(x,y,z,p1,p2,p3,p4);

% Calculate the complete displacement vector components in RDCS
u = bx.*Fi+u;
v = by.*Fi+v;
w = bz.*Fi+w;

% Transform the complete displacement vector components from RDCS into EFCS
[ue,un,uv] = CoordTrans(u,v,w,[Vnorm Vstrike Vdip]);


function [Fi]=BurgersFuncRD(x,y,z,p1,p2,p3,p4)
% BurgersFuncRD calculates the Burgers' function contribution corresponding
% to the rectangular dislocation p1p2p3p4 at (x,y,z) coordinates.

Fi = zeros(size(x));
Ind = abs(y)<=abs(p1(2)-p2(2))/2 & abs(z)<=abs(p1(3)-p4(3))/2;

% Calculation points that their orthogonal projection onto the RD plane 
% lies inside the RD 
xI = x(Ind);
yI = y(Ind);
zI = z(Ind);

% Calculation points that their orthogonal projection onto the RD plane 
% lies outside the RD 
xO = x(~Ind);
yO = y(~Ind);
zO = z(~Ind);

if ~isempty(xI)
    % Calculate Fi as a combination of solid angles of four angular
    % dislocations
    FiD1 = sqrt(xI.^2+(yI-p1(2)).^2+(zI-p1(3)).^2)-(zI-p1(3))-(yI-p1(2));
    FiD2 = sqrt(xI.^2+(yI-p2(2)).^2+(zI-p2(3)).^2)-(zI-p2(3))-(yI-p2(2));
    FiD3 = sqrt(xI.^2+(yI-p3(2)).^2+(zI-p3(3)).^2)-(zI-p3(3))-(yI-p3(2));
    FiD4 = sqrt(xI.^2+(yI-p4(2)).^2+(zI-p4(3)).^2)-(zI-p4(3))-(yI-p4(2));
    
    % Making use of the tangent of sums formula
    FiNt = xI.*(FiD1+FiD3).*(FiD2.*FiD4-xI.^2)-...
        xI.*(FiD2+FiD4).*(FiD1.*FiD3-xI.^2);
    FiDt = (FiD1.*FiD3-xI.^2).*(FiD2.*FiD4-xI.^2)+...
        xI.^2.*(FiD1+FiD3).*(FiD2+FiD4);
    Fi(Ind) = atan2(FiNt,FiDt)/2/pi;
end

if ~isempty(xO)
    % Calculate Fi as a combination of solid angles of two triangular
    % dislocations
    a = [-xO p1(2)-yO p1(3)-zO];
    b = [-xO p2(2)-yO p2(3)-zO];
    c = [-xO p3(2)-yO p3(3)-zO];
    d = [-xO p4(2)-yO p4(3)-zO];
    na = sqrt(sum(a.^2,2));
    nb = sqrt(sum(b.^2,2));
    nc = sqrt(sum(c.^2,2));
    nd = sqrt(sum(d.^2,2));
    
    % Making use of the tangent of sums formula
    FiN1t = (a(:,1).*(b(:,2).*c(:,3)-b(:,3).*c(:,2))-...
        a(:,2).*(b(:,1).*c(:,3)-b(:,3).*c(:,1))+...
        a(:,3).*(b(:,1).*c(:,2)-b(:,2).*c(:,1)));
    FiD1t = (na.*nb.*nc+sum(a.*b,2).*nc+sum(a.*c,2).*nb+sum(b.*c,2).*na);
    FiN2t = (a(:,1).*(c(:,2).*d(:,3)-c(:,3).*d(:,2))-...
        a(:,2).*(c(:,1).*d(:,3)-c(:,3).*d(:,1))+...
        a(:,3).*(c(:,1).*d(:,2)-c(:,2).*d(:,1)));
    FiD2t = (na.*nc.*nd+sum(a.*c,2).*nd+sum(a.*d,2).*nc+sum(c.*d,2).*na);
    
    Fi(~Ind) = -2*atan2(FiN1t.*FiD2t+FiN2t.*FiD1t,...
        FiD1t.*FiD2t-FiN1t.*FiN2t)/4/pi;
end

function [ue,un,uv]=RDdisp_HarFunc(X,Y,Z,P1,P2,P3,P4,Vnorm,Vstrike,...
    Vdip,Ss,Ds,Ts,nu)
% RDdisp_HarFunc calculates the harmonic function contribution to the
% displacements associated with a rectangular dislocation in a half-space.
% The function cancels the surface normal tractions induced by the main and
% image dislocations.

bx = Ts; % Tensile-slip
by = Ss; % Strike-slip
bz = Ds; % Dip-slip

% Transform slip vector components from RDCS into EFCS
A = [Vnorm Vstrike Vdip];
[bX,bY,bZ] = CoordTrans(bx,by,bz,A);

% Calculate contribution of angular dislocation pair on each RD side
[u1,v1,w1] = AngSetupFSC(X,Y,Z,bX,bY,bZ,P1,P2,nu); % Side P1P2
[u2,v2,w2] = AngSetupFSC(X,Y,Z,bX,bY,bZ,P2,P3,nu); % Side P2P3
[u3,v3,w3] = AngSetupFSC(X,Y,Z,bX,bY,bZ,P3,P4,nu); % Side P3P4
[u4,v4,w4] = AngSetupFSC(X,Y,Z,bX,bY,bZ,P4,P1,nu); % Side P4P1

% Calculate total harmonic function contribution to displacements
ue = u1+u2+u3+u4;
un = v1+v2+v3+v4;
uv = w1+w2+w3+w4;

function [X1,X2,X3]=CoordTrans(x1,x2,x3,A)
% CoordTrans transforms the coordinates of the vectors, from
% x1x2x3 coordinate system to X1X2X3 coordinate system. "A" is the
% transformation matrix, whose columns e1,e2 and e3 are the unit base
% vectors of the x1x2x3. The coordinates of e1,e2 and e3 in A must be given
% in X1X2X3. The transpose of A (i.e., A') will transform the coordinates
% from X1X2X3 into x1x2x3.

x1 = x1(:);
x2 = x2(:);
x3 = x3(:);
r = A*[x1';x2';x3'];
X1 = r(1,:)';
X2 = r(2,:)';
X3 = r(3,:)';

function [rectmode]=rectmodefinder(x,y,z,p1,p2,p3,p4)
% rectmodefinder specifies the appropriate artefact-free configuration of
% the angular dislocations for the calculations. The input matrices x, y
% and z share the same size and correspond to the y, z and x coordinates in
% the RDCS, respectively. p1, p2, p3 and p4 are two-component matrices that
% represent the y and z coordinates of the RD vertices in the RDCS,
% respectively. The components of the output (rectmode) corresponding to
% each calculation points, are 1 for the first configuration, -1 for the
% second configuration and 0 for the calculation point that lie on the RD
% edges.

x = x(:);
y = y(:);
z = z(:);

p1 = p1(:);
p2 = p2(:);
p3 = p3(:);
p4 = p4(:);

pm = (p1+p2+p3+p4)/4; % centroid position vector
r21 = p1-p2;
e21 = r21/sqrt(r21'*r21); % unit vector along new x-axis
r41 = p1-p4;
e41 = r41/sqrt(r41'*r41); % unit vector along new y-axis

% Transform the coordinates to the new coordinate system
x = x-pm(1);
y = y-pm(2);

A = [e21 e41];
r = A'*[x';y'];
% new coordinates of the calculation points
x = r(1,:)';
y = r(2,:)';

r = A'*[p1-pm,p2-pm,p3-pm,p4-pm];
% new coordinates of the rectangle vertices
P1 = r(:,1);
P2 = r(:,2);
P3 = r(:,3);
P4 = r(:,4);

rectmode = ones(length(x),1);
% Partition the RD plane using the bisectors of the RD angles and RD sides
rectmode(x>=0 & y>=0 & ((y-P1(2))<(x-P1(1)))) = -1;
rectmode(x<=0 & y>=0 & ((y-P2(2))>-(x-P2(1)))) = -1;
rectmode(x<=0 & y<=0 & ((y-P3(2))>(x-P3(1)))) = -1;
rectmode(x>=0 & y<=0 & ((y-P4(2))<-(x-P4(1)))) = -1;
rectmode(x<P1(1) & x>P3(1) & y<P1(2) & y>P3(2)) = -1;
rectmode((x==P1(1) | x==P3(1)) & y<=P1(2) & y>=P3(2) & z==0) = 0;
rectmode((y==P1(2) | y==P3(2)) & x<=P1(1) & x>=P3(1) & z==0) = 0;


function [u,v,w]=RDSetupD(x,y,z,bx,by,bz,nu,RDVertex,SideVec)
% RDSetupD transforms coordinates of the calculation points and slip vector
% components from ADCS into RDCS. It then calculates the displacements in
% ADCS and transforms them into RDCS.

% Transformation matrix
A = [[SideVec(3);-SideVec(2)] SideVec(2:3)]';

% Transform coordinates of the calculation points from RDCS into ADCS
r1 = A*[y'-RDVertex(2);z'-RDVertex(3)];
y1 = r1(1,:)';
z1 = r1(2,:)';

% Transform the in-plane slip vector components from RDCS into ADCS
r2 = A*[by;bz];
by1 = r2(1,:)';
bz1 = r2(2,:)';

% Calculate displacements associated with an angular dislocation in ADCS
[u,v0,w0] = AngDisDisp(x,y1,z1,-pi/2,bx,by1,bz1,nu);

% Transform displacements from ADCS into RDCS
r3 = A'*[v0';w0'];
v = r3(1,:)';
w = r3(2,:)';

function [ue,un,uv]=AngSetupFSC(X,Y,Z,bX,bY,bZ,PA,PB,nu)
% AngSetupFSC calculates the Free Surface Correction to displacements
% associated with angular dislocation pair on each RD side.

% Calculate RD side vector and the angle of the angular dislocation pair
SideVec = PB-PA;
eZ = [0 0 1]';
beta = acos(-SideVec'*eZ/norm(SideVec));

if abs(beta)<eps || abs(pi-beta)<eps
    ue = zeros(length(X),1);
    un = zeros(length(X),1);
    uv = zeros(length(X),1);
else
    ey1 = [SideVec(1:2);0];
    ey1 = ey1/norm(ey1);
    ey3 = -eZ;
    ey2 = cross(ey3,ey1);
    A = [ey1,ey2,ey3]; % Transformation matrix
    
    % Transform coordinates from EFCS to the first ADCS
    [y1A,y2A,y3A] = CoordTrans(X-PA(1),Y-PA(2),Z-PA(3),A);
    % Transform coordinates from EFCS to the second ADCS
    [y1AB,y2AB,y3AB] = CoordTrans(SideVec(1),SideVec(2),SideVec(3),A);
    y1B = y1A-y1AB;
    y2B = y2A-y2AB;
    y3B = y3A-y3AB;
    
    % Transform slip vector components from EFCS to ADCS
    [b1,b2,b3] = CoordTrans(bX,bY,bZ,A);
    
    % Determine the best artefact-free configuration for the calculation
    % points near the free surface
    I = (beta*y1A)>=0;
    
    % Configuration I
    [v1A(I),v2A(I),v3A(I)] = AngDisDispFSC(y1A(I),y2A(I),y3A(I),...
        -pi+beta,b1,b2,b3,nu,-PA(3));
    [v1B(I),v2B(I),v3B(I)] = AngDisDispFSC(y1B(I),y2B(I),y3B(I),...
        -pi+beta,b1,b2,b3,nu,-PB(3));
    
    % Configuration II
    [v1A(~I),v2A(~I),v3A(~I)] = AngDisDispFSC(y1A(~I),y2A(~I),y3A(~I),...
        beta,b1,b2,b3,nu,-PA(3));
    [v1B(~I),v2B(~I),v3B(~I)] = AngDisDispFSC(y1B(~I),y2B(~I),y3B(~I),...
        beta,b1,b2,b3,nu,-PB(3));
    
    % Calculate total Free Surface Correction to displacements in ADCS
    v1 = v1B-v1A;
    v2 = v2B-v2A;
    v3 = v3B-v3A;
    
    % Transform total Free Surface Correction to displacements from ADCS
    % to EFCS
    [ue,un,uv] = CoordTrans(v1,v2,v3,A');
end

function [u,v,w]=AngDisDisp(x,y,z,alpha,bx,by,bz,nu)
% AngDisDisp calculates the "incomplete" displacements (without the
% Burgers' function contribution) associated with an angular dislocation in
% an elastic full-space.

cosA = cos(alpha);
sinA = sin(alpha);
eta = y*cosA-z*sinA;
zeta = y*sinA+z*cosA;
r = sqrt(x.^2+y.^2+z.^2);

% Avoid complex results for the logarithmic terms
zeta(zeta>r) = r(zeta>r);
z(z>r) = r(z>r);

ux = bx/8/pi/(1-nu)*(x.*y./r./(r-z)-x.*eta./r./(r-zeta));
vx = bx/8/pi/(1-nu)*(eta*sinA./(r-zeta)-y.*eta./r./(r-zeta)+...
    y.^2./r./(r-z)+(1-2*nu)*(cosA*log(r-zeta)-log(r-z)));
wx = bx/8/pi/(1-nu)*(eta*cosA./(r-zeta)-y./r-eta.*z./r./(r-zeta)-...
    (1-2*nu)*sinA*log(r-zeta));

uy = by/8/pi/(1-nu)*(x.^2*cosA./r./(r-zeta)-x.^2./r./(r-z)-...
    (1-2*nu)*(cosA*log(r-zeta)-log(r-z)));
vy = by*x/8/pi/(1-nu).*(y.*cosA./r./(r-zeta)-...
    sinA*cosA./(r-zeta)-y./r./(r-z));
wy = by*x/8/pi/(1-nu).*(z*cosA./r./(r-zeta)-cosA^2./(r-zeta)+1./r);

uz = bz*sinA/8/pi/(1-nu).*((1-2*nu)*log(r-zeta)-x.^2./r./(r-zeta));
vz = bz*x*sinA/8/pi/(1-nu).*(sinA./(r-zeta)-y./r./(r-zeta));
wz = bz*x*sinA/8/pi/(1-nu).*(cosA./(r-zeta)-z./r./(r-zeta));

u = ux+uy+uz;
v = vx+vy+vz;
w = wx+wy+wz;

function [v1 v2 v3] = AngDisDispFSC(y1,y2,y3,beta,b1,b2,b3,nu,a)
% AngDisDispFSC calculates the harmonic function contribution to the
% displacements associated with an angular dislocation in an elastic
% half-space.

sinB = sin(beta);
cosB = cos(beta);
cotB = cot(beta);
y3b = y3+2*a;
z1b = y1*cosB+y3b*sinB;
z3b = -y1*sinB+y3b*cosB;
r2b = y1.^2+y2.^2+y3b.^2;
rb = sqrt(r2b);

Fib = 2*atan(-y2./(-(rb+y3b)*cot(beta/2)+y1)); % The Burgers' function

v1cb1 = b1/4/pi/(1-nu)*(-2*(1-nu)*(1-2*nu)*Fib*cotB.^2+(1-2*nu)*y2./...
    (rb+y3b).*((1-2*nu-a./rb)*cotB-y1./(rb+y3b).*(nu+a./rb))+(1-2*nu).*...
    y2.*cosB*cotB./(rb+z3b).*(cosB+a./rb)+a*y2.*(y3b-a)*cotB./rb.^3+y2.*...
    (y3b-a)./(rb.*(rb+y3b)).*(-(1-2*nu)*cotB+y1./(rb+y3b).*(2*nu+a./rb)+...
    a*y1./rb.^2)+y2.*(y3b-a)./(rb.*(rb+z3b)).*(cosB./(rb+z3b).*((rb*...
    cosB+y3b).*((1-2*nu)*cosB-a./rb).*cotB+2*(1-nu)*(rb*sinB-y1)*cosB)-...
    a.*y3b*cosB*cotB./rb.^2));

v2cb1 = b1/4/pi/(1-nu)*((1-2*nu)*((2*(1-nu)*cotB^2-nu)*log(rb+y3b)-(2*...
    (1-nu)*cotB^2+1-2*nu)*cosB*log(rb+z3b))-(1-2*nu)./(rb+y3b).*(y1*...
    cotB.*(1-2*nu-a./rb)+nu*y3b-a+y2.^2./(rb+y3b).*(nu+a./rb))-(1-2*...
    nu).*z1b*cotB./(rb+z3b).*(cosB+a./rb)-a*y1.*(y3b-a)*cotB./rb.^3+...
    (y3b-a)./(rb+y3b).*(-2*nu+1./rb.*((1-2*nu).*y1*cotB-a)+y2.^2./(rb.*...
    (rb+y3b)).*(2*nu+a./rb)+a*y2.^2./rb.^3)+(y3b-a)./(rb+z3b).*(cosB^2-...
    1./rb.*((1-2*nu).*z1b*cotB+a*cosB)+a*y3b.*z1b*cotB./rb.^3-1./(rb.*...
    (rb+z3b)).*(y2.^2*cosB^2-a*z1b*cotB./rb.*(rb*cosB+y3b))));

v3cb1 = b1/4/pi/(1-nu)*(2*(1-nu)*(((1-2*nu)*Fib*cotB)+(y2./(rb+y3b).*(2*...
    nu+a./rb))-(y2*cosB./(rb+z3b).*(cosB+a./rb)))+y2.*(y3b-a)./rb.*(2*...
    nu./(rb+y3b)+a./rb.^2)+y2.*(y3b-a)*cosB./(rb.*(rb+z3b)).*(1-2*nu-...
    (rb*cosB+y3b)./(rb+z3b).*(cosB+a./rb)-a*y3b./rb.^2));

v1cb2 = b2/4/pi/(1-nu)*((1-2*nu)*((2*(1-nu)*cotB^2+nu)*log(rb+y3b)-(2*...
    (1-nu)*cotB^2+1)*cosB*log(rb+z3b))+(1-2*nu)./(rb+y3b).*(-(1-2*nu).*...
    y1*cotB+nu*y3b-a+a*y1*cotB./rb+y1.^2./(rb+y3b).*(nu+a./rb))-(1-2*...
    nu)*cotB./(rb+z3b).*(z1b*cosB-a*(rb*sinB-y1)./(rb*cosB))-a*y1.*...
    (y3b-a)*cotB./rb.^3+(y3b-a)./(rb+y3b).*(2*nu+1./rb.*((1-2*nu).*y1*...
    cotB+a)-y1.^2./(rb.*(rb+y3b)).*(2*nu+a./rb)-a*y1.^2./rb.^3)+(y3b-a)*...
    cotB./(rb+z3b).*(-cosB*sinB+a*y1.*y3b./(rb.^3*cosB)+(rb*sinB-y1)./...
    rb.*(2*(1-nu)*cosB-(rb*cosB+y3b)./(rb+z3b).*(1+a./(rb*cosB)))));

v2cb2 = b2/4/pi/(1-nu)*(2*(1-nu)*(1-2*nu)*Fib*cotB.^2+(1-2*nu)*y2./...
    (rb+y3b).*(-(1-2*nu-a./rb)*cotB+y1./(rb+y3b).*(nu+a./rb))-(1-2*nu)*...
    y2*cotB./(rb+z3b).*(1+a./(rb*cosB))-a*y2.*(y3b-a)*cotB./rb.^3+y2.*...
    (y3b-a)./(rb.*(rb+y3b)).*((1-2*nu)*cotB-2*nu*y1./(rb+y3b)-a*y1./rb.*...
    (1./rb+1./(rb+y3b)))+y2.*(y3b-a)*cotB./(rb.*(rb+z3b)).*(-2*(1-nu)*...
    cosB+(rb*cosB+y3b)./(rb+z3b).*(1+a./(rb*cosB))+a*y3b./(rb.^2*cosB)));

v3cb2 = b2/4/pi/(1-nu)*(-2*(1-nu)*(1-2*nu)*cotB*(log(rb+y3b)-cosB*...
    log(rb+z3b))-2*(1-nu)*y1./(rb+y3b).*(2*nu+a./rb)+2*(1-nu)*z1b./(rb+...
    z3b).*(cosB+a./rb)+(y3b-a)./rb.*((1-2*nu)*cotB-2*nu*y1./(rb+y3b)-a*...
    y1./rb.^2)-(y3b-a)./(rb+z3b).*(cosB*sinB+(rb*cosB+y3b)*cotB./rb.*...
    (2*(1-nu)*cosB-(rb*cosB+y3b)./(rb+z3b))+a./rb.*(sinB-y3b.*z1b./...
    rb.^2-z1b.*(rb*cosB+y3b)./(rb.*(rb+z3b)))));

v1cb3 = b3/4/pi/(1-nu)*((1-2*nu)*(y2./(rb+y3b).*(1+a./rb)-y2*cosB./(rb+...
    z3b).*(cosB+a./rb))-y2.*(y3b-a)./rb.*(a./rb.^2+1./(rb+y3b))+y2.*...
    (y3b-a)*cosB./(rb.*(rb+z3b)).*((rb*cosB+y3b)./(rb+z3b).*(cosB+a./...
    rb)+a.*y3b./rb.^2));

v2cb3 = b3/4/pi/(1-nu)*((1-2*nu)*(-sinB*log(rb+z3b)-y1./(rb+y3b).*(1+a./...
    rb)+z1b./(rb+z3b).*(cosB+a./rb))+y1.*(y3b-a)./rb.*(a./rb.^2+1./(rb+...
    y3b))-(y3b-a)./(rb+z3b).*(sinB*(cosB-a./rb)+z1b./rb.*(1+a.*y3b./...
    rb.^2)-1./(rb.*(rb+z3b)).*(y2.^2*cosB*sinB-a*z1b./rb.*(rb*cosB+y3b))));

v3cb3 = b3/4/pi/(1-nu)*(2*(1-nu)*Fib+2*(1-nu)*(y2*sinB./(rb+z3b).*(cosB+...
    a./rb))+y2.*(y3b-a)*sinB./(rb.*(rb+z3b)).*(1+(rb*cosB+y3b)./(rb+...
    z3b).*(cosB+a./rb)+a.*y3b./rb.^2));

v1 = v1cb1+v1cb2+v1cb3;
v2 = v2cb1+v2cb2+v2cb3;
v3 = v3cb1+v3cb2+v3cb3;

