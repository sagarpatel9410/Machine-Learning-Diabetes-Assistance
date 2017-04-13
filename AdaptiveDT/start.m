clear
rng('default');
[ratingsMatrix] =  GenerateData(10,35,0.4,20,0.1)';
[num_users, num_topics] = size(ratingsMatrix);

