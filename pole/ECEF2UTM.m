function UTM = ECEF2UTM(ECEF)

[Lat,Lon,alt] = ecef_lla(ECEF(:,1),ECEF(:,2),ECEF(:,3));
[x,y] = deg2utm(rad2deg(Lat),rad2deg(Lon));

% NEU
UTM = [y,x,alt];
