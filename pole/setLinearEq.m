function [L, A, C] = setLinearEq(ITRF, R)

nstations = size(ITRF.StationCoord,1);

ni = 0;
for i=1:nstations
        ni = ni+1;
        L(ni) =  ITRF.StationVelocity(i,1);
        A(ni,:) = R*[0 ITRF.StationCoord(i,3) -ITRF.StationCoord(i,2)];
        C(ni) = ITRF.EStationVelocity(i,1) + R*mean(ITRF.EStationCoord(i,:));
        
        ni = ni+1;
        L(ni) =  ITRF.StationVelocity(i,2);
        A(ni,:) = R*[-ITRF.StationCoord(i,3) 0 ITRF.StationCoord(i,1)];
        C(ni) = ITRF.EStationVelocity(i,2) + R*mean(ITRF.EStationCoord(i,:));

        ni = ni+1;
        L(ni) =  ITRF.StationVelocity(i,3);
        A(ni,:) = R*[ITRF.StationCoord(i,2) -ITRF.StationCoord(i,1) 0];
        C(ni) = ITRF.EStationVelocity(i,3) + R*mean(ITRF.EStationCoord(i,:));
end

C = diag(C);
L = L';