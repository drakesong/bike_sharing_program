function [X, mdl] = backwardStepSel(X, Y, mdl)
%BACKWARDSTEPSEL runs backward step selection method by comparing R-squared
%after removing one feature at a time

% Initialize values
updated = true;
X_init = X;
mdl_init = fitlm(X_init, Y);
list = [];
var = 0;
    
fprintf('\nRunning backward step selection...\n')

% Compare RSquared by removing one feature at a time
while updated
    [a,b] = size(X);
    updated = false;
    
    for j=1:b
        X_temp = X;
        X_temp(:, j) = [];
        mdl_temp = fitlm(X_temp, Y);
        [X_init, mdl_init, updated] = compareRSquared(X_temp, mdl_temp, X_init, mdl_init);
        if updated
            var = j;
        end
    end
    
    if ~updated
        break;
    else
        X = X_init;
        mdl = mdl_init;
        append(list, var);
    end
end

if isempty(list)
    fprintf('No features have been removed.\n')
else
    fprintf('The following feature(s) was removed:\n %d\n', list);
end

end

