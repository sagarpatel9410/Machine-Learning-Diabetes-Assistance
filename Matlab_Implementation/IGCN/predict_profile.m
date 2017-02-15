function predictor = predict_profile(new_user_profile, user_neighbourhood)

[r,c] = size(user_neighbourhood);

predictor = zeros(1,c);

for i = 1:c
    
    upper = 0;
    lower = 0;
    
    for j = 1:r
        sim = corr(new_user_profile, user_neighbourhood(j,:)');
        r_adj = user_neighbourhood(j,i);
        upper = upper + (sim * r_adj);
        
        lower = lower + norm(sim);
        
    end
    predictor(1,i) = (upper/lower);
end



