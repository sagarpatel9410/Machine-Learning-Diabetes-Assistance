clear
load algebra_dataset.mat
% 
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