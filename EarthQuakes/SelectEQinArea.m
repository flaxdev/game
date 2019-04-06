function EarthQuakes = SelectEQinArea(EarthQuakes, LatRange, LonRange)

ilat = find( (EarthQuakes(:,1)> LatRange(1)) & (EarthQuakes(:,1)< LatRange(2)) );
ilon = find( (EarthQuakes(:,2)> LonRange(1)) & (EarthQuakes(:,2)< LonRange(2)) );

icoord = intersect(ilat,ilon);

EarthQuakes = EarthQuakes(icoord,:);
