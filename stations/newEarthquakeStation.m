function S = newEarthquakeStation()

S = newStation();

S.Type = 'Earthquake';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 3;
S.NameMeasurements = {'Mw','dist','area'};
S.Measurements = [1 0 0];
S.Errors = [0.1 500 Inf];