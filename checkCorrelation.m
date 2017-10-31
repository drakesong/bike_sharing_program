function checkCorrelation(X)
%CHECKCORRELATION checks if there's any correlation bewteen the features 
%   in the given data

fprintf('\nPlotting correlation...\n')
figure
plotmatrix(X)
title('Determining correlation between features')

end

