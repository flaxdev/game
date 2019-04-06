function scala = findascale(Stations, Sensors)


    x=[];y=[];z=[];u=[];v=[];w=[];
    for i=1:length(Stations)
        if strcmp(Stations(i).Type,'Displacement')
            if all(isfinite(Stations(i).Measurements))
                x = [x,Stations(i).Coordinates(2)];
                y = [y,Stations(i).Coordinates(1)];
                z = [z,Stations(i).Coordinates(3)];
                
                u = [u,Stations(i).Measurements(2)];
                v = [v,Stations(i).Measurements(1)];
                w = [w,Stations(i).Measurements(3)];
            end
        elseif strcmp(Stations(i).Type,'HorizDisplacement')
            if all(isfinite(Stations(i).Measurements))
                x = [x,Stations(i).Coordinates(2)];
                y = [y,Stations(i).Coordinates(1)];
                z = [z,Stations(i).Coordinates(3)];
                
                u = [u,Stations(i).Measurements(2)];
                v = [v,Stations(i).Measurements(1)];
                w = [w,0];
            end
        end
    end
        for i=1:length(Sensors)
            if strcmp(Sensors(i).Type,'Displacement')
                if all(isfinite(Sensors(i).Measurements))
                    x = [x,Sensors(i).Coordinates(2)];
                    y = [y,Sensors(i).Coordinates(1)];
                    z = [z,Sensors(i).Coordinates(3)];
                    
                    u = [u,Sensors(i).Measurements(2)];
                    v = [v,Sensors(i).Measurements(1)];
                    w = [w,Sensors(i).Measurements(3)];
                end
            elseif strcmp(Sensors(i).Type,'HorizDisplacement')
                if all(isfinite(Sensors(i).Measurements))
                    x = [x,Sensors(i).Coordinates(2)];
                    y = [y,Sensors(i).Coordinates(1)];
                    z = [z,Sensors(i).Coordinates(3)];
                    
                    u = [u,Sensors(i).Measurements(2)];
                    v = [v,Sensors(i).Measurements(1)];
                    w = [w,0];
                end
            end
        end
    
    scala = 0;
    if ~isempty(x)
        if length(x)==1
            if length(Stations)==1
                scala = 1000;
            else
                xx=[];yy=[];zz=[];
                for ii=1:length(Stations)
                    xx = [xx,Stations(ii).Coordinates(2)];
                    yy = [yy,Stations(ii).Coordinates(1)];
                    zz = [zz,Stations(ii).Coordinates(3)];                    
                end
            end
            maxdist = max(pdist([xx;yy;zz]'));
            maxleng = max(norm([u;v;w]'));
            scala =  0.2*maxdist/maxleng;
        else
            maxdist = max(pdist([x;y;z]'));
            maxleng = max(norm([u;v;w]'));
            scala = 0.5*maxdist/maxleng;
        end
        
    end