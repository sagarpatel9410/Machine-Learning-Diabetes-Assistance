function [ userPredictedQuestionModel ] = NeighbourHoodModel(user,topic )
%NEIGHBOURHOODMODEL based collaborative filtering
%Load the question model associated with the topic.
load studentQuestionModelSingleTopic.mat
attempts = attempts >= 1;
userPredictedQuestionModel = zeros(size(utility,2),1);
%This determines the size of the user nieghbourhood.
alphaval = 0.7;
idx = find(attempts);

%Find all users that have rated items.
[users, items] = find(attempts);
%Load the profile of the user we want to predict
current_profile = attempts(user, :).*utility(user,:);
userPredictedQuestionModel = current_profile;
%Find all the task this user has done.
[~,itemsetCU] = find(attempts(user,:));
%Find this users average rating.
avgratingCU = mean(utility(user, itemsetCU));

userSet = unique(users);
%Remove this user from the current set of possible neighbours
userSet(userSet(:,1) == user) = [];

%Determine the user-neighbourhood
    for j = 1:length(userSet)
        sim = 0;
        [~,itemsetUser] = find(attempts(userSet(j),:));
        avgratingUser = mean(utility(userSet(j), itemsetUser));
        itemsetpair = intersect(itemsetCU,itemsetUser);
        top = 0;
        bottom = 0;
        for k = 1:length(itemsetpair)
            top = top + (utility(userSet(j), itemsetpair(k)) - avgratingUser)*(utility(user, itemsetpair(k))- avgratingCU);
            bottom = bottom + (utility(userSet(j), itemsetpair(k)) - avgratingUser)^2*(utility(user, itemsetpair(k))- avgratingCU)^2;
        end
        
        sim = top/sqrt(bottom);
        %Store similarity between current user and all other users
        similarity(j) = sim;
    end
    
    %Build neighbourhood using similarity scores
    alpha = alphaval/10;
    similarity(isnan(similarity)) = 0;
    threshold = alpha * max(similarity);
    
    N = utility(userSet(similarity > threshold),:);
    N_sim = similarity(similarity > threshold)';
    
    %Predict items that the user has not seen before
    itemspredict = find(attempts(user,:) == 0);
    
    %Predict performance for all items in items predicts
    for l = 1:length(itemspredict)
        top = 0;
        bottom = 0;
        for m = 1:size(N,1)
            top = top + N_sim(m) * N(m,itemspredict(l));
            bottom = bottom + abs(N_sim(m));
        end
        
        predict = top/bottom;
        userPredictedQuestionModel(1,itemspredict(l)) = predict;
    end
    
end


