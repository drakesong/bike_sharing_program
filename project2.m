% Clear workspace and close all open figures
clear
close all
fprintf('\nStarting project...\n')

% Import data and extract from the struct
raw_data = importdata('day.csv');
data = raw_data.data;

% Set X to features and Y to total number of users
X = data(:, 1:11);
Y = data(:, 14);

% Initialize value
[u,v] = size(X);

% Determine test data
num_test = round(u*0.1);
test_idx = sort(randperm(u, num_test));
X_test = X(test_idx, :);
Y_test = Y(test_idx, :);
X(test_idx, :) = [];
Y(test_idx, :) = [];

% Set data for lasso (used later)
X_lasso = X;

% Plot to determine correlation between features
checkCorrelation(X)

fprintf('Press enter to continue\n')
pause
close

% Determine which feature to remove by comparing adjusted R-squared
fprintf('\nUpdating data...\n')
X_1 = X(:, [1 2 3 4 5 6 7 8 10 11]);
X_2 = X(:, [1 2 3 4 5 6 7 9 10 11]);

mdl_1 = fitlm(X_1, Y);
mdl_2 = fitlm(X_2, Y);

[X, mdl] = compareRSquared(X_1, mdl_1, X_2, mdl_2);
X_test(:, 8) = [];
X_lasso(:, 8) = [];

% Check if there's another correlation
checkCorrelation(X)

fprintf('Press enter to continue\n')
pause
close

% Initialize values
[m,n] = size(X);

% Run backward step selection
[X, mdl] = backwardStepSel(X, Y, mdl);

fprintf('Press enter to continue\n')
pause

% Extract coefficients data
coef = cell2mat(table2cell(mdl.Coefficients));

% Calculate confidence interval for each features and print features ...
% that contain 0
calculateCI(coef, n)

fprintf('Press enter to continue\n')
pause

% Eliminate feature
fprintf('\nUpdating data...\n')
X(:, 6) = [];
X_test(:, 6) = [];

% Calculate CI once more to check
[m,n] = size(X);
mdl = fitlm(X, Y);
coef = cell2mat(table2cell(mdl.Coefficients));
calculateCI(coef, n)

fprintf('Press enter to continue\n')
pause

% Run backward step selection again
[X, mdl] = backwardStepSel(X, Y, mdl);

fprintf('Press enter to continue\n')
pause

% Plot residuals to further anaylze features
fprintf('\nPlotting residuals...\n')

figure
plotResiduals(mdl, 'fitted')
title('Residual plot for entire data')

fprintf('Press enter to continue\n')
pause
close

fprintf('\nPlotting individual residual plots...\n')
figure
for i = 1:n
    indiv_mdl = fitlm(X(:, i), Y);
    subplot(3,3,i)
    plotResiduals(indiv_mdl)
    title(sprintf('Feature %d',i)) 
end

fprintf('Press enter to continue\n')
pause
close

% Display linear regression model to check p-values and adjusted R-squared
fprintf('\nDisplaying linear regression model...\n')
mdl
plot(mdl)

fprintf('\nPress enter to continue\n')
pause
close

% Run Lasso Shrinkage model on the entire data after correlation has ...
% been removed
fprintf('\nRunning lasso shrinkage model...\n')
[B, FitInfo] = lasso(X_lasso, Y, 'CV', 10);
lassoPlot(B, FitInfo, 'PlotType', 'Lambda', 'XScale', 'log')

% Return Mean Squared Error
lam = FitInfo.IndexMinMSE;
fprintf('The RMSE produced by Lasso Shrinkage Model is:\n %f\n', ...
    sqrt(FitInfo.MSE(lam)))

fprintf('Press enter to continue\n')
pause
close

% Initialize value
fprintf('\nTesting model with test data...\n')
[m,n] = size(X_test);
mdl = fitlm(X, Y);
Y_hat = zeros(num_test, 1);
coef = cell2mat(table2cell(mdl.Coefficients));

% Compute Y_hat with test data
for s = 1:m
    Y_hat(s) = coef(1,1);
    for t = 1:n
        Y_hat(s) = Y_hat(s) + X_test(s,t)*coef(t+1,1);
    end
