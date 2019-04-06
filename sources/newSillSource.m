function S = newSillSource()

S = newSource();

S.Type = 'Sill';
S.NParameters = 5;
S.ParameterNames = {'E','N','U','r','dP'};
S.Parameters = [0 0 0 0 0];
S.EParameters = [0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 -10000 0 -1e8];
S.UpBoundaries  = [ 1e7  1e7  1000  10000  1e8];
S.ActiveParameters = [ 1  1  1  1  1];