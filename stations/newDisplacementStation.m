function S = newDisplacementStation()

S = newStation();

S.Type = 'Displacement';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 3;
S.NameMeasurements = {'dN','dE','dU'};
S.Measurements = [0 0 0];
S.Errors = [0.001 0.001 0.001];