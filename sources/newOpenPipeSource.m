function S = newOpenPipeSource()

S = newSource();

S.Type = 'OpenPipe';
S.NParameters = 7;
S.ParameterNames = {'E','N','c0','c1','c2','d(radius)','dP'};
S.Parameters = [0 0 3200 0 0 0 0 0];
S.EParameters = [0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 0   0     -1e4  0 -1e7];
S.UpBoundaries  = [ 1e7  1e7  0  2000  1000  1e4  1e7];
S.ActiveParameters = [ 1  1  0  1  1  1  1];