function e = my_mse_cube(user,items,time,utility, P,H,Q)

    for i = 1:length(user)
        
        predicted = mu + student_bias(user(i)) + task_bias(items(i)) + sum(P(user(i),:).*H(items(i),:).*Q(time(i),:));
        err(i) = (utility(user(i),items(i),time(i)) - predicted)^2;
        
    end
    
    e = mean(err)
end

