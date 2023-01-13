function [cN, cP, cLi] = compInvFromESOH(cN, cP, x0, y0)

    % Calculate the inventory of each component capacity based on the
    % electrode state of health parameters (anode capacity, cathode
    % capacity, anode fill fraction at 0 % SOC, and cathode fill fraction
    % at 0 % SOC)

    % Derived from Lee et al. (2020), Electrode State of Health Estimation 
    % for Lithium Ion Batteries Considering Half-cell Potential Change Due 
    % to Aging

    cLi = cP*y0 + cN*x0;

end