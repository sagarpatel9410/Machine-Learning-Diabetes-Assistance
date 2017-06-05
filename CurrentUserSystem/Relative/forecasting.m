clear
load dataset_modified.mat
rng(0);

users = length(unique(dataset(:,1)));
alpha = abs(normrnd(0.2,0.1,users,1));

L = 10;
gamma = 0.0002;
for step = 1:100
    tempL = L;
    randomise = randperm(length(dataset));
    
    for item = 1:length(randomise)
        user = dataset(randomise(item),1);
        topic = dataset(randomise(item),2);
        rating = dataset(randomise(item),3);
        time = dataset(randomise(item),4);

        if time == 1 || time == 2
            continue;
        elseif time <= L
            L = time - 1;
        end

        E_initial = dataset(randomise(item) - L,3);
        clearvars E_T
        for t = 1:L-1
            if t == 1
               E_T(t) = (alpha(user) * dataset(randomise(item) - L + t,3)) + (1 - alpha(user))*E_initial;
            else
               E_T(t) = (alpha(user) * dataset(randomise(item) - L + t,3)) + (1 - alpha(user))*E_T(t-1);
            end
        end

        predicted = E_T(L-1);
        
        sumterm = 0;
        
        for j = 1:L-1
            
            sumterm = sumterm + (1-alpha(user))^(j - 2) * (1 - 2*alpha(user)) * dataset(randomise(item) - j ,3);
            
        end
        
        diffterm = -(L - 1)*((1 - alpha(user))^(L - 2))*E_initial + sumterm;
        term = -2*(rating - predicted)*diffterm;
        alpha(user) = alpha(user) - gamma*(term);
        
        
        L = tempL;

    end
    
   
    %Calculate error
    for item = 1:length(dataset)
        user = dataset(randomise(item),1);
        topic = dataset(randomise(item),2);
        rating = dataset(randomise(item),3);
        time = dataset(randomise(item),4);

        if time == 1 || time == 2
            continue;
        elseif time <= L
            L = time - 1;
        end

        E_initial = dataset(randomise(item) - L,3);
        clearvars E_T
        for t = 1:L-1
            if t == 1
               E_T(t) = (alpha(user) * dataset(randomise(item) - L + t,3)) + (1 - alpha(user))*E_initial;
            else
               E_T(t) = (alpha(user) * dataset(randomise(item) - L + t,3)) + (1 - alpha(user))*E_T(t-1);
            end
        end

        predicted = E_T(L-1);
        
        error(item) = (rating - predicted)^2;
        
        L = tempL;
        
    end
    step
    mean(error)
    mse(step) = mean(error);
    
end