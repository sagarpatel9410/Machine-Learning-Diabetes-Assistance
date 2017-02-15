function mse = mean_square_error(idx, C, user_data)
mse = 0;
[~,n] = size(user_data);
for i = 1:n    
    mse = mse + immse(C(idx(i,1),:), user_data(:,i)');
end

mse = mse/n;