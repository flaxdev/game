function plotEarthQuakes(EQfilter, Eminmax, Nminmax)

EarthQuakes = readEarthQuakesDB('EarthQuakes/EQDB.csv');
EarthQuakes = SelectEQinTimeRange(EarthQuakes, EQfilter(1:2));
EarthQuakes = SelectEQinDepthRange(EarthQuakes, EQfilter(5:6));
EarthQuakes = SelectEQinMagRange(EarthQuakes, EQfilter(3:4));

[N, E]= ell2utm(EarthQuakes(:,1)*pi/180,EarthQuakes(:,2)*pi/180,6378137,0.00669437999014);

EarthQuakes(:,1) = N;
EarthQuakes(:,2) = E;

EarthQuakes = SelectEQinArea(EarthQuakes, Nminmax, Eminmax);

plot3(EarthQuakes(:,2), EarthQuakes(:,1), -EarthQuakes(:,3)*1000,'.g');
