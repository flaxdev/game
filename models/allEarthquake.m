function O = allEarthquake(Sources,Point, Terrain)
%Point [N E U]
%output = {'Mw','dist','area'};

Su = 0;
d = Inf;
area = 0;
if any([Sources.IsActive])
    
    for i=1:length(Sources)
        if (Sources(i).IsActive)
            if strcmp(Sources(i).Type,'Okada') || strcmp(Sources(i).Type,'OkadaOnFault') || strcmp(Sources(i).Type,'OkadaXS') || strcmp(Sources(i).Type,'OkadaDensity')
                Len2 = Sources(i).Parameters(6)*100; % in cm
                w = Sources(i).Parameters(7)*100; % in cm
                strk = Sources(i).Parameters(8)*100; % in cm
                slpp = Sources(i).Parameters(9)*100; % in cm
                tens = Sources(i).Parameters(10)*100; % in cm
                if strcmp(Sources(i).Type,'OkadaXS')
                    X0 = Sources(i).Parameters(1);
                    Y0 = Sources(i).Parameters(2);
                    depth = -Sources(i).Parameters(3);
                    
                    L = Sources(i).Parameters(6);
                    W = Sources(i).Parameters(7);
                    
                    plunge = Sources(i).Parameters(11);
                    strike = Sources(i).Parameters(4);
                    dip = Sources(i).Parameters(5);
                    opening = Sources(i).Parameters(10);
                    
                    Stks = Sources(i).Parameters(8);
                    Dips = Sources(i).Parameters(9);
                    
                    rake = atand(Dips/Stks);
                    slip = sqrt(Dips^2 + Stks^2);
                    
                    nu = 0.25;
                    % ###################################
                    
                    [~,~,~, P1, P2, P3, P4]=RDdispSurf(0,0,X0,Y0,depth,L,W,plunge,dip,strike, rake,slip,opening,nu, 0);
                    
                    
                    x = [P1(1), P2(1), P3(1), P4(1), P1(1)];
                    y = [P1(2), P2(2), P3(2), P4(2), P1(2)];
                    z = [P1(3), P2(3), P3(3), P4(3), P1(3)];
                    RECT = [x',y',z'];
                else
                    [X,Y,Z] = FaultVertex(Sources(i).Parameters(1:7));
                    RECT = [X(1,1) Y(1,1) Z(1,1)
                        X(2,1) Y(2,1) Z(2,1)
                        X(2,2) Y(2,2) Z(2,2)
                        X(1,2) Y(1,2) Z(1,2)];
                end
                d = norm(Point([2 1 3]) - mean(RECT));
                %             d = min(d,distance3dPfromRect(Point([2 1 3]),RECT));
                area = area + 2*Sources(i).Parameters(6)*Sources(i).Parameters(7);
                Su = Su + 2*Len2*w*sqrt(strk^2 + slpp^2 + tens^2);
            end
        end
    end
    
    
    M0 = Terrain.rmu*Su;
    
    
    % http://geophysics.geo.auth.gr/new_web_site_2007/download_files/costas_CV/93.pdf
    % (Hanks & Kanamori 1979)   (Aki 1966)
    Mw = (log10(M0)-16.0)/1.5;
    
    
    O = [Mw d area];
else
    O = NaN;
end