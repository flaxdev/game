function [ITRF] = calculateRotation(ITRF, LATpole, LONpole, Omega, covar)

deg_to_rad = pi/180;

if nargin<5
    Nsamples = 1;
    covar = zeros(3);
else
    Nsamples = 10000;
end
h = waitbar(0);
POM = mvnrnd([LATpole, LONpole, Omega]',covar,Nsamples);
% OM = Omega + randn(Nsamples,1)*eomeg;

for itimes = 1:Nsamples
    waitbar(itimes/Nsamples);
    polelat = POM(itimes,1);
    polelon = POM(itimes,2);
    omega =   POM(itimes,3);

    latp= polelat*deg_to_rad;
    lonp= polelon*deg_to_rad;
    omega = omega * 1e-6 * deg_to_rad;

    [x,y,z]=lla2ecefNORM(latp,lonp,0);
    EP = [x,y,z]' * omega;

    for i=1:size(ITRF.StationCoord,1)
        Solution{itimes}(i,:) = cross(EP,ITRF.StationCoord(i,:));
    end

end

A = zeros(size(Solution{1}));
for itimes = 1:Nsamples
    A = A + Solution{itimes};
end
ITRF.StationVelocity = A/Nsamples;


A = zeros(size(Solution{1}));
for itimes = 1:Nsamples
    A = A + (Solution{itimes} - ITRF.StationVelocity).^2;
end
close(h);
ITRF.EStationVelocity = sqrt(A/(Nsamples-1));