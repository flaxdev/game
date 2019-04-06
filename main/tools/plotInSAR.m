function plotInSAR(xmin,ymin,xmax,ymax, z0, resolution, azimuth, elevation, sources, novertical, wrapped, Terrain)

[X,Y] = meshgrid( linspace(xmin,xmax, ceil( (xmax-xmin)/resolution ) + 1), ...
                 linspace(ymin,ymax, ceil( (ymax-ymin)/resolution ) + 1) );

             
versor = -[sind(90-azimuth)*sind(elevation), -cosd(90-azimuth)*sind(elevation),  cosd(elevation)];             

SAR = nan(size(X));             



for i=1:size(X,1)
    for j=1:size(X,2)
        
        u = allDisplacement(sources, [Y(i,j), X(i,j), z0 ], Terrain);
        u = u([2 1 3]);
        
        if novertical
            u(3) = 0;
        end
                
        SAR(i,j) = u*versor';                
    end
end
             
if wrapped
%     SAR = sin(SAR);
    SAR = mod(SAR,pi/100)*100;
end

figure

imagesc(X(1,:),Y(:,1),SAR)
colormap jet
set(gca,'YDir','normal')
axis equal
xlim([xmin, xmax]);
ylim([ymin, ymax]);


