function [LAMn, newAnodeElyteV] = anodeLoss(cEff, cFull, anodeElyteV)

    % Define Constants
    F = 96485; % C/mol
    mmC = 12.0107; % g/mol
    mmO = 15.9994; % g/mol
    mmH = 1.00784; % g/mol
    mmEC = 3*mmO + 3*mmC + 4*mmH; % g/mol
    mmDMC = 3*mmO + 3*mmC + 6*mmH; % g/mol
    densityEC = 1.32; % g/cm^3
    densityDMC = 1.07; % g/cm^3
    densitySEILayer = inf;
    
    fractECReaction = 0.5;
    fractDMCReaction = 0.5;
    
    % Calculate deltaV
    molReactedElectrons = (1-cEff)*cFull/F;

    deltaVEC = fractECReaction*(molReactedElectrons*mmEC/densityEC - ...
        molReactedElectrons*mmEC/densitySEILayer);

    deltaVDMC = fractDMCReaction*(molReactedElectrons*mmDMC/densityDMC - ...
        molReactedElectrons*mmDMC/densitySEILayer);

    deltaV = deltaVEC + deltaVDMC;

    % Calculate Active Material Loss and New Elyte Volume
    LAMn = deltaV / anodeElyteV;
    newAnodeElyteV = anodeElyteV - deltaV;

end