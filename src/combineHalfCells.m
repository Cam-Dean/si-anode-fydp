function [cVecNModel, vVecNModel, cVecPModel, vVecPModel, cVecFull, ...
    vVecFull] = combineHalfCells(thetaVecN, vThetaVecN, ...
    thetaVecP, vThetaVecP, cN, cP, x0, y0, vMin, vMax, chargeDir)

    % thetaVecN, vVecN, thetaVecP, and vVecP must correspond to the same 
    % charge direction
    % chargeDir is a string of either "chg" or "dchg"
    if chargeDir == "chg"
        thetaVecP = flip(thetaVecP);
        vThetaVecP = flip(vThetaVecP);

        [vThetaVecPM, thetaVecPM] = makeMonotonicVectors(vThetaVecP, thetaVecP);
        [vThetaVecNM, thetaVecNM] = makeMonotonicVectors(vThetaVecN, thetaVecN);

        cVecP = (y0 - thetaVecPM)*cP;
        cVecN = (thetaVecNM - x0)*cN;

    elseif chargeDir == "dchg"
        thetaVecN = flip(thetaVecN);
        vThetaVecN = flip(vThetaVecN);

        [vThetaVecPM, thetaVecPM] = makeMonotonicVectors(vThetaVecP, thetaVecP);
        [vThetaVecNM, thetaVecNM] = makeMonotonicVectors(vThetaVecN, thetaVecN);

        cVecP = (thetaVecPM - y0)*cP;
        cVecN = (x0 - thetaVecNM)*cN;

        % adjust capacity for EOC to be at 0
        commonCapVecAdjust = linspace(max([min(cVecN), min(cVecP)]), min([max(cVecN), max(cVecP)]), 200);
        commonVVecNAdjust = interp1(cVecN, vThetaVecNM, commonCapVecAdjust);
        commonVVecPAdjust = interp1(cVecP, vThetaVecPM, commonCapVecAdjust);
        [commonVVecAM, commonCapVecAM] = makeMonotonicVectors(commonVVecPAdjust-commonVVecNAdjust, commonCapVecAdjust);
        capShift = interp1(commonVVecAM, commonCapVecAM, vMax);
        
        cVecP = cVecP - capShift;
        cVecN = cVecN - capShift;

    else
        return
    end
    
    % calculate capacity at EOC/EOD
    commonCapVec = linspace(0, min([max(cVecP), max(cVecN)]), 200);
    commonVVecN = interp1(cVecN, vThetaVecNM, commonCapVec);
    commonVVecP = interp1(cVecP, vThetaVecPM, commonCapVec);
    [commonVVecM, commonCapVecM] = makeMonotonicVectors(commonVVecP-commonVVecN, commonCapVec);
    if chargeDir == "chg"
           
        maxC = interp1(commonVVecM, commonCapVecM, vMax);

    elseif chargeDir == "dchg"

        maxC = interp1(commonVVecM, commonCapVecM, vMin);

    else
        return
    end

    cVecFull = linspace(0, maxC, 200);
    alignedVVecN = interp1(cVecN, vThetaVecNM, cVecFull);
    alignedVVecP = interp1(cVecP, vThetaVecPM, cVecFull);
    vVecFull = alignedVVecP - alignedVVecN;

    cVecNModel = cVecN;
    vVecNModel = vThetaVecNM;
    cVecPModel = cVecP;
    vVecPModel = vThetaVecPM;

end