function [X,Y,Z] = getSourceGraph(source)


if strcmp(source.Type,'Davis')
    [X,Y,Z] = graphDavisSource(source);
elseif strcmp(source.Type,'Mogi')
    [X,Y,Z] = graphMogiSource(source);
elseif strcmp(source.Type,'MogiPressure')
    [X,Y,Z] = graphMogiPressureSource(source);
elseif strcmp(source.Type,'Okada')
    [X,Y,Z] = graphOkadaSource(source);
elseif strcmp(source.Type,'OkadaDensity')
    [X,Y,Z] = graphOkadaSource(source);
elseif strcmp(source.Type,'OkadaXS')
    [X,Y,Z] = graphOkadaXSSource(source);
elseif strcmp(source.Type,'OkadaOnFault')
    [X,Y,Z] = graphOkadaOnFaultSource(source);
elseif strcmp(source.Type,'Yang')
    [X,Y,Z] = graphYangSource(source);
elseif strcmp(source.Type,'YangVolume')
    [X,Y,Z] = graphYangVolumeSource(source);
elseif strcmp(source.Type,'Pipe')
    [X,Y,Z] = graphPipeSource(source);
elseif strcmp(source.Type,'OpenPipe')
    [X,Y,Z] = graphOpenPipeSource(source);
elseif strcmp(source.Type,'Sill')
    [X,Y,Z] = graphSillSource(source);   
elseif strcmp(source.Type,'Penny')
    [X,Y,Z] = graphPennySource(source);   
elseif strcmp(source.Type,'McTigue')
    [X,Y,Z] = graphMcTigueSource(source);      
elseif strcmp(source.Type,'McTigue3D')
    [X,Y,Z] = graphMcTigue3DSource(source);      
end
