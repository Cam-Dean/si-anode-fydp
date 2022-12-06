function plotHalfCellDecomposition(cVecNModel, vVecNModel, cVecPModel, ...
    vVecPModel, cVecFullModel, vVecFullModel, cVecFull, vVecFull)

    plot(cVecFullModel, vVecFullModel, 'k--', cVecFull, vVecFull, 'k', ...
    cVecPModel, vVecPModel, 'b--', cVecNModel, vVecNModel, 'r--')
    title("Voltage vs. Capacity for Full Cell and Half-Cell Components")
    ylabel("Voltage [V]")
    xlabel("Capacity")

end