function S = newStrainmeterStation()

S = newStation();

S.Type = 'Strainmeter';
S.Name = 'XXX';
S.Coordinates = [0 0 0];
S.NameCoordinates = {'North','East','Up'};
S.NMeasurements = 1;
S.NameMeasurements = {'Strain(micro)'};
S.Measurements = [1];
S.Errors = [0.1];