function F = fNLSQ(x, Sources, Stations, Terrain, Measured, Errors, Weight)

ModelsOut = [];
VModelsOut = [];


Sources = setFreeParameters(x,Sources);

for j=1:length(Stations)
    if strcmp(Stations(j).Type,'Displacement')
        O = allDisplacement(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Altimeter')
        O = allLevelling(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Tiltmeter')
        O = allTiltmeter(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Paxes')
        O = allPaxes(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'HorizDisplacement')
        O = allHorizDisplacement(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Earthquake')
        O = allEarthquake(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Strainmeter')
        O = allStrainmeter(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Baseline')
        O = allBaseline(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Gravity')
        O = allGravity(Sources,Stations(j).Coordinates, Terrain);
    end
    
    ModelsOut = [ModelsOut; O(:)];
    VModelsOut(j).out = O(:);
end

F = (ModelsOut(:)-Measured(:)).*Weight(:)./Errors(:);