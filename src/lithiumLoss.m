function [LLI] = lithiumLoss(cEff)

    % Calculate lithium loss based on coulombic efficiency. Lithium loss is
    % equal to the ratio of electrons lost each cycle to total capacity,
    % since one electron is consumed in SEI per Li+ ion.

    LLI = (1-cEff);

end