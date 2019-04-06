function e = loglikelihood(P, Measured, Sources, Stations, Terrain, Errors, Weights)

ModelsOut = [];

ivar = 0;
for i=1:length(Sources)
    if (Sources(i).IsActive)
        for k=1:Sources(i).NParameters
            if Sources(i).ActiveParameters(k)
                ivar = ivar+1;
                Sources(i).Parameters(k) = P(ivar);
            end
        end
    end
end
for j=1:length(Stations)
    
    hand = mapModel(Stations(j));
    O = hand(Sources,Stations(j).Coordinates, Terrain);
    ModelsOut = [ModelsOut; O(:)];
end


e = ((nansum(((((ModelsOut(:)-Measured(:))).^2)./(Errors(:).^2+eps)))));



