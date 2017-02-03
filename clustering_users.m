function mse_clustersize = clustering_users(max_clusters_size, user_data_set)
mse_clustersize = zeros(max_clusters_size, 1);
for i = 1:max_clusters_size
    [idx,C] = kmeans(user_data_set',i,'Replicates',10,'Distance','correlation');
    mse_clustersize(i,1) = mean_square_error(idx,C, user_data_set);
end

