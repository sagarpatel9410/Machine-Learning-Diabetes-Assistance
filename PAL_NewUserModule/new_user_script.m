%%This script details how a new user profile is bootstrapped in PAL.

%% Bootstrap a new user profile using IGCN

%Load all the required data to conduct the interview process.
load('Database\IGCN-Model-Params.mat');
load('Database\studentmodels.mat');
load('Database\new_user.mat');
utility = utility';

%For testing purposes a new user will be someone from within the existing
%data
new_user = new_user';

user_data_set = utility;

%Parameters
NPQ = 20;
PQ = 10;
L = 10;

%Conduct General Interview Process on this new user.
newUserPredictedNP = NonPersonalisedIGCN(topics, new_user, NPQ, zeros(size(utility,1),2));

%Conduct Personalised Interview Process on this new user.
[bestNeighbours, newUserPredicted] = PersonalisedIGCN(L, newUserPredictedNP, idx, user_data_set, C, PQ, new_user,N);

%Determine a new user neighbourhood
userNeighbourHood = user_data_set(:,ismember(idx, bestNeighbours));

%Determine the number of questions asked
questionsAsked = sum(newUserPredicted(:,2));

%Combine the new user initial profile and userNeighbourhood to form final
%prediction
newUserPredicted = PredictProfile( newUserPredicted(:,1), userNeighbourHood, 0.8);

%Determine the error between prediction
error = immse(newUserPredicted(:,1), new_user);

plot(new_user)
hold on
plot(newUserPredicted)

clear 

%% Bootstrapping using DT

load('Database\new_user.mat');
load('Database\studentmodels.mat');
load('Database\ABDT-Model-Params.mat');

%Tree Parameters
param.depth = 5;        % tree max depth
param.treeNum = 10;
param.a = 10;
param.successThreshold = 50;

[user_neighbourhood, profile_predicted,questionasked] = testTree(tree,new_user,param);

user_predicted = predictProfile( user_neighbourhood, profile_predicted, utility );

error = immse(user_predicted/100, (new_user/100)');

figure
plot(new_user/100)
hold on
plot(user_predicted/100)

