function newITRF = getrndITRF(ITRF)

randn('state', sum(100*clock));

newITRF = ITRF;
newITRF.StationCoord = ITRF.StationCoord + randn(size(ITRF.StationCoord)).*ITRF.EStationCoord;
newITRF.StationVelocity = ITRF.StationVelocity + randn(size(ITRF.StationVelocity)).*ITRF.EStationVelocity;
