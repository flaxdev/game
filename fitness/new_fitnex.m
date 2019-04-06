function [y, ModelsOut, Measured] = new_fitnex(x,Sources, Stations, Terrain, errtype, Measured, Errors, Weight, Normal)

ModelsOut = [];
VModelsOut = [];


[Sources, Nfittedparameters] = setFreeParameters(x,Sources);


for j=1:length(Stations)
    
    
    if strcmp(Stations(j).Type,'Displacement')
        O = allDisplacement(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Altimeter')
        O = allLevelling(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Tiltmeter')
        O = allTiltmeter(Sources,Stations(j).Coordinates, Terrain);
    elseif strcmp(Stations(j).Type,'Paxes')
        O = allPaxes(Sources,Stations(j).Coordinates, Terrain);
        ii = length(ModelsOut);
        ad = angleBetweenAxis(O(1),O(2), Measured(ii+1),Measured(ii+2));
        O = [0 abs(sind(ad))];
        Measured(ii + [1 2]) = [0 0]';
        Errors(ii + [1 2]) = [1 abs(sum(sind(Errors(ii + [1 2]))))]';
        
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
                
% y = getmisfit(ModelsOut./Normal,Measured./Normal,Errors,Weight,errtype);
y = getmisfit(ModelsOut,Measured,Errors,Weight, Nfittedparameters, errtype);

