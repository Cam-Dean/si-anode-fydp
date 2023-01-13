function [cN, cP, x0, y0] = esohFromCompInv(cN, cP, cLi)
    
    % Calculate electrode state-of-health parameters using each component
    % capacity
    % Derived from Lee et al. (2020), Electrode State of Health Estimation 
    % for Lithium Ion Batteries Considering Half-cell Potential Change Due 
    % to Aging

    % Assumption: x0 = 0 (anode limited at EOD)
    x0 = 0;

    y0 = (cLi - cN*x0)/cP;

end