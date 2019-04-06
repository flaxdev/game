function dur = mctigueA8A18(tt,nu,rho,zzn)
% first free surface correction
% displacement functions (A8) and (A18) of McTigue (1987)
%==========================================================================
% USGS Software Disclaimer 
% The software and related documentation were developed by the U.S. 
% Geological Survey (USGS) for use by the USGS in fulfilling its mission. 
% The software can be used, copied, modified, and distributed without any 
% fee or cost. Use of appropriate credit is requested. 
%
% The USGS provides no warranty, expressed or implied, as to the correctness 
% of the furnished software or the suitability for any purpose. The software 
% has been tested, but as with any complex software, there could be undetected 
% errors. Users who find errors are requested to report them to the USGS. 
% The USGS has limited resources to assist non-USGS users; however, we make 
% an attempt to fix reported problems and help whenever possible. 
%==========================================================================

sigma = 0.5*tt.*exp(-tt);
tau1 = sigma;

A8 = 0.5*sigma.*((1-2*nu)-tt.*zzn).*exp(-tt.*zzn).*besselj(1,tt.*rho);
A18 = 0.5*tau1.*(2*(1-nu)-tt.*zzn).*exp(-tt.*zzn).*besselj(1,tt.*rho);
dur = A8 + A18;
