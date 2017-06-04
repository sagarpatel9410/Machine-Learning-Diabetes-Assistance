clear
% [ratingsMatrix, newUser] =  GenerateData(20,35,0,20,0.1);
% ratingsMatrix = round(ratingsMatrix' .* 100);
load algebra.mat
data = round(utility.*100);

max_tree_depth = 10;
max_tree_num = 10;
fileID = fopen('results_adt.txt','w');

for seed = 1:20
    
    rng(seed-1);
    num_users = size(data,1);
    num_topics = size(data,2);
    
    cross = num_users; %Perfroming K fold cross validation

    %Shuffle the data
    idx_k = randperm(num_users);
    
for kcross = 1:cross
    newUser = data(idx_k(kcross),:);
    ratingsMatrix = data;
    %remove the test user from train data
    ratingsMatrix(idx_k(kcross),:) = [];

for dp = 2:max_tree_depth
    for tn = 1:max_tree_num
        % Tree Parameters.
        param.depth = dp;        % tree max depth
        param.treeNum = tn;
        param.a = 10;
        param.successThreshold = 50;

        % Build decision tree
        tree = growTrees(ratingsMatrix,param);

        %Testing on new user
        %Adjust User Profile

        [user_neighbourhood, profile_predicted,questionasked] = testTree(tree,newUser,param);

        user_predicted = predictProfile( user_neighbourhood, profile_predicted, ratingsMatrix );

        error = immse(user_predicted/100, (newUser/100)');
        fprintf(fileID,'%d, %d, %d, %d, %d, %f, \n', seed, kcross, dp, tn, questionasked, error);
        clear user_neighbourhood
    end
end
end
end
% 
% plot(user_predicted)
% hold on
% plot(newUser)
% 
