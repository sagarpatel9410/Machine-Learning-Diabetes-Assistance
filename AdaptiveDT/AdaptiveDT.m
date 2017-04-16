clear
rng('default')
[ratingsMatrix, newUser] =  GenerateData(20,35,0,20,0.1);
ratingsMatrix = round(ratingsMatrix' .* 100);

% Tree Parameters.
param.depth = 5;        % tree max depth
param.treeNum = 5;
param.a = 10;
param.successThreshold = 50;

% Build decision tree
tree = growTrees(ratingsMatrix,param);

%Testing on new user
%Adjust User Profile
newUser = round(newUser' .* 100);

[user_neighbourhood, profile_predicted] = testTree(tree,newUser,param);

user_predicted = predictProfile( user_neighbourhood, profile_predicted, ratingsMatrix );

error = immse(user_predicted/100, (newUser/100)');

plot(user_predicted)
hold on
plot(newUser)

