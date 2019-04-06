function e = Information(Params, Measured, LB, UB, Sources, Stations, Terrain, Errors, Weights)
  
logf = @(P)loglikelihood(P, Measured, Sources, Stations, Terrain, Errors, Weights);
    
delta = (UB - LB)/100;
Jf = getFisherMatrix(Params, delta, logf);
    
e = det(Jf);
