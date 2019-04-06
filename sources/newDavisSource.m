function S = newDavisSource()

S = newSource();

S.Type = 'Davis';
S.NParameters = 10;
S.ParameterNames = {'E','N','U','P0','e1','e2','e3','ba','ca','Vol'};
S.Parameters = [0 0 0 0 0 0 0 0 0 1e15];
S.EParameters = [0 0 0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7  -1e4 -100 -90 -90 -90 0 0 -1e20];
S.UpBoundaries  = [ 1e7  1e7  0  100  90  90  90  1  1  1e20];
S.ActiveParameters = [ 1  1  1  1  1  1  1  1  1 0];
