function EarthQuakes = SelectEQinDepthRange(EarthQuakes, DepthRange)

idepth = ( (EarthQuakes(:,3)> DepthRange(1)) & (EarthQuakes(:,3)< DepthRange(2)) );
EarthQuakes = EarthQuakes(idepth,:);
