function U = doDisplacement(params, Stations, Terrain, Type)

if strcmp(Type,'Davis') 
    U = getDavis(params, Stations, Terrain);
elseif strcmp(Type,'Mogi') 
    U = getMogi(params, Stations, Terrain);
elseif strcmp(Type,'MogiPressure') 
    U = getMogiPressure(params, Stations, Terrain);
elseif strcmp(Type,'Okada') 
    U = getOkada(params, Stations, Terrain);
elseif strcmp(Type,'OkadaXS') 
    U = getOkadaXS(params, Stations, Terrain);
elseif strcmp(Type,'OkadaDensity') 
    U = getOkada(params(1:10), Stations, Terrain);
elseif strcmp(Type,'OkadaOnFault') 
    U = getOkadaOnFault(params, Stations, Terrain);
elseif strcmp(Type,'Yang') 
    U = getYang(params, Stations, Terrain);
elseif strcmp(Type,'YangVolume') 
    U = getYangVolume(params, Stations, Terrain);
elseif strcmp(Type,'Pipe') 
    U = getPipe(params, Stations, Terrain);
elseif strcmp(Type,'OpenPipe') 
    U = getOpenPipe(params, Stations, Terrain);
elseif strcmp(Type,'Sill') 
    U = getSill(params, Stations, Terrain);
elseif strcmp(Type,'Penny') 
    U = getPenny(params, Stations, Terrain);
elseif strcmp(Type,'McTigue') 
    U = getMcTigue(params, Stations, Terrain);
elseif strcmp(Type,'McTigue3D') 
    U = getMcTigue3D(params, Stations, Terrain);
end