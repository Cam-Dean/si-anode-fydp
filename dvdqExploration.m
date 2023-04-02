% 1st C/10 Charge 3-1-6
%{
data = readtable("3-1-6_Formation_and_Cap_Check_004_1~2.xlsx", "Sheet", 3);

cyc2 = data(data.CycleNo == 2, :);
c2 = table2array(cyc2(:,"Capacity_mAh"));
v2 = table2array(cyc2(:,"Voltage_V"));
dvdq2 = diff(v2)./diff(c2);

%plot(c2, v2)
plot(c2, smoothdata([Inf; dvdq2]))
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd C/10 Charge 3-1-6 (standard)
%{
data = readtable("3-1-6_Cap_Check_Rd2_Cyc_004_1.xlsx", "Sheet", 3);

cyc2 = data(data.CycleNo == 2 & data.Record < 864, :);
c2 = table2array(cyc2(:,"Capacity_mAh"));
v2 = table2array(cyc2(:,"Voltage_V"));
dvdq2 = diff(v2)./diff(c2);

%plot(c2, v2)
plot(c2, [Inf; dvdq2])
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd C/10 Charge 3-1-6 (smoothed)

data = readtable("3-1-6_Cap_Check_Rd2_Cyc_004_1.xlsx", "Sheet", 3);

cyc2 = data(data.CycleNo == 2 & data.Record < 864, :);
c2 = table2array(cyc2(:,"Capacity_mAh"));
v2 = table2array(cyc2(:,"Voltage_V"));
dvdq2 = [10; diff(v2)./diff(c2)];

% drop NaN and Inf
c2new = c2;
i = 1;
while i < length(c2new)+1

    if ~isfinite(dvdq2(i))
        dvdq2(i) = [];
        c2new(i) = [];
        i = i-1;
    end
    i = i+1;
end

%plot(c2, v2)
plot(c2new, smoothdata(dvdq2, 'gaussian', 40))
xlabel("Capacity [mAh]")
ylabel("dV/dQ [V/mAh]")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C/10 Anode vs. Lithium
%{
data = readtable("6-6-L_Formation_and_Cap_Check_004_2.xlsx", "Sheet", 3);

cyc2 = data(data.CycleNo == 2 & data.Record > 1273, :);
c2 = table2array(cyc2(:,"Capacity_mAh"));
v2 = table2array(cyc2(:,"Voltage_V"));
dvdq2 = -[-10; diff(v2)./diff(c2)];

%plot(c2, v2)
plot(c2, dvdq2)
% drop NaN and Inf
c2new = c2;
i = 1;
while i < length(c2new)+1

    if ~isfinite(dvdq2(i))
        dvdq2(i) = [];
        c2new(i) = [];
        i = i-1;
    end
    i = i+1;
end

%plot(c2new, smoothdata(dvdq2, 'gaussian', 5))
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C/10 Cathode vs. Lithium
%{
data = readtable("LCO_vs_Lithium.xlsx", "Sheet", 4);

cyc2 = data(data.Step == 6, :);
c2 = table2array(cyc2(:,"Capacity"));
v2 = table2array(cyc2(:,"Voltage"));
dvdq2 = [10; diff(v2)./diff(c2)];

plot(c2, v2)
%plot(c2, dvdq2)
% drop NaN and Inf
c2new = c2;
i = 1;
while i < length(c2new)+1

    if ~isfinite(dvdq2(i))
        dvdq2(i) = [];
        c2new(i) = [];
        i = i-1;
    end
    i = i+1;
end

%plot(c2new, smoothdata(dvdq2, 'gaussian', 5))
%}
