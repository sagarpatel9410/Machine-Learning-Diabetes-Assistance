function new_user = simulate_new_user(user_data_set, Noise)

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
