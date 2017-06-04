clear
load algebra.mat

rng(0)

num_users = size(utility,1);
num_topics = size(utility,2);

cross = num_users; %Perfroming K fold cross validation

%Shuffle the data
idx_k = randperm(num_users);

%biased task.
for kcross = 1:cross
    
    test_user = utility(idx_k(kcross),:);
    train_data_set = utility;
    train_attempts = attempts;
    
   
    %remove the test user from train data
    train_data_set(idx_k(kcross),:) = [];
    train_attempts(idx_k(kcross),:) = [];
    
    profile_average_other = mean(train_data_set);
    error_other(kcross) = immse(profile_average_other,test_user);
    
end

rmse_biased = sqrt(mean(error_other));

clearvars -except rmse_biased utility num_users num_topics cross idx_k

%globalavg

for kcross = 1:cross
    
    test_user = utility(idx_k(kcross),:);
    train_data_set = utility;
    
   
    %remove the test user from train data
    train_data_set(idx_k(kcross),:) = [];
    
    mu = mean(mean(train_data_set));
    
    up = zeros(size(utility,2),1);
    
    for i = 1:size(utility,2)
         up(i) = mu;
    end
    error_other(kcross) = immse(up,test_user');
    
end

rmse_global = sqrt(mean(error_other));


