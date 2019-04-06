function [Measured Errors Weight Normal] = mergedata(Stations)

Measured = [];
Errors = [];
Weight = [];
TypeS = [];
Normal = [];

for j=1:length(Stations)
    Measured = [Measured; Stations(j).Measurements(:)];
    Errors = [Errors; Stations(j).Errors(:)];
    Weight = [Weight; ones(size(Stations(j).Measurements(:)))*Stations(j).Weight];
    TypeS = [TypeS; (1:length(Stations(j).Measurements(:)))'*sum(Stations(j).Type)];
end

uT = unique(TypeS);

Measured = Measured(:);
for i=1:length(uT)
    js = find(TypeS==uT(i));
    M = var(Measured(js));
    GH = minmax(Measured(js)');
    N = diff(GH);
    if (M>0) && (N>0)
        Normal(js,1) = N/M;
    else
        Normal(js,1) = 1;
    end
end
            
