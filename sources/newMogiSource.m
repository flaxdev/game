function S = newMogiSource()

S = newSource();

S.Type = 'Mogi';
S.NParameters = 4;
S.ParameterNames = {'E','N','U','dV'};
S.Parameters = [0 0 0 0];
S.EParameters = [0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 -1e4 -1e7];
S.UpBoundaries  = [ 1e7  1e7  0  1e7];
S.ActiveParameters = [ 1  1  1  1];
