function [Coord, Tensor] = getRealStrain(handles)

for k=1:length(handles.Sensors)
    E(k) = handles.Sensors(k).Coordinates(2);
    N(k) = handles.Sensors(k).Coordinates(1);
end

extrs = minmax([E',N']');

extrs = extrs + 0.1*repmat(diff(extrs')',1,2).*[-1 1; -1 1];

Xrange = extrs(1,:);
Yrange = extrs(2,:);

Km = min(diff(Xrange), diff(Yrange))/50;

Y = (Yrange(1)+(mod(Yrange(2)-Yrange(1),Km)+1)/2):Km:Yrange(2);
X = (Xrange(1)+(mod(Xrange(2)-Xrange(1),Km)+1)/2):Km:Xrange(2);

[XMat YMat] = meshgrid(X,Y);


Coord = [YMat(:) XMat(:) zeros(length(XMat(:)),1)];

stationfoo.Type = 'Displacement';
hand = mapModel(stationfoo);

deltameter = 1;
wh = waitbar(0,'Please wait or die');

for j=1:size(Coord,1)

waitbar(j/size(Coord,1),wh);
    % x
    Point = Coord(j,:) + [0 1 0]*deltameter;
    Ux1 = hand(handles.Sources, Point , handles.Terrain);

    Point = Coord(j,:) + [0 -1 0]*deltameter;
    Ux_1 = hand(handles.Sources, Point , handles.Terrain);

    % y
    Point = Coord(j,:) + [1 0 0]*deltameter;
    Uy1 = hand(handles.Sources, Point , handles.Terrain);

    Point = Coord(j,:) + [-1 0 0]*deltameter;
    Uy_1 = hand(handles.Sources, Point , handles.Terrain);


    Tensor(j,1) = (Ux1(2)-Ux_1(2))/(2*deltameter);
    Tensor(j,4) = (Uy1(1)-Uy_1(1))/(2*deltameter) ;
    Tensor(j,2) = 0.5*((Ux1(1)-Ux_1(1))/(2*deltameter) + (Uy1(2)-Uy_1(2))/(2*deltameter));
%     Tensor(j,2) = 0.5*((Uxy1(1)-Uxy_1(1))/(2*deltameter) + (Uxy1(2)-Uxy_1(2))/(2*deltameter));
    Tensor(j,3) = Tensor(j,2);

end
close(wh);

Coord;
Tensor;

