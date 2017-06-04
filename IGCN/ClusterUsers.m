function [idx,centroids,kcluster_size] = ClusterUsers(max_clusters_size, user_data_set)
mse_clustersize = zeros(max_clusters_size, 1);
for i = 1:max_clusters_size
  [idx,C] = kmeans(user_data_set',i,'Replicates',10);
   mse_clustersize(i,1) = MSE(idx,C, user_data_set);
   i
end

plot(mse_clustersize);
kcluster_size = input('Choose cluster size: ');
[idx,centroids] = kmeans(user_data_set',kcluster_size,'Replicates',10);
end

function mse = MSE(idx, C, user_data)
    mse = 0;
    [~,n] = size(user_data);
    for i = 1:n    
        mse = mse + immse(C(idx(i,1),:), user_data(:,i)');
    end
    mse = mse/n;
end
