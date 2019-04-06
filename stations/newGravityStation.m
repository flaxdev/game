function S = newGravityStation()

S = newStation();

S.Type = 'Gravity';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 1;
S.NameMeasurements = {'g(microGal)'};
S.Measurements = [0];
S.Errors = [0.001];