function [azimN dip] = decomP(V) 
%V = [E N U]

V = V(:);

a = rad2deg(atan2(V(2),V(1)));
if (a<0) 
    a = a + 360;
end 

a = 90 - a;
if (a<0) 
    a = 360 + a;
end 

azimN = a;

dip = atand(-V(3)/sqrt(V(1)^2 + V(2)^2));

if (dip<0)
    if azimN<180
        azimN = azimN + 180;
    else
        azimN = azimN - 180;
    end
    dip = -dip;
end


% 
% azimN = rad2deg(atan2(V(1),V(2)));
% dip = atand(V(3)/sqrt(V(1)^2 + V(2)^2));
% 
% 
% if (azimN<0) 
%     azimN = azimN + 360;
% end
% 
% if (dip>0)
%     if azimN<180
%         azimN = azimN + 180;
%     else
%         azimN = azimN - 180;
%     end
% else
%     dip = -dip;
% end
