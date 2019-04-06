function hand = mapModel(station)

if strcmp(station.Type,'Displacement')
    hand = @allDisplacement;
elseif strcmp(station.Type,'Altimeter')
    hand = @allLevelling;
elseif strcmp(station.Type,'Tiltmeter')
    hand = @allTiltmeter;
elseif strcmp(station.Type,'Paxes')
    hand = @allPaxes;
elseif strcmp(station.Type,'HorizDisplacement')
    hand = @allHorizDisplacement;
elseif strcmp(station.Type,'Earthquake')
    hand = @allEarthquake;
elseif strcmp(station.Type,'Strainmeter')
    hand = @allStrainmeter;
elseif strcmp(station.Type,'Baseline')
    hand = @allBaseline;
elseif strcmp(station.Type,'Gravity')
    hand = @allGravity;
end

