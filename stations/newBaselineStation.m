function S = newBaselineStation()

S = newStation();

S.Type = 'Baseline';
S.Name = 'baseline';
S.Coordinates = [0 0 0 100 100 0];
S.NameCoordinates = {'NorthA','EastA','UpA','NorthB','EastB','UpB'};
S.NMeasurements = 1;
S.NameMeasurements = {'delta(m)'};
S.Measurements = [0];
S.Errors = [0.001];