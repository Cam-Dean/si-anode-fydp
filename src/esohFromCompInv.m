function [cN, cP, x0, y0] = esohFromCompInv(cN, cP, cLi)
    
    % Assumption: x0 = 0 (anode limited at EOD)
    x0 = 0;

    y0 = (cLi - cN*x0)/cP;

end