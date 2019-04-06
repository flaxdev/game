function n = mapobjfunc(name)

if strcmp(strtrim(name),'WRMSE')
    n = 1;
elseif strcmp(strtrim(name),'MSE')
    n = 2;
elseif strcmp(strtrim(name),'XCOR')
    n = 3;
elseif strcmp(strtrim(name),'XC*WRMS')
    n = 4;
elseif strcmp(strtrim(name),'Chi2')
    n = 5;
end