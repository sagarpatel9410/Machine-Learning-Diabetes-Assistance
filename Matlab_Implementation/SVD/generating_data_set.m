%eg. generating_data_set(10, 35, 0, 25, 0.1)
function [sample_user_set, new_user,users_generated] =  generating_data_set(base_user,topics,sparsity,K,N)
%%%%%Generate a base set of users, all other users will be modelled of
%%%%%these users
A = rand(topics,base_user);
%%for each base set user generate max K users that are similar with Max Noise N
%%base value of K = 6
sample_user_set = [];
users_generated = zeros(1,base_user);
for i = 1:base_user
    %%determine how many sample users to generate for the current base user
    num_of_sample_user = randi([5,K]);
    users_generated(1,i) = num_of_sample_user;
    sample_user_set = [sample_user_set; A(:,i)'];
    for j = 1:num_of_sample_user
        new_user = A(:,i);
        %%for this new user add some noise to each field also make sure
        %%that the value in 0<= cell <=1
        for k = 1:topics
            %generate noise value in range {N,-N}
            noise = N - (2*N)*rand();
            new_user(k,1) = new_user(k,1) + noise;
            
            %check if value does not exceed range {0,1}
            if(new_user(k,1) > 1)
                new_user(k,1) = 1;
            end
            if(new_user(k,1) < 0)
                new_user(k,1) = 0;
            end
            
        end
        sample_user_set = [sample_user_set; new_user'];
    end
end

[row,col] = size(sample_user_set);

for i = 1:col
    for j = 1:row
        y = rand();
        if(y<=sparsity)
            sample_user_set(j,i) = 0;
        end
    end
end

sample_user_set = sample_user_set';

[~, users] = size(sample_user_set);
 
temp = randi([1 users],1,1);
new_user = sample_user_set(:,temp);

for i = 1:topics
    noise = N - (2*N)*rand();
    new_user(i,1) = new_user(i,1) + noise;

    %check if value does not exceed range {0,1}
    if(new_user(i,1) > 1)
        new_user(i,1) = 1;
    end
    if(new_user(i,1) < 0)
        new_user(i,1) = 0;
    end
end

end