function S = newYangSource()

S = newSource();

S.Type = 'Yang';
S.NParameters = 8;
S.ParameterNames = {'E','N','U','ExcPres(Pa)','SemiMaj_Ax(m)','Ratio_Ax','Strike','Plunge'};
S.Parameters = [0 0 0 0 0 0 0 0];
S.EParameters = [0 0 0 0 0 0 0 0];
S.LowBoundaries = [-1 -1 -10000 -1 0 0.01 0 0];
S.UpBoundaries  = [ 1  1  0  1  10000  0.99  360  89];
S.ActiveParameters = [ 1  1  1  1  1  1  1  1];