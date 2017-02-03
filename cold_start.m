clear
%generate data set - Noise ± 0.1 | Max User 20 | Sparsity 0 | Base User 10
user_data_set = generating_data_set(10,35,0,20,0.1);
%determine optimal number of clusters
plot(clustering_users(25,user_data_set))

k = input('Specify Cluster Size ');

%cluster users using K means with k = optimal clusters 
[idx,centroids] = kmeans(user_data_set',k,'Replicates',10,'Distance','correlation');

