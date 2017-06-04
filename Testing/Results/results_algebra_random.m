clear
load results_algebra_random.mat

uniqueQ = unique(resultsalgebrarandom(:,3));

for i = 1:length(uniqueQ)
    res = find(resultsalgebrarandom(:,3) == uniqueQ(i));
    error(i) = mean(resultsalgebrarandom(res,4));
    
end

rmse = sqrt(error);
