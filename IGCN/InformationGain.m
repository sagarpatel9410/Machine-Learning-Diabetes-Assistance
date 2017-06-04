function [topics_ordered, ig] = InformationGain(idx, K, userData, quantise)
%Returns a col vector of information gain for all topics

[topics,usersNum] = size(userData);

%Determine Entropy H(C)
%C denotes the users into classes ie. how many users are in each cluster
C = histcounts(idx(:),K)/usersNum;
C = C';
C = C(C ~= 0);
entropyC = - (C' * log2(C));
%---------------------------------------------------------------
quantisedData = round(userData/quantise);
quantisedData(quantisedData == 0) = 1;

for i = 1:topics
    udata = quantisedData(i,:);
    sum_r = 0;
    for j = 1:(1/quantise)
        ridx = idx(udata == j);
        C_R_A = histc(ridx(:),1:K)/usersNum;
        C_R_A = C_R_A(C_R_A ~= 0);
        EntropyCra = -(C_R_A' * log2(C_R_A));
        sum_r = sum_r + ((norm(C_R_A)/norm(C))* EntropyCra);
        if isempty(sum_r)
            sum_r = 0;
        end
        
    end
    IG(i) = entropyC - sum_r;  
end

    [ig,topics_ordered] = sort(IG,'descend'); 
    
end



