clear
rng(0);
%values to alternate:
% dimension = 35;
% clusterSize = 10;
% nonPersonalisedQuestions = 15;
% BestLNeighbours = 3;
% PersonalisedQuestions = 5;
% 
% %Generating the data set & simulate random user
% [user_data_set, new_user] = GenerateData(10,35,0,10,0.1);


%Load algebra dataset
load algebra.mat
utility = utility';

%kfold cross val
num_users = size(utility,2);
num_topics = size(utility,1);

cross = num_users; %Perfroming K fold cross validation

%Shuffle the data
idx_k = randperm(num_users);
max_number_q = 40;
nonPersonalisedQ = 20;
%Testing Kfold Cross validation
fileID = fopen('results','w');
parfor kcross = 1:cross
    
    new_user = utility(:,idx_k(kcross));
    user_data_set = utility;
    
    %remove the test user from train data
    user_data_set(:,idx_k(kcross)) = [];
    temp = num2str(kcross);
    
    
    %Determine clusters
    clusterSize = 163
    [idx,C] = kmeans(user_data_set',clusterSize,'Replicates',10);
    %----------------------IGCN-----------------------%
    %Calculate IG of each topic based on all users
    [topics_ordered, IG] = InformationGain(idx, clusterSize, user_data_set, 0.05);
    for mxq = 1:max_number_q
        for npq = 1:nonPersonalisedQ
            if npq > mxq
                break;
            end
            pq = abs(npq - mxq);

            newUserPredictedNP = NonPersonalisedIGCN(topics_ordered, new_user, npq, zeros(size(utility,1),2));

            for BestLNeighbours = 1:10
                if (BestLNeighbours > clusterSize)
                    break;
                end
                %Personalised Step
                [bestNeighbours, newUserPredicted] = PersonalisedIGCN(BestLNeighbours, newUserPredictedNP, idx, user_data_set, C, pq, new_user,clusterSize);
                userNeighbourHood = user_data_set(:,ismember(idx, bestNeighbours));
                questionsAsked = sum(newUserPredicted(:,2));
                newUserPredicted = PredictProfile( newUserPredicted(:,1), userNeighbourHood, 0.8);
                error = immse(newUserPredicted(:,1), new_user);

                fprintf(fileID,'%d, %d, %d, %d, %d, %d, %d, %f \n', kcross, clusterSize, npq, pq, questionsAsked,BestLNeighbours,error);

            end  
        end
        mxq
    end   
    kcross
end

%--------------------------------------------------------------------------
% SVD Smoothing
%user_data_set = SmoothingSVD(user_data_set, dimension);

%--------------------------------------------------------------------------
%Determine clusters
% [idx, C] = ClusterUsers(clusterSize,user_data_set);

%----------------------IGCN-----------------------%
%Calculate IG of each topic based on all users
% [topics_ordered, IG] = InformationGain(idx, clusterSize, user_data_set, 0.05);

%Non Personalised
% newUserPredicted = NonPersonalisedIGCN(topics_ordered, new_user, nonPersonalisedQuestions, zeros(35,2));

%--------------------------------------------------------------------------
%Personalised Step
% [bestNeighbours, newUserPredicted] = PersonalisedIGCN(BestLNeighbours, newUserPredicted, idx, user_data_set, C, PersonalisedQuestions, new_user);
% 
% userNeighbourHood = user_data_set(:,ismember(idx, bestNeighbours));
% 
% questionsAsked = sum(newUserPredicted(:,2));
% newUserPredicted = PredictProfile( newUserPredicted(:,1), userNeighbourHood, 0.8);
% error = immse(newUserPredicted(:,1), new_user);

% hold off
% 
% plot(new_user)
% hold on
% plot(newUserPredicted)


