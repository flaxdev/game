function EarthQuakes = SelectEQinMagRange(EarthQuakes, MagRange)

imag = ( (EarthQuakes(:,4) > MagRange(1)) & (EarthQuakes(:,4)< MagRange(2)) );
EarthQuakes = EarthQuakes(imag,:);
