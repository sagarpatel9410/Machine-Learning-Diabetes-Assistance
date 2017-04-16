%Test Adaptive DT on real dataset
clear
rng('default');
load('realUserData.dat');
newUser = realUserData(11,:);
realUserData(11,:) = [];

realUserData = round(realUserData .* 100);
newUser = round(newUser .* 100);

param.depth = 5;        % tree max depth
param.treeNum = 5;
param.a = 10;
param.successThreshold = floor(mean(mean(realUserData)));
% Build decision tree
tree = growTrees(realUserData,param);

[user_neighbourhood, profile_predicted] = testTree(tree,newUser,param);

user_predicted = predictProfile( user_neighbourhood, profile_predicted, realUserData );

error = immse(user_predicted/100, (newUser/100)');

plot(user_predicted)
hold on
plot(newUser)
