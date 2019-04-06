function S = newLevellingStation()

S = newStation();

S.Type = 'Altimeter';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 1;
S.NameMeasurements = {'dH'};
S.Measurements = [0];
S.Errors = [0.001];