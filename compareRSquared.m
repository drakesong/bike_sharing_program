function [X, model, bool] = compareRSquared(X_new,model_new,X_base, ...
    model_base)
%COMPARERSQUARED compares the R-Squared of two given models and output the
% better model and dataset

if model_new.Rsquared.Adjusted > model_base.Rsquared.Adjusted
    X = X_new;
    model = model_new;
    bool = true;
else
    X = X_base;
    model = model_base;
    bool = false;
end

end

