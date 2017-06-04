clear
load results_algebra_pop.mat
uniqueQ = unique(resultsalgebrapop(:,2));

for i = 1:length(uniqueQ)
    res = find(resultsalgebrapop(:,2) == uniqueQ(i));
    error(i) = mean(resultsalgebrapop(res,3));
    
end

rmse = sqrt(error);
