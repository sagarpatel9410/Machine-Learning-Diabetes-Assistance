clear
load algebra.mat

rng(0)

%Popularity 
num_users = size(utility,1);
num_topics = size(utility,2);

cross = num_users; %Perfroming K fold cross validation

%Shuffle the data
idx_k = randperm(num_users);
fileID = fopen('results_algebra_pop.txt','w');
%biased task.
for kcross = 1:cross
    
    test_user = utility(idx_k(kcross),:);
    train_data_set = utility;
    train_attempts = attempts;
    
    %remove the test user from train data
    train_data_set(idx_k(kcross),:) = [];
    train_attempts(idx_k(kcross),:) = [];
    
    %Build popular list of questions
    questions_order = sum(train_attempts);
    
    max_num_questions = size(train_attempts,2);
    
    for qs = 1: max_num_questions
        new_user_p = zeros(size(train_attempts,2),1);
        questions = questions_order;
        
        %ask qs questions
        for j = 1:qs
            [~,topic] = max(questions);
            questions(topic) = -Inf;
            user_result = test_user(topic) >= (rand());
            new_user_p(topic,1) = user_result;
        end
        
        

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
        fprintf(fileID,'%d, %d, %f \n', kcross, qs, error);
    end
    kcross
end
