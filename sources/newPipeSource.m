function S = newPipeSource()

S = newSource();

S.Type = 'Pipe';
S.NParameters = 6;
S.ParameterNames = {'E','N','c1','c2','d(radius)','dP'};
S.Parameters = [0 0 0 0 0 0];
S.EParameters = [0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7  0     -1e4  0 -1e7];
S.UpBoundaries  = [ 1e7  1e7  3000  1000  1e4  1e7];
S.ActiveParameters = [ 1  1  1  1  1  1];