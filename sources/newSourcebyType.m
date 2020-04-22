function S = newSourcebyType(type)

if strcmp(type,'Davis')
    S = newDavisSource();
elseif strcmp(type,'Mogi')
    S = newMogiSource();
elseif strcmp(type,'MogiPressure')
    S = newMogiPressureSource();
elseif strcmp(type,'Okada')
    S = newOkadaSource();
elseif strcmp(type,'OkadaDensity')
    S = newOkadaDensitySource();
elseif strcmp(type,'OkadaXS')
    S = newOkadaXSSource();
elseif strcmp(type,'OkadaOnFault')
    S = newOkadaOnFaultSource();
elseif strcmp(type,'Yang')
    S = newYangSource();
elseif strcmp(type,'YangVolume')
    S = newYangVolumeSource();
elseif strcmp(type,'Pipe')
    S = newPipeSource();
elseif strcmp(type,'OpenPipe')
    S = newOpenPipeSource();
elseif strcmp(type,'Sill')
    S = newSillSource();
elseif strcmp(type,'McTigue')
    S = newMcTigueSource();
elseif strcmp(type,'McTigue3D')
    S = newMcTigue3DSource();
elseif strcmp(type,'Penny')
    S = newPennySource();
end

