function plotHalfCellModel(cVecNModel, vVecNModel, cVecPModel, ...
    vVecPModel, cVecFullModel, vVecFullModel, linestyle)

    plot(cVecFullModel, vVecFullModel, 'k', ...
    cVecPModel, vVecPModel, 'b', cVecNModel, ...
    vVecNModel, 'r', linestyle=linestyle)
    title("Voltage vs. Capacity for Modelled Full Cell and Half-Cell Components")
    ylabel("Voltage [V]")
    xlabel("Capacity [mAh/cm^2]")

end