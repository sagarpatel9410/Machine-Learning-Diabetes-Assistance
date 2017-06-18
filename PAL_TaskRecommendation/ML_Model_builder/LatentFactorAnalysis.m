function [ P,Q, mu,student_bias,task_bias ] = LatentFactorAnalysis( topic)
%Load the data corresponding to the topic.
load studentQuestionModelSingleTopic.mat

idx = find(attempts);
%Matrix factorization using gradient descent algorithm.
%Latent Factors
NumberOfLatentFactors = 50;

%Initialise factor matrics
P = rand(size(utility,1),NumberOfLatentFactors);
Q = rand(size(utility,2),NumberOfLatentFactors);

gamma = 0.0002;
lambda = 0.02;
epochs = 400;

%Calculate global average
mu = sum(sum(utility))/length(attempts(attempts>0));

%Calculate Student and Question Bias
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

%Find all the users who have completed a task
[user, items] = find(attempts);
train_error = zeros(epochs,1);

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
train_error(step)

end