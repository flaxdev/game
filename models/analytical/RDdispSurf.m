function [ue,un,uv, P1, P2, P3, P4, nogood]=RDdispSurf(X,Y,X0,Y0,depth,L,W,plunge,dip,strike,...
    stkslip,dipslip,opening,nu)
% RDdispSurf
% calculates surface displacements associated with a rectangular
% dislocation in an elastic half-space.
%
% RD: Rectangular Dislocation
% EFCS: Earth-Fixed Coordinate System
% RDCS: Rectangular Dislocation Coordinate System
% ADCS: Angular Dislocation Coordinate System
% (The origin of the RDCS is the RD centroid. The axes of the RDCS are 
% aligned with the strike, dip and normal vectors of the RD, respectively.)
%
% INPUTS
% X and Y:
% Horizontal coordinates of calculation points in EFCS (East, North, Up).
% X and Y must have the same size.
%
% X0, Y0 and depth:
% Horizontal coordinates (in EFCS) and depth of the "RD reference point".
% The depth must be a positive value. The RD reference point is specified
% by the "RefPoint" value (see below). X0, Y0 and depth have the same unit
% as X and Y.
%
% L and W:
% The length and width of the RD (see the note on the RD geometry in the
% following). L and W have the same unit as X and Y.
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
% [X,Y] = meshgrid(-10:.02:10,-8:.02:8);
% X0 = 3; Y0 = 1; depth = 5; L = 3; W = 2; plunge = 10; dip = 45;
% strike = 30; rake = 20; slip = 1; opening = 0.15; nu = 0.25;
% RefPoint = 'Pc';
% [ue,un,uv] = RDdispSurf(X,Y,X0,Y0,depth,L,W,plunge,dip,strike,rake,...
% slip,opening,nu,RefPoint);
% figure
% surf(X,Y,reshape(ue,size(X)),'edgecolor','none')
% view(2)
% axis equal
% axis tight
% set(gcf,'renderer','zbuffer')

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

bx = opening; % Tensile-slip
by = stkslip; % Strike-slip
bz = dipslip; % Dip-slip

X = X(:);
Y = Y(:);

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

% Transform the slip vector components from RDCS into EFCS
A = [Vnorm Vstrike Vdip];
[bX,bY,bZ] = CoordTrans(bx,by,bz,A);

[u1,v1,w1] = AngSetupSurf(X,Y,bX,bY,bZ,P1,P2,nu); % Side P1P2
[u2,v2,w2] = AngSetupSurf(X,Y,bX,bY,bZ,P2,P3,nu); % Side P2P3
[u3,v3,w3] = AngSetupSurf(X,Y,bX,bY,bZ,P3,P4,nu); % Side P3P4
[u4,v4,w4] = AngSetupSurf(X,Y,bX,bY,bZ,P4,P1,nu); % Side P4P1

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

function [ue,un,uv]=AngSetupSurf(X,Y,bX,bY,bZ,PA,PB,nu)
% AngSetupSurf calculates the displacements associated with an angular
% dislocation pair on each side of an RD in a half-space.

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
    [y1A,y2A,~] = CoordTrans(X-PA(1),Y-PA(2),zeros(length(X),1)-PA(3),A);
    % Transform coordinates from EFCS to the second ADCS
    [y1AB,y2AB,~] = CoordTrans(SideVec(1),SideVec(2),SideVec(3),A);
    y1B = y1A-y1AB;
    y2B = y2A-y2AB;
    
    % Transform slip vector components from EFCS to ADCS
    [b1,b2,b3] = CoordTrans(bX,bY,bZ,A);
    
    % Determine the best artefact-free configuration for the calculation
    % points near the free surface
    I = (beta*y1A)>=0;
    
    % Configuration I
    [v1A(I),v2A(I),v3A(I)] = AngDisDispSurf(y1A(I),y2A(I),...
        -pi+beta,b1,b2,b3,nu,-PA(3));
    [v1B(I),v2B(I),v3B(I)] = AngDisDispSurf(y1B(I),y2B(I),...
        -pi+beta,b1,b2,b3,nu,-PB(3));
    
    % Configuration II
    [v1A(~I),v2A(~I),v3A(~I)] = AngDisDispSurf(y1A(~I),y2A(~I),...
        beta,b1,b2,b3,nu,-PA(3));
    [v1B(~I),v2B(~I),v3B(~I)] = AngDisDispSurf(y1B(~I),y2B(~I),...
        beta,b1,b2,b3,nu,-PB(3));
    
    % Calculate total displacements in ADCS
    v1 = v1B-v1A;
    v2 = v2B-v2A;
    v3 = v3B-v3A;
    
    % Transform total displacements from ADCS to EFCS
    [ue,un,uv] = CoordTrans(v1,v2,v3,A');
end

function [v1,v2,v3] = AngDisDispSurf(y1,y2,beta,b1,b2,b3,nu,a)
% AngDisDispSurf calculates the displacements associated with an angular
% dislocation in a half-space.

sinB = sin(beta);
cosB = cos(beta);
cotB = cot(beta);
z1 = y1*cosB+a*sinB;
z3 = y1*sinB-a*cosB;
r2 = y1.^2+y2.^2+a^2;
r = sqrt(r2);

Fi = 2*atan(-y2./(-(r+a)*cot(beta/2)+y1)); % The Burgers function

v1b1 = b1/2/pi*((1-(1-2*nu)*cotB^2)*Fi+y2./(r+a).*((1-2*nu)*(cotB+y1./...
    2./(r+a))-y1./r)-y2.*(r*sinB-y1)*cosB./r./(r-z3));
v2b1 = b1/2/pi*((1-2*nu)*((.5+cotB^2)*log(r+a)-cotB/sinB*log(r-z3))-1./...
    (r+a).*((1-2*nu)*(y1*cotB-a/2-y2.^2./2./(r+a))+y2.^2./r)+y2.^2*...
    cosB./r./(r-z3));
v3b1 = b1/2/pi*((1-2*nu)*Fi*cotB+y2./(r+a).*(2*nu+a./r)-y2*cosB./...
    (r-z3).*(cosB+a./r));

v1b2 = b2/2/pi*(-(1-2*nu)*((.5-cotB^2)*log(r+a)+cotB^2*cosB*log(r-z3))-...
    1./(r+a).*((1-2*nu)*(y1*cotB+.5*a+y1.^2./2./(r+a))-y1.^2./r)+z1.*(r*...
    sinB-y1)./r./(r-z3));
v2b2 = b2/2/pi*((1+(1-2*nu)*cotB^2)*Fi-y2./(r+a).*((1-2*nu)*(cotB+y1./...
    2./(r+a))-y1./r)-y2.*z1./r./(r-z3));
v3b2 = b2/2/pi*(-(1-2*nu)*cotB*(log(r+a)-cosB*log(r-z3))-y1./(r+a).*(2*...
    nu+a./r)+z1./(r-z3).*(cosB+a./r));

v1b3 = b3/2/pi*(y2.*(r*sinB-y1)*sinB./r./(r-z3));
v2b3 = b3/2/pi*(-y2.^2*sinB./r./(r-z3));
v3b3 = b3/2/pi*(Fi+y2.*(r*cosB+a)*sinB./r./(r-z3));

v1 = v1b1+v1b2+v1b3;
v2 = v2b1+v2b2+v2b3;
v3 = v3b1+v3b2+v3b3;
