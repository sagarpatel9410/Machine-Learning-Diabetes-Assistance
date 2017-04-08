
rng('default');
%data = generating_data_set(10,35,0.3,20,0.1);
data_adj = data;
data_test = data;
[r,c] = size(data);

userAverage = mean(data,1);

for i = 1:r
    avg = mean(data(i,:));
    for j = 1:c
        if(data(i,j) == 0)
            data_adj(i,j) = avg;
        end
        
        data_adj(i,j) = data_adj(i,j) -  mean(data(:,j));
        
    end
end

[U,S,V] = svd(data_adj');

k = 10;

Uk = U(:,1:k);
Vk = V(:,1:k);
Sk = S(1:k,1:k);

A =  (Uk*sqrtm(Sk)) * (sqrtm(Sk)*Vk');

for i = 1:r
    for j = 1:c
        if(data(i,j) == 0)
            data(i,j) = userAverage(j) + A(j,i);
        end        
    end
end

[idx,centroids, kcluster_size] = clustering_users(25, data);
clustering_users(25, data_test);
