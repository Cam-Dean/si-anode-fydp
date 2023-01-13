function [LAMn, newAnodeElyteV] = anodeLoss(cEff, cFull, anodeElyteV)

    % This function calculates anode loss due electrolyte dryout. It
    % calculates the volume of electrolyte lost based on the moles of
    % electrons consumed by SEI. Subsequently, the anode loss is assumed to
    % be equal to the ratio of electrolyte lost. This approximation assumes
    % that electrolyte is lost in a way that disconnects each active 
    % particle from the conductive matrix individually, rather than
    % electrically isolating many particles at once.

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
    
    % Fraction of SEI reaction that consumes ethylene carbonate
    fractECReaction = 0.5; 
    % Fraction of SEI reaction that consumes dimethyl carbonate
    fractDMCReaction = 0.5;
    
    % Calculate deltaV (volume of Elyte lost)
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