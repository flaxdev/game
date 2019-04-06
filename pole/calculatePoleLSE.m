function [latitude longitude omega covariance slat slon someg] = calculatePoleLSE(ITRF)

Nsamples = 10000;
h = waitbar(0);
for itimes = 1:Nsamples
    waitbar(itimes/Nsamples);
    newITRF = getrndITRF(ITRF);
    
    [lat lon om] = getPoleLSE(newITRF);
    Solution(itimes,:) = [lat lon om];
end
latitude = mean(Solution(:,1));
longitude = mean(Solution(:,2));
omega = mean(Solution(:,3));

covariance = cov(Solution);
close(h);

slat = std(Solution(:,1));
slon = std(Solution(:,2));
someg = std(Solution(:,3));