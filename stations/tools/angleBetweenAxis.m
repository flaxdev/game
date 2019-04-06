function ad = angleBetweenAxis(Azim1,Dip1, Azim2,Dip2)

vettoro = [0; 1; 0];

azim = -Azim1;
rotto = [cosd(azim) -sind(azim) 0
         sind(azim)  cosd(azim) 0
           0           0        1];
       
dep = -Dip1;
rotta = [ 1     0       0
          0  cosd(dep) -sind(dep)
         0   sind(dep)  cosd(dep)];
       
V1 = rotto*rotta*vettoro;

azim = -Azim2;
rotto = [cosd(azim) -sind(azim) 0
         sind(azim)  cosd(azim) 0
           0           0        1];
       
dep = -Dip2;
rotta = [ 1     0       0
          0  cosd(dep) -sind(dep)
         0   sind(dep)  cosd(dep)];
       
V2 = rotto*rotta*vettoro;

ad = rad2deg(acos((V1'*V2)/(norm(V1)*norm(V2))));

ad = min(ad,180-ad);


