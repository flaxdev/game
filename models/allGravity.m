function U = allGravity(Sources,Point, Terrain)
%Point [N E U]
%output = [N E U]


if any([Sources.IsActive])
    U = 0;
    for i=1:length(Sources)
        if (Sources(i).IsActive)
            u = doGravity(Sources(i).Parameters, Point, Terrain, Sources(i).Type);
            U = U + u;
        end
    end
    
else
    U = NaN;
end
