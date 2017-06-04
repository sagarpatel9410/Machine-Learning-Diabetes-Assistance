%Testing IGCN no SVD on actual data.

clear
load realUserData.mat


%----------------------IGCN-----------------------%

fileID = fopen('results_15.txt','w');
for seed = 1:100
    rng(seed-1);
    num_users = size(realUserData,1);
    num_topics = size(realUserData,2);

    cross = num_users; %Perfroming K fold cross validation

    %Shuffle the data
    idx_k = randperm(num_users);
for kfold = 1:cross

    test_user = realUserData(idx_k(kfold),:)';
    train_data_set = realUserData';
    %remove the test user from train data
    train_data_set(:,idx_k(kfold)) = [];

    %cluster users in train set - find optimal
    clust = zeros(size(train_data_set',1),size(train_data_set',1));
    for i=1:size(train_data_set',1)
        clust(:,i) = kmeans(train_data_set',i,'emptyaction','singleton','replicate',5);
    end
    va = evalclusters(train_data_set',clust,'CalinskiHarabasz');
    %plot(va);

    cluster_size = va.OptimalK;
    clear clust cross i num_users va

    [idx, C] = kmeans(train_data_set',cluster_size,'emptyaction','singleton','replicate',5);

    %Calculate IG of each topic based on all users
    [topics_ordered, IG] = InformationGain(idx, cluster_size, train_data_set, 0.05);

    mnpq = 9;
    mpq = 9;
    for nonPersonalisedQuestions = 1: mnpq
        %Non Personalised
        newUserPredicted = NonPersonalisedIGCN(topics_ordered, test_user, nonPersonalisedQuestions, zeros(9,2));

        %--------------------------------------------------------------------------
        %Personalised Step
        for BestLNeighbours = 1:cluster_size
            for PersonalisedQuestions = 1:mpq
                [bestNeighbours, newUserPredictedP] = PersonalisedIGCN(BestLNeighbours, newUserPredicted, idx, train_data_set, C, PersonalisedQuestions, test_user, cluster_size);

                userNeighbourHood = train_data_set(:,ismember(idx, bestNeighbours));
                questionsAsked = sum(newUserPredictedP(:,2));
                newUserPredictedP = PredictProfile( newUserPredictedP(:,1), userNeighbourHood, 1);
                error = immse(newUserPredictedP(:,1), test_user);

                fprintf(fileID,'%d, %d, %d, %d, %d, %d, %f, \n', seed, kfold, nonPersonalisedQuestions, PersonalisedQuestions, BestLNeighbours, questionsAsked, error);

                clear  bestNeighbours userNeighbourHood newUserPredictedP
            end
        end
    end
    kfold
end
seed
end
fclose(fileID);

