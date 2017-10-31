function calculateCI(coef, n)
%CALCULATECI calculates the confidence interval

bool = false;

fprintf('\nCalculating confidence intervals...\n')
for i = 1:n
    ci = [coef(i+1,1) - 2*coef(i+1,2), coef(i+1,1) + 2*coef(i+1,2)];
    if ci(1) < 0 && 0 < ci(2)
        fprintf('Feature %d contains 0:\n [%f, %f]\n', i, ci(1), ci(2))
        bool = true;
    end
end

if bool == false
    fprintf('No CI contains 0\n')
end


end

