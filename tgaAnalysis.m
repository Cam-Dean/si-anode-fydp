%%% Load Data
input = readtable("tga_data_n2.xlsx");
tGO = rmmissing(table2array(input(:,"t_go")));
wGO = rmmissing(table2array(input(:,"w_go")));
tPS = rmmissing(table2array(input(:,"t_ps")));
wPS = rmmissing(table2array(input(:,"w_ps")));
tPR = rmmissing(table2array(input(:,"t_pre_red")));
wPR = rmmissing(table2array(input(:,"w_pre_red")));

%%% Remove Duplicates and Increasing Values
i = 2;
while i < length(tGO)+1
    if tGO(i) == tGO(i-1)
        tGO(i) = [];
        wGO(i) = [];
        i = i-1;
    end
    if tGO(i) < tGO(i-1)
        tGO(i) = [];
        wGO(i) = [];
        i = i-1;
    end
    i = i+1;
end

i = 2;
while i < length(tPS)+1
    if tPS(i) == tPS(i-1)
        tPS(i) = [];
        wPS(i) = [];
        i = i-1;
    end
    if tPS(i) < tPS(i-1)
        tPS(i) = [];
        wPS(i) = [];
        i = i-1;
    end
    i = i+1;
end

i = 2;
while i < length(tPR)+1
    if tPR(i) == tPR(i-1)
        tPR(i) = [];
        wPR(i) = [];
        i = i-1;
    end
    if tPR(i) < tPR(i-1)
        tPR(i) = [];
        wPR(i) = [];
        i = i-1;
    end
    i = i+1;
end

% Interpolate weight % vectors
tCommon = linspace(100,600,100)';

wGOCommon = interp1(tGO,wGO,tCommon);
wPSCommon = interp1(tPS,wPS,tCommon);
wPRCommon = interp1(tPR,wPR,tCommon);
wSiCommon = ones(length(tCommon),1);

% Solve minimization problem
% NOTE: Minimzation problem was not optimized to align dw/dT peaks, so
% further manual adjustment was used to find the best solution below
%{
fGO = 0.44;
fPS = 0.28;
f0 = [fGO, fPS];

fun = @(f)combinedTGA(f, wGOCommon, wPSCommon, wSiCommon, wPRCommon);
f = fsolve(fun, f0);
f
%}

% Calculate combined TGA weight vector
fGO = 0.4;
fPS = 0.193;
f = [fGO, fPS]
wTGA = f(1)*wGOCommon + f(2)*wPSCommon + (1-f(1)-f(2))*wSiCommon;

% Compare combined TGA curve to PR curve
plot(tCommon, wPRCommon, tCommon, wTGA)

% Save data
filePath = "C:\Users\Cameron\Desktop\School Work\si-anode-fydp\data\tga_output.csv";
columns = ["tCommon", "wGO", "wPS", "wSi", "wPR", "wTGA"];
output = table(tCommon, wGOCommon, wPSCommon, wSiCommon, wPRCommon, wTGA, 'VariableNames', columns);
writetable(output, filePath)

function res = combinedTGA(f, wGOCommon, wPSCommon, wSiCommon, wPRCommon)
    % f = [fGO, fPS, fSi]
    wTGA = f(1)*wGOCommon + f(2)*wPSCommon + (1-f(1)-f(2))*wSiCommon;
    res = wTGA - wPRCommon;
end