function NETWORK = readVELfile(filename)

fid = fopen(filename,'r');

posfid = [];
while (~feof(fid) && isempty(posfid))
    tline = fgetl(fid);
    posfid = strfind(tline, 'GETREL');
end
Long = [];
Lat = [];
velE = [];
velN = [];
velU = [];
errvelE = [];
errvelN = [];
errvelU = [];
Names = [];
posN = [];
posE = [];

if (~isempty(posfid))
        tline = fgets(fid);
        tline = fgets(fid);
        
        tline = fgets(fid);
        while length(tline)>1
            A = sscanf(tline, '%f %f %f %f %f %f %f %f %f %f %f %f %s ');
            Long = [Long; A(1)];
            Lat = [Lat; A(2)];
            velE = [velE; A(3)];
            velN = [velN; A(4)];
            velU = [velU; A(10)];
            errvelE = [errvelE; A(7)];
            errvelN = [errvelN; A(8)];
            errvelU = [errvelU; A(12)];
            Names = [Names; {char(A(13:end)')}];
            tline = fgets(fid);
        end
                    
%         Lat = Lat*pi/180;
%         Long = Long*pi/180;
        
%         [posE(:,1) posN(:,1)] = getGlobalProjection(Lat,Long,mean(Lat),mean(Long));
        
%         for i=1:length(Lat)
%             [posN(i,1),posE(i,1)]= ell2utm(Lat(i),Long(i),6378137,0.00669437999014);
%         end
                
end

Long(Long>180) = Long(Long>180) - 360;


NETWORK.StationName = Names;
NETWORK.StationPosLat = Lat;
NETWORK.StationPosLon = Long;
NETWORK.StationVelocityNorth = velN;
NETWORK.StationVelocityEast = velE;
NETWORK.StationVelocityUp = velU;
NETWORK.StationErrorVelocityNorth = errvelN;
NETWORK.StationErrorVelocityEast = errvelE;
NETWORK.StationErrorVelocityUp = errvelU;



fclose(fid);
