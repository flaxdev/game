function U = getMcTigue3D(params, Stations, Terrain)

nu = Terrain.Poisson;
G = Terrain.rmu;
x0 = params(1);
x = Stations(2);
y0 = params(2);
y = Stations(1);
z = -Stations(3);
z0 = -params(3);
a = params(4);
P_G = params(5)/G;

if (z<0)
    z0 = z0 - z;
    z = 0;
end;

if (z < z0)
    if abs(z-z0)<2*a
        u = NaN; v = NaN; w = NaN;
    else
        [u v w] = mctigue3Ddispl(x0,y0,z0,P_G,a,nu,x,y,z);
    end
else
    if (2*z0-z>0)
        if abs(z-z0)<2*a
            u = NaN; v = NaN; w = NaN;
        else
            [u v w] = mctigue3Ddispl(x0,y0,z0,P_G,a,nu,x,y,2*z0-z);
        end
        
    else
        if abs(z-2*z0)<2*a
            u = NaN; v = NaN; w = NaN;
        else
            [u v w] = mctigue3Ddispl(x0,y0,z-2*z0,P_G,a,nu,x,y,0);
        end
    end
    r = sqrt(u^2 + v^2 + w^2);
    R = norm([x y z] - [x0 y0 z0]);
    D = sign(P_G)*r*([x y z] - [x0 y0 z0])*exp(-R/a)/R;
    u = D(1);
    v = D(2);
    w = -D(3);
end

U = [v u w];