end

% Compute MSE of Y_test and Y_hat
err = immse(Y_hat, Y_test);
fprintf('The RMSE produced from Test Data is:\n %f\n', sqrt(err))
fprintf('Press enter to continue\n')
pause

% Test using average climate data of Los Angeles
%   Data taken from:
%   http://www.holiday-weather.com/los_angeles/averages/
%   https://weatherspark.com/y/1705/Average-Weather-in-Los-Angeles-California-United-States-Year-Round
%   https://weather-and-climate.com/average-monthly-Humidity-perc,Los-Angeles,United-States-of-America
fprintf('\nImporting Los Angeles data...\n')
raw_data_la = importdata('ladata.xlsx');
X_la = raw_data_la.data;
X_la(:, 2) = X_la(:, 2) - 1;
[c,d] = size(X_la);

Y_hat_la = zeros(c, 1);

% Compute Y_hat_la with LA data
for w = 1:c
    Y_hat_la(w) = coef(1,1);
    for z = 1:d
        Y_hat_la(w) = Y_hat_la(w) + X_la(w,z)*coef(z+1,1);
    end
end

[m,n] = size(X);
sum_jan = 0;
jan = 0;
sum_feb = 0;
feb = 0;
sum_mar = 0;
mar = 0;
sum_apr = 0;
apr = 0;
sum_may = 0;
may = 0;
sum_jun = 0;
jun = 0;
sum_jul = 0;
jul = 0;
sum_aug = 0;
aug = 0;
sum_sep = 0;
sep = 0;
sum_oct = 0;
oct = 0;
sum_nov = 0;
nov = 0;
sum_dec = 0;
dec = 0;

for i = 1:m
    if X(i,3) == 1
        sum_jan = sum_jan + Y(i);
        jan = jan + 1;
    elseif X(i,3) == 2
        sum_feb = sum_feb + Y(i);
        feb = feb + 1;
    elseif X(i,3) == 3
        sum_mar = sum_mar + Y(i);
        mar = mar + 1;
    elseif X(i,3) == 4
        sum_apr = sum_apr + Y(i);
        apr = apr + 1;
    elseif X(i,3) == 5
        sum_may = sum_may + Y(i);
        may = may + 1;
    elseif X(i,3) == 6
        sum_jun = sum_jun + Y(i);
        jun = jun + 1;
    elseif X(i,3) == 7
        sum_jul = sum_jul + Y(i);
        jul = jul + 1;
    elseif X(i,3) == 8
        sum_aug = sum_aug + Y(i);
        aug = aug + 1;
    elseif X(i,3) == 9
        sum_sep = sum_sep + Y(i);
        sep = sep + 1;
    elseif X(i,3) == 10
        sum_oct = sum_oct + Y(i);
        oct = oct + 1;
    elseif X(i,3) == 11
        sum_nov = sum_nov + Y(i);
        nov = nov + 1;
    elseif X(i,3) == 12
        sum_dec = sum_dec + Y(i);
        dec = dec + 1;
    end
end

fprintf('The average number of users in Janurary for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(1:14))/14, sum_jan/jan)
fprintf('The average number of users in February for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(15:28))/14, sum_feb/feb)
fprintf('The average number of users in March for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(29:42))/14, sum_mar/mar)
fprintf('The average number of users in April for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(43:56))/14, sum_apr/apr)
fprintf('The average number of users in May for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(57:70))/14, sum_may/may)
fprintf('The average number of users in June for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(71:84))/14, sum_jun/jun)
fprintf('The average number of users in July for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(85:98))/14, sum_jul/jul)
fprintf('The average number of users in August for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(99:112))/14, sum_aug/aug)
fprintf('The average number of users in September for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(113:126))/14, sum_sep/sep)
fprintf('The average number of users in October for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(127:140))/14, sum_oct/oct)
fprintf('The average number of users in November for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(141:154))/14, sum_nov/nov)
fprintf('The average number of users in December for Los Angeles is: %f vs. %f\n', sum(Y_hat_la(155:168))/14, sum_dec/dec)




% End project
fprintf('\nProject is done\n')







