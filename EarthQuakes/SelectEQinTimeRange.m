function EarthQuakes = SelectEQinTimeRange(EarthQuakes, TimeRange)

itime = ( (EarthQuakes(:,5)> TimeRange(1)) & (EarthQuakes(:,5)< TimeRange(2)) );
EarthQuakes = EarthQuakes(itime,:);
