function e = getmisfit(ModelsOut,Measured,Errors,Weight, NParams,errtype)

if NParams>length(ModelsOut)
    NParams = length(ModelsOut)-1;
end

% NParams=0;
if errtype == 1
    e = evalerror(ModelsOut,Measured,Errors,Weight);
elseif errtype == 2
    % mse
    e = mse(ModelsOut-Measured);
elseif errtype == 3
    % xcorr
    e = 1-xcorr(ModelsOut,Measured,0,'coeff');
elseif errtype == 4
    % xcorr*wrmse
    e = (1-xcorr(ModelsOut,Measured,0,'coeff'))*evalerror(ModelsOut,Measured,Errors,Weight);
elseif errtype == 5    
    e = evalerror(ModelsOut,Measured,Errors,Weight);
    e = abs(e - 0.99);  % avoid the overfitted models
end
