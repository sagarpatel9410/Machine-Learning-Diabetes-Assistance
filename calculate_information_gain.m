function ig = calculate_information_gain(k,idx,topics)
%returns a column vector of information gain for each of the topics 

%---------------------------------------------------
%determine the entropy H(C)
%%determine C - distribution of users into classes
C = zeros(k,1);
[m,~] = size(idx);

for i = 1:m
    C(idx(i,1)) = C(idx(i,1)) + 1;
end
C = C/m;

H_C = 0; %H(C)
for i = 1:k
    H_C = H_C - (C(i,1)*log2(C(i,1)));
end

%---------------------------------------------------

%determine C^r_at - dist of users into classes that rated item a_t with r
quantise = 0.05;
C_r_at = zeros(k,topics,1/quantise);


