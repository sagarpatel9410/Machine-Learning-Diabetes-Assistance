clear
rng(0);
%values to alternate:
dimension = 35;
clusterSize = 10;
nonPersonalisedQuestions = 15;
BestLNeighbours = 3;
PersonalisedQuestions = 5;

%Generating the data set & simulate random user
[user_data_set, new_user] = GenerateData(10,35,0,10,0.1);

%--------------------------------------------------------------------------
% SVD Smoothing
%user_data_set = SmoothingSVD(user_data_set, dimension);

%--------------------------------------------------------------------------
%Determine clusters
[idx, C] = ClusterUsers(clusterSize,user_data_set);

%----------------------IGCN-----------------------%
%Calculate IG of each topic based on all users
[topics_ordered, IG] = InformationGain(idx, clusterSize, user_data_set, 0.05);

%Non Personalised
newUserPredicted = NonPersonalisedIGCN(topics_ordered, new_user, nonPersonalisedQuestions, zeros(35,2));

%--------------------------------------------------------------------------
%Personalised Step
[bestNeighbours, newUserPredicted] = PersonalisedIGCN(BestLNeighbours, newUserPredicted, idx, user_data_set, C, PersonalisedQuestions, new_user);

userNeighbourHood = user_data_set(:,ismember(idx, bestNeighbours));

questionsAsked = sum(newUserPredicted(:,2));
newUserPredicted = PredictProfile( newUserPredicted(:,1), userNeighbourHood, 0.8);
error = immse(newUserPredicted(:,1), new_user);

hold off

plot(new_user)
hold on
plot(newUserPredicted)


