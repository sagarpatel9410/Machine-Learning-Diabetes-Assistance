clear
rng('default')

results = zeros(1225, 4);

for iq = 1:35
    for pq = 1:35
        [new_user_profile,error,questions_asked] = cold_start(iq, pq);
        results(iq*pq,1) = error;
        results(iq*pq,2) = questions_asked;
        results(iq*pq,3) = iq;
        results(iq*pq,4) = pq;
    end 
end