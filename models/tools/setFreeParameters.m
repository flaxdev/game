function [Sources, ivar] = setFreeParameters(x,Sources)

ivar = 0;
for i=1:length(Sources)
    if (Sources(i).IsActive)
                for k=1:Sources(i).NParameters
                    if Sources(i).ActiveParameters(k)
                        ivar = ivar+1;
                        Sources(i).Parameters(k) = x(ivar);
                    end
                end
    end
end