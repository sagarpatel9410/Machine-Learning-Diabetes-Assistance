function neighbours = best_neighbours(centroids, new_user_profile,l)
[val,~] = size(centroids);
neighbours = zeros(val,2);
for k = 1:val
    neighbours(k,1) = corr(new_user_profile(:,1), centroids(k,:)');
    neighbours(k,2) = k;
end

neighbours = sortrows(neighbours,-1);
neighbours = neighbours(1:l,:);
