function XStations = readStations(fileid, CoordTargetType)

        XStations = [];
        utmzone = -1;
        NStations = str2num(fgets(fileid));
        for i=1:NStations
            [fid Station] = readStationFromFile(fileid);
            
            if ~strcmp(Station.CoordinateType, CoordTargetType)
                if strcmp(Station.CoordinateType,'UTM-NEU')
                    if utmzone<0
                        utmzone = char(inputdlg('UTM Zone','utm zone',1,{'33 T'}));
                    end
                    if strcmp(CoordTargetType,'Geo-LatLonUp')
                        [Station.Coordinates(1) Station.Coordinates(2)]= utm2deg(Station.Coordinates(2),Station.Coordinates(1),utmzone);
                        Station.CoordinateType = 'Geo-LatLonUp';
                    end
                elseif strcmp(Station.CoordinateType,'Geo-LatLonUp')
                    if strcmp(CoordTargetType,'UTM-NEU')
                        [Station.Coordinates(1),Station.Coordinates(2)]= ell2utm(deg2rad(Station.Coordinates(1)),deg2rad(Station.Coordinates(2)),6378137,0.00669437999014);
                        Station.CoordinateType = 'UTM-NEU';
                    end
                end
            end
            XStations = [Station, XStations];
        end

function [N,E,Zone]=ell2utm(lat,lon,a,e2,lcm)
% ELL2UTM  Converts ellipsoidal coordinates to UTM.
%   UTM northing and easting coordinates in a 6 degree
%   system.  Zones begin with zone 1 at longitude 180E
%   to 186E and increase eastward.  Formulae from E.J.
%   Krakiwsky, "Conformal Map Projections in Geodesy",
%   Dept. Surveying Engineering Lecture Notes No. 37,
%   University of New Brunswick, Fredericton, N.B.
%   Vectorized.
% Version: 31 Mar 2005
% Useage:  [N,E,Zone]=ell2utm(lat,lon,a,e2,lcm)
% Input:   lat - vector of latitudes (rad)
%          lon - vector of longitudes (rad)
%          a   - major semi-axis of ref. ell (m)
%          e2  - eccentricity squared of ref. ell.
%          lcm - optional central meridian (default =
%                standard UTM den'n)
% Output:  N   - vector of UTM northings (m)
%          E   - vector of UTM eastings (m)
%          Zone- vector of UTM zones

ko=0.9996;      % Scale factor
if lat>=0
  No=0;         % False northing (north)
else
  No=10000000;  % False northing (south)
end
Eo=500000;      % False easting

if nargin==5
  Zone=zeros(size(lat));
else
  Zone=floor((rad2deg(lon)-180)/6)+1;
  Zone=Zone+(Zone<0)*60-(Zone>60)*60;
  lcm=deg2rad(Zone*6-183);
end

lam=lon-lcm;
lam=lam-(lam>=pi)*(2*pi);
  
%fprintf('\nZones\n');
%fprintf('%3d\n',Zone');
%fprintf('\nCentral Meridians\n');
%fprintf('%3d %2d %9.6f\n',rad2dms(lcm)');
%fprintf('\nLongitudes wrt Central Meridian\n');
%fprintf('%3d %2d %9.6f\n',rad2dms(lam)');

f=1-sqrt(1-e2);
RN=a./(1-e2*sin(lat).^2).^0.5;
RM=a*(1-e2)./(1-e2*sin(lat).^2).^1.5;
t=tan(lat);
h=sqrt(e2*cos(lat).^2/(1-e2));
n=f/(2-f);

a0=1+n^2/4+n^4/64;
a2=1.5*(n-n^3/8);
a4=15/16*(n^2-n^4/4);
a6=35/48*n^3;
a8=315/512*n^4;

s=a/(1+n)*(a0*lat-a2*sin(2*lat)+a4*sin(4*lat)- ...
  a6*sin(6*lat)+a8*sin(8*lat));

E1=lam .* cos(lat);
E2=lam.^3 .* cos(lat).^3/6 .* (1-t.^2+h.^2);
E3=lam.^5 .* cos(lat).^5/120 .* ...
    (5-18*t.^2+t.^4+14*h.^2-58*t.^2 .*h.^2+13*h.^4+...
     4*h.^6-64*t.^2 .*h.^4-24*t.^2 .*h.^6);
E4=lam.^7 .*cos(lat).^7/5040 .* ...
    (61-479*t.^2+179*t.^4-t.^6);
E=Eo + ko*RN.*(E1 + E2 + E3 + E4);

N1=lam.^2/2 .* sin(lat) .* cos(lat);
N2=lam.^4/24 .* sin(lat) .* cos(lat).^3 .* ...
    (5-t.^2+9*h.^2+4*h.^4);
N3=lam.^6/720 .* sin(lat) .* cos(lat).^5 .* ...
    (61-58*t.^2+t.^4+270*h.^2-...
     330*t.^2 .*h.^2+445*h.^4+...
     324*h.^6-680*t.^2 .*h.^4+...
     88*h.^8-600*t.^2 .*h.^6-...
     192*t.^2 .*h.^8);
N4=lam.^8/40320 .* sin(lat) .* cos(lat).^7 .* ...
   (1385-311*t.^2+543*t.^4-t.^6);
N=No + ko*RN.*(s./RN + N1 + N2 + N3 + N4);

function  [Lat,Lon] = utm2deg(xx,yy,utmzone)
% -------------------------------------------------------------------------
% [Lat,Lon] = utm2deg(x,y,utmzone)
%
% Description: Function to convert vectors of UTM coordinates into Lat/Lon vectors (WGS84).
% Some code has been extracted from UTMIP.m function by Gabriel Ruiz Martinez.
%
% Inputs:
%    x, y , utmzone.
%
% Outputs:
%    Lat: Latitude vector.   Degrees.  +ddd.ddddd  WGS84
%    Lon: Longitude vector.  Degrees.  +ddd.ddddd  WGS84
%
% Example 1:
% x=[ 458731;  407653;  239027;  230253;  343898;  362850];
% y=[4462881; 5126290; 4163083; 3171843; 4302285; 2772478];
% utmzone=['30 T'; '32 T'; '11 S'; '28 R'; '15 S'; '51 R'];
% [Lat, Lon]=utm2deg(x,y,utmzone);
% fprintf('%11.6f ',lat)
%    40.315430   46.283902   37.577834   28.645647   38.855552   25.061780
% fprintf('%11.6f ',lon)
%    -3.485713    7.801235 -119.955246  -17.759537  -94.799019  121.640266
%
% Example 2: If you need Lat/Lon coordinates in Degrees, Minutes and Seconds
% [Lat, Lon]=utm2deg(x,y,utmzone);
% LatDMS=dms2mat(deg2dms(Lat))
%LatDMS =
%    40.00         18.00         55.55
%    46.00         17.00          2.01
%    37.00         34.00         40.17
%    28.00         38.00         44.33
%    38.00         51.00         19.96
%    25.00          3.00         42.41
% LonDMS=dms2mat(deg2dms(Lon))
%LonDMS =
%    -3.00         29.00          8.61
%     7.00         48.00          4.40
%  -119.00         57.00         18.93
%   -17.00         45.00         34.33
%   -94.00         47.00         56.47
%   121.00         38.00         24.96
%
% Author: 
%   Rafael Palacios
%   Universidad Pontificia Comillas
%   Madrid, Spain
% Version: Apr/06, Jun/06, Aug/06
% Aug/06: corrected m-Lint warnings
%-------------------------------------------------------------------------

% Argument checking
%
error(nargchk(3, 3, nargin)); %3 arguments required
n1=length(xx);
n2=length(yy);
n3=size(utmzone,1);
if (n1~=n2 || n1~=n3)
   error('x,y and utmzone vectors should have the same number or rows');
end
c=size(utmzone,2);
if (c~=4)
   error('utmzone should be a vector of strings like "30 T"');
end

   
 
% Memory pre-allocation
%
Lat=zeros(n1,1);
Lon=zeros(n1,1);


% Main Loop
%
for i=1:n1
   if (utmzone(i,4)>'X' || utmzone(i,4)<'C')
      fprintf('utm2deg: Warning utmzone should be a vector of strings like "30 T", not "30 t"\n');
   end
   if (utmzone(i,4)>'M')
      hemis='N';   % Northern hemisphere
   else
      hemis='S';
   end

   x=xx(i);
   y=yy(i);
   zone=str2double(utmzone(i,1:2));

   sa = 6378137.000000 ; sb = 6356752.314245;
  
%   e = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sa;
   e2 = ( ( ( sa ^ 2 ) - ( sb ^ 2 ) ) ^ 0.5 ) / sb;
   e2cuadrada = e2 ^ 2;
   c = ( sa ^ 2 ) / sb;
%   alpha = ( sa - sb ) / sa;             %f
%   ablandamiento = 1 / alpha;   % 1/f

   X = x - 500000;
   
   if hemis == 'S' || hemis == 's'
       Y = y - 10000000;
   else
       Y = y;
   end
    
   S = ( ( zone * 6 ) - 183 ); 
   lat =  Y / ( 6366197.724 * 0.9996 );                                    
   v = ( c / ( ( 1 + ( e2cuadrada * ( cos(lat) ) ^ 2 ) ) ) ^ 0.5 ) * 0.9996;
   a = X / v;
   a1 = sin( 2 * lat );
   a2 = a1 * ( cos(lat) ) ^ 2;
   j2 = lat + ( a1 / 2 );
   j4 = ( ( 3 * j2 ) + a2 ) / 4;
   j6 = ( ( 5 * j4 ) + ( a2 * ( cos(lat) ) ^ 2) ) / 3;
   alfa = ( 3 / 4 ) * e2cuadrada;
   beta = ( 5 / 3 ) * alfa ^ 2;
   gama = ( 35 / 27 ) * alfa ^ 3;
   Bm = 0.9996 * c * ( lat - alfa * j2 + beta * j4 - gama * j6 );
   b = ( Y - Bm ) / v;
   Epsi = ( ( e2cuadrada * a^ 2 ) / 2 ) * ( cos(lat) )^ 2;
   Eps = a * ( 1 - ( Epsi / 3 ) );
   nab = ( b * ( 1 - Epsi ) ) + lat;
   senoheps = ( exp(Eps) - exp(-Eps) ) / 2;
   Delt = atan(senoheps / (cos(nab) ) );
   TaO = atan(cos(Delt) * tan(nab));
   longitude = (Delt *(180 / pi ) ) + S;
   latitude = ( lat + ( 1 + e2cuadrada* (cos(lat)^ 2) - ( 3 / 2 ) * e2cuadrada * sin(lat) * cos(lat) * ( TaO - lat ) ) * ( TaO - lat ) ) * ...
                    (180 / pi);
   
   Lat(i)=latitude;
   Lon(i)=longitude;
   
end