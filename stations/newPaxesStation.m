function S = newPaxesStation()

S = newStation();

S.Type = 'Paxes';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 2;
S.NameMeasurements = {'Azim(°N)','Dip(°)'};
S.Measurements = [0 0];
S.Errors = [10 10];
S.Weight = 0.1;