function NETWORK = readORGfile(filename)

fid = fopen(filename,'r');

posfid = [];
while (~feof(fid) && isempty(posfid))
    tline = fgetl(fid);
    posfid = strfind(tline, 'Solution commenced with:');
end
startyear = 0;
stopyear = 0;
if (~isempty(posfid))
    i1 = strfind(tline, '(')+1;
    i2 = strfind(tline, ')')-1;
    startyear = str2double(tline(i1:i2));
    
    tline = fgetl(fid);
    i1 = strfind(tline, '(')+1;
    i2 = strfind(tline, ')')-1;
    stopyear = str2double(tline(i1:i2));
end
    

posfid = [];
while (~feof(fid) && isempty(posfid))
    tline = fgetl(fid);
    posfid = strfind(tline, 'SUMMARY VELOCITY ESTIMATES');
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
        while (tline(1)~='V')
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
NETWORK.NumberOfConsideredDays = (stopyear-startyear)*365;


posfid = [];
while (~feof(fid) && isempty(posfid))
    tline = fgetl(fid);
    posfid = strfind(tline, 'COVARIANCE MATRIX');
end

Cv = [];
if (~isempty(posfid))
        tline = fgets(fid);
        C = textscan(fid, '%f %f %f');
        S = sparse(C{1},C{2},C{3});
        Cv = full(S);
        Cv = Cv + Cv' - diag(diag(Cv));
        nstatz = length(NETWORK.StationName);
        Cv((nstatz*6+1):end,:) = [];
        Cv(:,(nstatz*6+1):end) = [];
        nrow = size(Cv,1);
        q = [1:6:nrow; 2:6:nrow; 3:6:nrow;];       
        Cv(q(:),:) = [];
        Cv(:,q(:)) = [];
        
        A = zeros(size(Cv));
        for ix = 1:length(NETWORK.StationName)
            i = 1+(ix-1)*3;
            A(i:(i+2),i:(i+2)) = ...
                [-sin(Lat(ix))*cos(Long(ix))    -sin(Lat(ix))*sin(Long(ix))     cos(Lat(ix))
                -sin(Long(ix))                  cos((Long(ix)))                 0
                -cos(Lat(ix))*cos(Long(ix))     -cos(Lat(ix))*sin(Long(ix))     -sin(Lat(ix))];
        end
        
        Cv = A*Cv*(A');
        nrow = size(Cv,1);
        q = 3:3:nrow;       
        Cv(q,:) = [];
        Cv(:,q) = [];
%         % from N-E to E-N
          for i=1:nstatz
              Cv(:,((i-1)*2+1):(i*2)) = fliplr(Cv(:,((i-1)*2+1):(i*2)));
          end
          for i=1:nstatz
              Cv(((i-1)*2+1):(i*2),:) = flipud(Cv(((i-1)*2+1):(i*2),:));
          end

end
NETWORK.VelocityCovarianceMatrix = Cv;

fclose(fid);
