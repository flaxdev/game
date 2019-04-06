function S = newStation()

S.Type = 'StationType';
S.Name = 'StationName';
S.Coordinates = [0 0 0]; % North - East - Up
S.CoordinateType = 'UTM-NEU';
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 3;
S.NameMeasurements = {'a','a','a'};
S.Measurements = [0 0 0];
S.Errors = [0 0 0];
S.Weight = 1;
