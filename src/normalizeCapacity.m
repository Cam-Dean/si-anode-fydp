function [thetaVec, vThetaVec] = normalizeCapacity(cVec, vVec)
   
    % Ensure that capacity vector is increasing
    if cVec(end) < cVec(1)

        cVec = flip(cVec);
        vVec = flip(vVec);

    end

    % Create theta vector and corresponding voltage vector
    thetaVec = linspace(0,1,200);
    vThetaVec = interp1(cVec/max(cVec), vVec, thetaVec);

    % Flip voltage vector so that it goes from delithiated to lithiated
    if vThetaVec(end) > vThetaVec(1)

        vThetaVec = flip(vThetaVec);

    end
end