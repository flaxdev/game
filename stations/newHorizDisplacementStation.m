function S = newHorizDisplacementStation()

S = newStation();

S.Type = 'HorizDisplacement';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 2;
S.NameMeasurements = {'dN','dE'};
S.Measurements = [0 0];
S.Errors = [0.001 0.001];