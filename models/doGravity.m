function U = doGravity(params, Stations, Terrain, Type)


if strcmp(Type,'Okada') 
    U = getOkubo(params, Stations, Terrain);
elseif strcmp(Type,'OkadaDensity') 
    U = getOkubo(params, Stations, Terrain);
elseif strcmp(Type,'Mogigfgf') 
end
