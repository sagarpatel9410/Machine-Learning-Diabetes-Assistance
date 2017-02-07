%generate data set - Noise ± 0.1 | Max User 20 | Sparsity 0 | Base User 10
Noise = 0.1;
Topics = 35;
user_data_set = generating_data_set(10,Topics,0,20,Noise);
%determine optimal number of clusters
plot(clustering_users(25,user_data_set))

%kcluster_size = input('Specify Cluster Size ');
kcluster_size = 10;

%cluster users using K means with k = optimal clusters 
[idx,centroids] = kmeans(user_data_set',kcluster_size,'Replicates',10);

%simulate random user
[~, users] = size(user_data_set);

temp = randi([1 users],1,1);
new_user = user_data_set(:,temp);

for i = 1:Topics
    noise = Noise - (2*Noise)*rand();
    new_user(i,1) = new_user(i,1) + noise;

    %check if value does not exceed range {0,1}
    if(new_user(i,1) > 1)
        new_user(i,1) = 1;
    end
    if(new_user(i,1) < 0)
        new_user(i,1) = 0;
    end
end

%Calculate IG of each topic
k = (1:kcluster_size)';
user_map = (1:users)';
IG = calculate_information_gain(k,idx, user_data_set,user_map,kcluster_size);
new_user_profile = zeros(35,2);

%Non-personalised
%Initial Profile Build ask 5 questions or until similarity between a
%cluster is greater than some threshold (Not implemented yet)
initial = 10;

for np = 1:initial 
    new_user_profile(IG(np,2),1) = new_user_profile(IG(np,2),1) + blackbox(new_user,IG(np,2));
    new_user_profile(IG(np,2),2) = new_user_profile(IG(np,2),2) + 1;
end

%Personalised Step

loop_cond = false;
l = 1;

previous_user_neighbours = zeros(l,2);
while ~loop_cond
    %find best L neighbours 
    neighbours = best_neighbours(centroids,new_user_profile,l);
    
    %check if neighbours are unchanged
    if(previous_user_neighbours(:,2) == neighbours(:,2))
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

        %ask top i question on IG list
        for i = 1:10
            new_user_profile(IG(i,2),2) = new_user_profile(IG(i,2),2) + 1;
            new_user_profile(IG(i,2),1) =(new_user_profile(IG(i,2),1) + blackbox(new_user,IG(i,2)))/ new_user_profile(IG(i,2),2);
        end
    end
end

new_user_profile = centroids(neighbours(1,2),:);



