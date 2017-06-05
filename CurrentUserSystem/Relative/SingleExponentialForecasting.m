clear
rng(0);
load dataset_modified.mat
users = length(unique(dataset(:,1)));
tasks = length(unique(dataset(:,2)));

%generate initial alpha value for each student
alpha = abs(normrnd(0.2,0.1,users,1));
%Initial global mean
mu = mean(dataset(:,3));
load bias.mat
% Calculate student bias
% for s = 1:users
%     
%     ratings = dataset(dataset(:,1) == s,3);
%     student_bias(s) = mean(ratings - mu);
%     
% end
% % Calculate task bias
% for t = 1:tasks
%     ratings = dataset(dataset(:,2) == t,3);
%     task_bias(t) = mean(ratings - mu);
%     t
% end


L = 10;
delta = 0.3;
gamma = 0.002;
for step = 1:100
    tempL = L;
    disp('Training')
    tic
    datareodered = randperm(size(dataset,1));
    for dp = 1:length(datareodered)
        %Wrap this in for loop going through all data in datareordered
        
        user = dataset(datareodered(dp),1);
        time = dataset(datareodered(dp),4);
        task = dataset(datareodered(dp), 2);
        rating = dataset(datareodered(1),3);

        if time == 1 || time == 2
            continue;
        elseif time <= L
            L = time - 1;
        end
        
        E_T_initial = dataset(datareodered(dp) - L,3);
        clearvars E_T

        for t = 1:L-1
            if t == 1
               E_T(t) = (alpha(user) * dataset(datareodered(dp) - L + t,3)) + (1 - alpha(user))*E_T_initial;
            else
               E_T(t) = (alpha(user) * dataset(datareodered(dp) - L + t,3)) + (1 - alpha(user))*E_T(t-1);
            end
        end
               
        p_bias = mu + student_bias(1,user) + task_bias(1,task);
        predicted = delta * p_bias + (1-delta)*E_T(L-1);
        
        error = rating - predicted;
        
        
        student_bias(1,user) = student_bias(1,user) + gamma * error;
        task_bias(1,task) = task_bias(1,task) + gamma*error;

        sumterm = 0;
        
        for j = 1:L-1
            
            sumterm = sumterm + (1-alpha(user))^(j - 2) * (1 - 2*alpha(user)) * dataset(datareodered(dp) - j ,3);
            
        end
        
        diffterm = -(L - 1)*((1 - alpha(user))^(L - 2))*E_T_initial + sumterm;
        term = -2*(rating - delta*p_bias - (1-delta)*predicted)*(1-delta)*diffterm;
        alpha(user) = alpha(user) - gamma * term;
        
        L = tempL;

    end
       
    toc
    disp('Calculate Error')
    tic
    %Calculate error
    for item = 1:length(dataset)
        user = dataset(datareodered(item),1);
        task = dataset(datareodered(item),2);
        rating = dataset(datareodered(item),3);
        time = dataset(datareodered(item),4);

        if time == 1 || time == 2
            continue;
        elseif time <= L
            L = time - 1;
        end

        E_initial = dataset(datareodered(item) - L,3);
        clearvars E_T
        for t = 1:L-1
            if t == 1
               E_T(t) = (alpha(user) * dataset(datareodered(item) - L + t,3)) + (1 - alpha(user))*E_initial;
            else
               E_T(t) = (alpha(user) * dataset(datareodered(item) - L + t,3)) + (1 - alpha(user))*E_T(t-1);
            end
        end
        
        p_bias = mu + student_bias(1,user) + task_bias(1,task);
        predicted = delta * p_bias + (1-delta)*E_T(L-1);
        
        error(item) = (rating - predicted)^2;
        
        L = tempL;
    end
    
    step
    mean(error)
    mse(step) = mean(error);
    
end

clearvars -except alpha  dataset mu student_bias task_bias


