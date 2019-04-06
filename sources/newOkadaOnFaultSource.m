function S = newOkadaOnFaultSource()

S = newSource();

S.Type = 'OkadaOnFault';
S.NParameters = 11;
S.ParameterNames = {'SurfE','SurfN','Azim','SurfDist','DepthDist','DIP','Len2','Wid','Stk-s','Dip-s','Tens'};
S.Parameters = [0 0 0 0 0 0 0 0 0 0 0];
S.EParameters = [0 0 0 0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 0     0    0    0   0   0    -10 -10 -10];
S.UpBoundaries  = [ 1e7  1e7  359  1e5  1e5  89.9  1e5  1e5  10  10  10];
S.ActiveParameters = [ 1  1  1  1  1  1  1  1  1  1  1];