clear
load results_adt.mat

uniqueQ = unique(resultsadt(:,5));

for i = 1:length(uniqueQ)
    
    res = find(resultsadt(:,5) == uniqueQ(i,1));
    error(i) = mean(resultsadt(res,6));
    
end

rmse_adt = sqrt(error);
plot(rmse_adt);

%Decision trees
necessaryidx = find(resultsadt(:,4) == 1);
uniqueQ = unique(resultsadt(necessaryidx,5));

for i = 1:length(uniqueQ)
    
    res = find(resultsadt(necessaryidx,5) == uniqueQ(i,1));
    error_dt(i) = mean(resultsadt(res,6));
    
end

rmse_dt = sqrt(error_dt);
