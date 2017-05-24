clear
load algebra_dataset.mat

% users = length(unique(dataset(:,1)));
% questions = length(unique(dataset(:,2)));
% mxtime = max(dataset(:,3));
% 
% utility = zeros(users,questions,mxtime);
% attempts = zeros(users,questions,mxtime);
% 
% for i = 1:size(dataset,1)
%     
%     utility(dataset(i,1), dataset(i,2), dataset(i,3)) = dataset(i,4);
%     attempts(dataset(i,1), dataset(i,2), dataset(i,3)) = 1;
% 
% end

[user,items,time] = ind2sub(size(attempts),find(attempts));

%Latent Factors
K = 10;
P = rand(size(utility,1),K);
H = rand(size(utility,2),K);
Q = rand(size(utility,3),K);

mu = sum(dataset(:,4))/length(dataset);

for s = 1:size(utility,1)
   ratings_s = dataset(dataset(:,1) == s,4) - mu ;
   student_bias(s) = sum(ratings_s)/length(ratings_s);
end

for t = 1:size(utility,2)
    ratings_t = dataset(dataset(:,2) == t,4) - mu ;
    task_bias(t) = sum(ratings_t)/length(ratings_t);
end

gamma = 0.0002;
lambda = 0.02;
epochs = 400;

train_error = zeros(epochs,1);

for step = 1:epochs
    tic
    
    for i = 1:length(user)

        predicted = mu + student_bias(user(i)) + task_bias(items(i)) + sum(P(user(i),:).*H(items(i),:).*Q(time(i),:));
        err = utility(user(i),items(i),time(i)) - predicted;
        
        mu = mu + gamma*err;
        student_bias(user(i)) = student_bias(user(i)) + gamma *(err - lambda*student_bias(user(i)));
        task_bias(items(i)) = task_bias(items(i)) + gamma * (err - lambda*task_bias(items(i)));
        
        P(user(i), :) = P(user(i), :) + gamma * (2*err*H(items(i),:).*Q(time(i),:) - lambda * P(user(i),:));
        H(items(i), :) = H(items(i), :) + gamma * (2*err * P(user(i),:).*Q(time(i),:) - lambda * H(items(i),:));
        Q(time(i),:) = Q(time(i),:) + gamma * (2*err*P(user(i),:).*H(items(i),:) - lambda * Q(time(i),:));
        
    end    
    fprintf('Finished iteration');
    step

    fprintf('\n');
    
    for i = 1:length(user)
        
        predicted = mu + student_bias(user(i)) + task_bias(items(i)) + sum(P(user(i),:).*H(items(i),:).*Q(time(i),:));
        e(i) = (utility(user(i),items(i),time(i)) - predicted)^2;
        
    end
    mean(e)
    train_error(step) = mean(e);
    toc
end
