clear
%Generating the data set & simulate random user
Noise = 0.1; Topics = 35; Base_user = 10; Sparsity = 0; Max_user = 20;
[user_data_set, new_user] = generating_data_set(Base_user,Topics,Sparsity,Max_user,Noise);
%--------------------------------------------------------------------------
%determine clusters

[idx,centroids, kcluster_size] = clustering_users(25,user_data_set);

%--------------------------------------------------------------------------

%Calculate IG of each topic
[users ,~] = size(idx);

k = (1:kcluster_size)';
user_map = (1:users)';
IG = calculate_information_gain(k,idx, user_data_set,user_map,kcluster_size);

%--------------------------------------------------------------------------

%Non-personalised
[new_user_profile, questions_asked] = non_personalised(15,IG,new_user);

%--------------------------------------------------------------------------

%Personalised Step

loop_cond = false;
l = 3;
previous_user_neighbours = zeros(l,2);
while ~loop_cond
    %find best L neighbours 
    best_n = best_neighbours(centroids,new_user_profile,0);
    best_n_pruned = best_n(best_n(:,1) >= 0, :);
    neighbours = best_n_pruned(1:l,:);
    
    if previous_user_neighbours(:,2) == neighbours(:,2)
            loop_cond = true;
    end
    
    previous_user_neighbours = neighbours;
    
    if(~loop_cond)
        %calculate information gain using data from best_neighbours
        k = zeros(l,1);
        user_map = 0;
        for i = 1:l
            k(i,1) = neighbours(i,2);
            for j = 1:users
                if(idx(j,1) == neighbours(i,2))
                    user_map = [user_map ; j];
                end
            end 
        end
        user_map(1,:) = [];
        IG = calculate_information_gain(k,idx, user_data_set,user_map,kcluster_size);

        %ask next question on IG list
        for i = 1:5
            new_user_profile(IG(i,2),2) = new_user_profile(IG(i,2),2) + 1;
            new_user_profile(IG(i,2),1) =(new_user_profile(IG(i,2),1) + blackbox(new_user,IG(i,2)))/ new_user_profile(IG(i,2),2);
            questions_asked = questions_asked + 1;
        end

    end
end

[r,~] = size(neighbours);
user_neighbourhood = zeros(1,Topics);

for i = 1:r
    for j = 1:users
       if(idx(j,1) == neighbours(i,2))
           user_neighbourhood = [user_neighbourhood ; user_data_set(:,j)'];
       end
    end
end

%%%to do take the best users from the clusters determine a function that
%%%can best do this.

user_neighbourhood(1,:) = [];
new_user_profile = predict_profile(new_user_profile(:,1), user_neighbourhood);
error = immse(new_user_profile, new_user');

hold off
figure
plot(new_user)
hold on
plot(new_user_profile)
