clear
rng(0);
load dataset_modified.mat
users = length(unique(dataset(:,1)));
tasks = length(unique(dataset(:,2)));
load bias.mat
%generate initial alpha value for each student
alpha = rand(users,1);
%Initial global mean
mu = mean(dataset(:,3));
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
delta = 0.5;
gamma = 0.0002;
for step = 1:100
    datareodered = randperm(size(dataset,1));
    for dp = 1:length(datareodered)
        %Wrap this in for loop going through all data in datareordered
        
        user = dataset(datareodered(dp),1);
        time = dataset(datareodered(dp),4);
        task = dataset(datareodered(dp), 2);
        p = dataset(datareodered(1),3);

        %Get past L values of this user
        pastvals = dataset(dataset(:,1) == user, 3);
        if time == 1
            break;
        elseif time <= L
            pastvals = pastvals(1: time - 1 );
        else
            pastvals = pastvals(time - L: time - 1 );
        end
       
        E_T_initial = pastvals(1);

         for t = 1:length(pastvals)-1
            if t == 1
                E_T(t) = alpha(user)*pastvals(t+1) + (1-alpha(user))*E_T_initial;
            else
                E_T(t) = alpha(user)*pastvals(t+1) + (1-alpha(user))*E_T(t-1);
            end 
        end
       
        p_bias = mu + student_bias(1,user) + task_bias(1,task);
        predicted = delta * p_bias + (1-delta)*E_T(end);
        
        error = p - predicted;
        
        
        student_bias(1,user) = student_bias(1,user) + gamma * error;
        task_bias(1,task) = task_bias(1,task) + gamma*error;

        sumterm = 0;
        for st = 1:length(pastvals)-1

            sumterm = sumterm + ((1-alpha(user))^(st-2)) * (1 - 2*alpha(user))*pastvals(end-st+1);

        end
        diffPred = -(length(pastvals)-1)*((1- alpha(user))^(length(pastvals)-2))*pastvals(1) + sumterm;
        term = -2 * (p - delta*p_bias - (1-delta)*predicted) * (1-delta)*diffPred;
        alpha(user) = alpha(user) - gamma * term;

        
    end
    
    %Calculate error
    

end
