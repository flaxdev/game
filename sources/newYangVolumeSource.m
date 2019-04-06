function S = newYangVolumeSource()

S = newSource();

S.Type = 'YangVolume';
S.NParameters = 8;
S.ParameterNames = {'E','N','U','ExcVol(m3)','Ratio_Ax','Strike','Plunge','ExcPress(Pa)'};
S.Parameters = [0 0 0 0 0 0 0 10e9];
S.EParameters = [0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 -10000 0 0.01 0 0 0];
S.UpBoundaries  = [ 1e7  1e7  0  10000  0.99  180  360 0];
S.ActiveParameters = [ 1  1  1  1  1  1  1  0];