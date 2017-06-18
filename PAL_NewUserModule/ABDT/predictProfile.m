function [ profile_predicted ] = predictProfile( user_neighbourhood, profile_predicted, data )

T = size(profile_predicted,2);
pp = zeros(size(data,2),2);

for i = 1:T
    pp = pp + profile_predicted{i};
end

pp(:,1) = pp(:,1)./pp(:,2);
profile_used = pp(pp(:,2) > 0) * 100;
profile_used_idx = find(pp(:,2)>0);

neighbours = 0;
relavant_data = zeros(1,size(profile_used_idx,1));
for i = 1:T
    relavant_data = [relavant_data;data(user_neighbourhood{i},profile_used_idx)];
    neighbours = [neighbours; user_neighbourhood{i}];
end
relavant_data(1,:) = [];
neighbours(1) = [];

similarity = corr(relavant_data',profile_used);
if isnan(similarity)
    [r,~] = size(similarity);
    similarity = ones(r,1);
    profile_predicted = (data(neighbours,:)' * similarity)/sum(abs(similarity));
else
    similarityNorm = normc(similarity);
    threshold = max(similarityNorm) * 0.8;

    neighbours = neighbours(similarityNorm >= threshold, :);
    similarity = similarity(similarityNorm >= threshold);

    profile_predicted = (data(neighbours,:)' * similarity)/sum(abs(similarity));
end
end

