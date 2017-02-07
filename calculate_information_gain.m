function ig = calculate_information_gain(k,idx, user_data_set)
%returns a column vector of information gain for each of the topics 

%---------------------------------------------------
%determine the entropy H(C)
%%determine C - distribution of users into classes
C = zeros(k,1);
[m,~] = size(idx);

for i = 1:m
    C(idx(i,1)) = C(idx(i,1)) + 1;
end
C = C/m;

H_C = 0; %H(C)
for i = 1:k
    H_C = H_C - (C(i,1)*log2(C(i,1)));
end

%---------------------------------------------------
[topics,num_user] = size(user_data_set);

%determine C^r_at - dist of users into classes that rated item a_t with r
quantise = 0.05;
C_r_at = zeros(1/quantise,k,topics);

for topic = 1:topics
     for user = 1:num_user
        quantised_rating = floor((user_data_set(topic,user)/quantise) + 1);
        if(quantised_rating == (1/quantise) + 1)
            quantised_rating = (user_data_set(topic,user)/quantise);
        end
        user_cluster_number = idx(user,1);
        C_r_at(quantised_rating, user_cluster_number,topic) = C_r_at(quantised_rating, user_cluster_number,topic) + 1;
     end
end

C_r_at = C_r_at/num_user;

%determine H(C^r_at) 

H_C_r_at = zeros(1/quantise,topics);

for topic = 1:topics
    for rating_quant = 1:(1/quantise)
        for cluster = 1:k
            if C_r_at(rating_quant,cluster,topic) ~= 0
                H_C_r_at(rating_quant,topic) = H_C_r_at(rating_quant,topic) - (C_r_at(rating_quant,cluster,topic) * log2(C_r_at(rating_quant,cluster,topic)));                
            end
        end
    end
end

%IG
IG = zeros(topics,2);

for topic = 1:topics
    temp = 0;
    for rating_quant = 1:(1/quantise)
       temp = temp + ((norm(C_r_at(rating_quant,:,topic)))/norm(C))*H_C_r_at(rating_quant,topic);
    end
    IG(topic,1) = H_C - temp;
    IG(topic,2) = topic;
end

ig = sortrows(IG,-1);
