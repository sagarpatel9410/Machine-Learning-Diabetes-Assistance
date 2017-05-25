clear
rng('default');

% %Want to manipulate the algebra_utilityset to take into account only the last
% %seen rating for a student to model no context aware case.
% 
%load('algebra_dataset_none_context.mat');
% unique_user_task = unique(utilityset(:,[1,2]), 'rows');
% 
% attempts = zeros(length(unique(utilityset(:,1))),length(unique(utilityset(:,2))));
% utility = zeros(length(unique(utilityset(:,1))),length(unique(utilityset(:,2))));
% 
% for i = 1:length(unique_user_task(:,1))
%     
%     values = utilityset(ismember(utilityset(:,[1,2]), unique_user_task(i,:),'rows'), :);
%     [~,id] = max(values(:,3));
%     
%     attempts(values(id,1),values(id,2)) = 1;
%     utility(values(id,1),values(id,2)) = values(id,4);
%     i
% end


%Prefiltering context aware system.
load algebra_dataset.mat
attempts = sum(attempts,3);
utility = sum(utility,3)./attempts;
utility(isnan(utility)) = 0 ;
attempts = attempts >= 1;

[user, items] = find(attempts);

%Matrix factorization using gradient descent algorithm.
%Latent Factors
K = 10;
P = rand(size(utility,1),K);
Q = rand(size(utility,2),K);
gamma = 0.0002;
lambda = 0.02;
epochs = 400;

train_error = zeros(epochs,1);

mu = sum(sum(utility))/length(attempts(attempts>0));

for s = 1:size(utility,1)
   ratings_s = utility(s,:) - mu ;
   ratings_s = attempts(s,:).*ratings_s;
   student_bias(s) = sum(ratings_s)/sum(attempts(s,:));
end

for t = 1:size(utility,2)
    ratings_t = utility(:,t) - mu ;
    ratings_t = attempts(:,t).*ratings_t;
    task_bias(t) = sum(ratings_t)/sum(attempts(:,t));
end


for step = 1:epochs
    tic
    for i = 1:length(user)
        predicted =  mu + student_bias(user(i)) + task_bias(items(i)) + P(user(i), :)*Q(items(i),:)';
        err = utility(user(i), items(i)) - predicted;
        
        mu = mu + gamma*err;
        student_bias(user(i)) = student_bias(user(i)) + gamma *(err - lambda*student_bias(user(i)));
        task_bias(items(i)) = task_bias(items(i)) + gamma * (err - lambda*task_bias(items(i)));
        
        P(user(i), :) = P(user(i), :) + gamma * (err * Q(items(i),:) - lambda * P(user(i),:));
        Q(items(i), :) = Q(items(i), :) + gamma * (err * P(user(i),:)- lambda * Q(items(i),:));
    end
    toc
    fprintf('Finished iteration');
    step
    fprintf('\n');
    for i = 1:length(user)
        
        predicted =  mu + student_bias(user(i)) + task_bias(items(i)) + P(user(i), :)*Q(items(i),:)';
        e(i) = (utility(user(i),items(i)) - predicted)^2;
        
    end
    mean(e)
    train_error(step) = mean(e);
end


