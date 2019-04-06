function P = allPaxes(Sources, Point, Terrain)
%Point [N E U]
%output = [azimuth dip]

Delta = 20; % meters

delta = Delta/2; 

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) - delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Ux_x = U(2); Uy_x = U(1); Uz_x = U(3);

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) - delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Ux_y = U(2); Uy_y = U(1); Uz_y = U(3);

TmpPoint = Point;
TmpPoint(3) = TmpPoint(3) - delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Ux_z = U(2); Uy_z = U(1); Uz_z = U(3);

TmpPoint = Point;
TmpPoint(2) = TmpPoint(2) + delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Uxx = U(2); Uyx = U(1); Uzx = U(3);

TmpPoint = Point;
TmpPoint(1) = TmpPoint(1) + delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Uxy = U(2); Uyy = U(1); Uzy = U(3);

TmpPoint = Point;
TmpPoint(3) = TmpPoint(3) + delta;
U = allDisplacement(Sources, TmpPoint, Terrain);
Uxz = U(2); Uyz = U(1); Uzz = U(3);

Exx = (Uxx-Ux_x)/Delta;
Eyy = (Uyy-Uy_y)/Delta;
Ezz = (Uzz-Uz_z)/Delta;

Exy = 0.5 * ((Uxy-Ux_y)/Delta + (Uyx-Uy_x)/Delta);
Eyz = 0.5 * ((Uyz-Uy_z)/Delta + (Uzy-Uz_y)/Delta);
Ezx = 0.5 * ((Uzx-Uz_x)/Delta + (Uxz-Ux_z)/Delta);

E = [Exx Exy Ezx
          Exy Eyy Eyz
          Ezx Eyz Ezz];
   
Tensor = E;

% % Hooke's Law
% mu = Terrain.rmu;
% lambda = 2*Terrain.Poisson*mu/(1-2*Terrain.Poisson);
% 
% Tensor = 2*mu*E + lambda*trace(E)*eye(3);
     
if sum(isnan(Tensor(:)))>0
    P = [9999 9999];
    return;
end
    
[V,D] = eig(Tensor);

if (D(1,1)>0)
        disp('Warning the P axes can be wrong because not in compression');
end

if (D(2,2)>0)
    Pax = V(:,1);
else
    Pax = V(:,3);
end

[azimN dip] = decomP(Pax);
P = [azimN dip];
