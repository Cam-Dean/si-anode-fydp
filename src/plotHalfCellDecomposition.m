function plotHalfCellDecomposition(cVecNModel, vVecNModel, cVecPModel, ...
    vVecPModel, cVecFullModel, vVecFullModel, cVecFull, vVecFull)

    % This function plots the modelled vs. measured voltage traces where
    % the modelled full cell voltage is broken down into the two half-cell
    % voltage traces

    plot(cVecFullModel, vVecFullModel, 'k--', cVecFull, vVecFull, 'k', ...
    cVecPModel, vVecPModel, 'b--', cVecNModel, vVecNModel, 'r--')
    title("Voltage vs. Capacity for Full Cell and Half-Cell Components")
    ylabel("Voltage [V]")
    xlabel("Capacity")

end