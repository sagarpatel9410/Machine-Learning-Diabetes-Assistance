function [ coef ] = LogisticRegression( timeseriesData )
%Input: Timeseries data is in the form [performance ; time(day)]
%Output: Determines Coefficients for a users timeseries data for logistic
%regression
%Determine Maximum Lag Terms
max_lag = 0;
    
X = lagmatrix(timeseriesData(:,1),[0:max_lag]); % Create the lagged matrix.
X(:,end+1) = timeseriesData(:,2);
%Set outputs
Y = X(:,1);
X(:,1) = [];
%Remove these values as we cannot predict before a max lag
X(1:max_lag,:) = [];
Y(1:max_lag,:) = [];

coef = zeros(size(X,2)+1,1);
learningrate = 0.0001;
for epoch = 1:2000
    for row = 1:size(X,1)
        datarow = X(row,:);
        Yrow = Y(row,:);
        
        Yhat = coef(1);
        for i = 2:length(coef)
            Yhat = Yhat + coef(i)* datarow(i-1);
        end
        
        Yhat = 1/(1 + exp(-Yhat));
        error = (Yrow - Yhat);
        sum_error(row) = error^2;
        
        coef(1) = coef(1) + learningrate * error * Yhat * (1-Yhat);
        for i = 2:length(coef)
            coef(i) = coef(i) + learningrate * error * Yhat * (1 - Yhat) * datarow(i-1);
        end
    end
end

end

