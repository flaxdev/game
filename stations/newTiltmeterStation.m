function S = newTiltmeterStation()

S = newStation();

S.Type = 'Tiltmeter';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 2;
S.NameMeasurements = {'Emicrorad','Nmicrorad'};
S.Measurements = [0 0];
S.Errors = [1e-12 1e-12];