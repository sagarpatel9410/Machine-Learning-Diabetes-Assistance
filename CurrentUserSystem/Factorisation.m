% %Manipulate the dataset to desired form.
% load dataset.csv
% 
% A = dataset(dataset(:,6) == 1, :);
% B = unique(A(:,2:4),'rows');
% D = B(:,1).* B(:,2).* B(:,3);
% C = unique(A(:,1));
% for i = 1: size(A,1)
%     %Determine unique id for problem col 2 + 3 + 4
%        A(i, 8) = find(A(i,2).* A(i,3).* A(i,4) == D);
%        A(i, 7) = find(A(i,1) == C);
% end
% 
% utility_matrix = zeros(max(A(:,7)), max(A(:,8)));
% attemptsidx = zeros(max(A(:,7)), max(A(:,8)));
% 
% for i = 1: size(A,1)
%     utility_matrix(A(i,7), A(i,8)) = A(i,5);
%     attemptsidx(A(i,7), A(i,8)) = 1;
% end

clear
rng('default');
load('data.mat'); %variable is attempts and data

data = full(data);
attempts = full(attempts);
[user, items] = find(attempts);

%Matrix factorization using gradient descent algorithm.
%Latent Factors
K = 25;
P = random('Normal',0,0.01,size(data,1),K);
Q = random('Normal',0,0.01,size(data,2),K);
gamma = 0.0002;
lambda = 0.02;
epochs = 400;

train_error = zeros(epochs,1);


for step = 1:epochs
    tic
    for i = 1:length(user)
        err = data(user(i), items(i)) - P(user(i), :)*Q(items(i),:)';
        P(user(i), :) = P(user(i), :) + gamma * (err * Q(items(i),:) - lambda * P(user(i),:));
        Q(items(i), :) = Q(items(i), :) + gamma * (err * P(user(i),:)- lambda * Q(items(i),:));
    end
    toc
    fprintf('Finished iteration');
    step
    fprintf('\n');
    train_error(step) = my_mse(attempts,data,Q,P);
end

