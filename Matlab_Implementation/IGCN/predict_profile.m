function [predictor,sim]= predict_profile(new_user_profile, user_neighbourhood)

[r,c] = size(user_neighbourhood);

predictor = zeros(1,c);
sim = zeros(r,1);
for i = 1:c
    
    upper = 0;
    lower = 0;
    
    for j = 1:r
        sim(j,1) = corr(new_user_profile, user_neighbourhood(j,:)');
    end
    
    sim_norm = normc(sim);
    threshold = sim_norm(1,1)*0.8;

    for j = 1:r
        
        if(sim_norm(j,1) < threshold) 
            sim(j,1) = 0;
        end
        
        r_adj = user_neighbourhood(j,i);
        upper = upper + (sim(j,1) * r_adj);
        
        lower = lower + norm(sim(j,1));
        
    end
    predictor(1,i) = (upper/lower);
end


sim = sortrows(sim,-1);


