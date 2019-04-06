function S = newOkadaDensitySource()

S = newSource();

S.Type = 'OkadaDensity';
S.NParameters = 11;
S.ParameterNames = {'E','N','U','Azim','DIP','Len','Wid','Stk-s','Dip-s','Tens','dens'};
S.Parameters = [0 0 0 0 0 0 0 0 0 0 0];
S.EParameters = [0 0 0 0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 -1e5   0   0    0    0    -10 -10 -10 10];
S.UpBoundaries  = [ 1e7  1e7  0     360 89.9  1e5  1e5  10  10  10 2900];
S.ActiveParameters = [ 1  1  1  1  1  1  1  1  1  1 1];