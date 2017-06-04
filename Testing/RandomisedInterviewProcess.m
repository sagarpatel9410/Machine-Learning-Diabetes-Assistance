clear
load algebra.mat

%Randomised Interview Process
fileID = fopen('results_algebra_pop.txt','w');
max_num_q = 138;
for seed = 1:10
    rng(seed-1);
    
    num_users = size(utility,1);
    num_topics = size(utility,2);

    cross = num_users; %Perfroming K fold cross validation

    %Shuffle the data
    idx_k = randperm(num_users);

    for kcross = 1:cross

        test_user = utility(idx_k(kcross),:);
        train_data_set = utility;
        train_attempts = attempts;

        %remove the test user from train data
        train_data_set(idx_k(kcross),:) = [];
        train_attempts(idx_k(kcross),:) = [];

        for nqs = 1:max_num_q
            new_user_p = zeros(size(train_attempts,2),1);
            new_user_asked = zeros(size(train_attempts,2),1);
            for j = 1:nqs
                topic = randi(num_topics);
                user_result = test_user(topic) >= (rand());
                new_user_p(topic,1) = user_result;
                new_user_asked(topic,1) = new_user_asked(topic,1) + 1;
            end

            new_user_p = new_user_p./new_user_asked;
            new_user_p(isnan(new_user_p)) = 0 ;
            userSimilarity = corr(new_user_p, train_data_set');
            if isnan(userSimilarity)
                [r,~] = size(userSimilarity');
                userSimilarity = ones(r,1);
                predictedProfile = (train_data_set' * userSimilarity)/sum(abs(userSimilarity));
            else
                userSimilarityNorm = normc(userSimilarity');
                threshold = max(userSimilarityNorm) * 0.8;     
                userNeighbourHood = train_data_set(userSimilarityNorm >= threshold,:);
                userSimilarity = userSimilarity(1,userSimilarityNorm >= threshold);

                predictedProfile = (userNeighbourHood' * userSimilarity')/sum(abs(userSimilarity));
            end

            error = immse(predictedProfile',test_user);
            fprintf(fileID,'%d, %d, %d, %f \n', seed,kcross, nqs, error);
        end
        kcross
    end
    seed
end