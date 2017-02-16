clear
rng('default');
data = generating_data_set(10,35,0.1,20,0.1);

[r,c] = size(data);

for i = 1:r
    avg = mean(data(i,:));
    for j = 1:c
        
        if(data(i,j) == 0)
            data(i,j) = avg;
        end
        
    end
end


    
%using SVD to predict uknown ratings of the entire Rating matrix

[U,S,V] = svd(data');






