function S = newMcTigueSource()

S = newSource();

S.Type = 'McTigue';
S.NParameters = 5;
S.ParameterNames = {'E','N','U','Rad','dP'};
S.Parameters = [0 0 0 0 0];
S.EParameters = [0 0 0 0 0];
S.LowBoundaries = [-1e7 -1e7 -1e4 0 -1e7];
S.UpBoundaries  = [ 1e7  1e7  0  10000  1e7];
S.ActiveParameters = [ 1  1  1  1  1];
