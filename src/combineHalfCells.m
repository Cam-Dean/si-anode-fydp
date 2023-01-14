function [cVecNModel, vVecNModel, cVecPModel, vVecPModel, cVecFull, ...
    vVecFull] = combineHalfCells(thetaVecN, vThetaVecN, ...
    thetaVecP, vThetaVecP, cN, cP, x0, y0, vMin, vMax, chargeDir)
    %{
    This function aims to construct a full cell voltage vector using
    given degradation parameters and the voltage as a function of degree 
    of lithiation for each half-cell 

    Glossary:
    theta:      Degree of lithiation
    thetaVec:   Vector from 0 to 1 of theta values
    vThetaVec:  Vector of voltage measurements corresponding to each theta
                value
    chargeDir:  A string of either "chg" or "dchg"

    This function creates three different basis sets:
    1) common:  Shared basis between Neg and Pos, but not aligned correctly
                to have the min or max full cell voltage aligned with 0 
                capacity
    2) extended:    Shared basis between Neg and Pos that aligns min/max
                    full cell voltage with 0 capacity, and extends to the 
                    edges of the half-cell capacity data
    3) limited: Shared basis between Neg and Pos that aligns min/max full
                cell voltage with 0 capacity and doesn't extend beyond the
                min and max full cell voltage
    %}

    % Step 1)
    % Convert Pos and Neg theta vectors to capacity basis
    % This requires flipping Pos vectors (for chg) or flipping Neg vectors
    % (for dchg), and shifting the vectors to align 0 % SOC with the 0 of
    % each capacity vector
    if chargeDir == "chg"
        % For chg, flip Pos from lithiation to delithiation
        thetaVecP = flip(thetaVecP);
        vThetaVecP = flip(vThetaVecP);

        % Ensure that half-cell voltage vectors are monotonically increasing
        [vThetaVecP, thetaVecP] = makeMonotonicVectors(vThetaVecP, thetaVecP);
        [vThetaVecN, thetaVecN] = makeMonotonicVectors(vThetaVecN, thetaVecN);

        % Calculate half-cell capacity vectors (based on Lee et al., 2020)
        cVecP = (y0 - thetaVecP)*cP;
        cVecN = (thetaVecN - x0)*cN;

    elseif chargeDir == "dchg"
        % For dchg, flip Neg from lithiation to delithiation
        thetaVecN = flip(thetaVecN);
        vThetaVecN = flip(vThetaVecN);

        % Ensure that half-cell voltage vectors are monotonically increasing
        [vThetaVecP, thetaVecP] = makeMonotonicVectors(vThetaVecP, thetaVecP);
        [vThetaVecN, thetaVecN] = makeMonotonicVectors(vThetaVecN, thetaVecN);

        % Calculate half-cell capacity vectors (based on Lee et al., 2020)
        cVecP = (thetaVecP - y0)*cP;
        cVecN = (x0 - thetaVecN)*cN;

        % adjust capacity for EOC to be at 0
        % Do this by creating common a (but not properly aligned) basis set
        % and finding the capShift value that aligns the maximum voltage 
        % with 0 capacity.
        commonCapVec = linspace(max([min(cVecN), min(cVecP)]), min([max(cVecN), max(cVecP)]), 200);
        commonVVecN = interp1(cVecN, vThetaVecN, commonCapVec);
        commonVVecP = interp1(cVecP, vThetaVecP, commonCapVec);
        [commonVVecM, commonCapVecM] = makeMonotonicVectors(commonVVecP-commonVVecN, commonCapVec);
        
        % If maximum voltage of combined voltage vector is less than vMax, 
        % reassign vMax to the maximum full cell voltage attainable within 
        % the voltage range of the Pos electrode
        if max(commonVVecM) < vMax
            vMax = max(commonVVecM); 
            disp("WARNING: with the given degradation parameters, vMax is not reached " + ...
                "within the bounds of the half cell voltage...specifically the cathode vMax")
        end
        
        capShift = interp1(commonVVecM, commonCapVecM, vMax);
        
        cVecP = cVecP - capShift; % Final aligned Pos capacity vector
        cVecN = cVecN - capShift; % Final aligned Neg capacity vector

    else
        return
    end
    
    % Step 2)
    % Calculate full cell capacity at EOC/EOD (for chg/dchg)

    % Create aligned but extended full cell capacity and voltage vectors
    extendedCapVec = linspace(max([min(cVecP), min(cVecN)]), min([max(cVecP), max(cVecN)]), 200);
    extendedVVecN = interp1(cVecN, vThetaVecN, extendedCapVec);
    extendedVVecP = interp1(cVecP, vThetaVecP, extendedCapVec);
    [extendedVVecM, extendedCapVecM] = makeMonotonicVectors(extendedVVecP-extendedVVecN, extendedCapVec);
    
    if chargeDir == "chg"
        
        % If maximum voltage of combined voltage vector is less than vMax, 
        % reassign vMax to the maximum full cell voltage attainable within 
        % the voltage range of the Pos electrode
        if max(extendedVVecM) < vMax
            vMax = max(extendedVVecM); 
            disp("WARNING: with the given degradation parameters, vMax is not reached " + ...
                "within the bounds of the half cell voltage...specifically the cathode vMax")
        end
        
        % Assign full cell capacity to maxC
        maxC = interp1(extendedVVecM, extendedCapVecM, vMax);

    elseif chargeDir == "dchg"

        % Assign full cell capacity to maxC
        maxC = interp1(extendedVVecM, extendedCapVecM, vMin);

    else
        return
    end

    % Step 3)
    % Assign minC to be 0 (ideally), or the minimum capacity where data is
    % available for both electrodes. Display a warning if minC is not 0
    minC = 0;
    if max([min(cVecN), min(cVecN)]) > minC
        minC = max([min(cVecN), min(cVecN)]);
        disp("WARNING: with the given degradation parameters, vMin is not reached" + ...
            "within the bounds of the half cell voltage.")
    end

    % Step 4)
    % Calculate full cell capacity and voltage vectors with the 
    % correct limits using maxC and the aligned half-cell capacity vectors
    cVecFull = linspace(minC, maxC, 200);
    limitedVVecN = interp1(cVecN, vThetaVecN, cVecFull);
    limitedVVecP = interp1(cVecP, vThetaVecP, cVecFull);
    vVecFull = limitedVVecP - limitedVVecN;

    % Return modelled half-cell voltage and capacity vectors that have the
    % correct limits and alignment
    cVecNModel = cVecN;
    vVecNModel = vThetaVecN;
    cVecPModel = cVecP;
    vVecPModel = vThetaVecP;

end