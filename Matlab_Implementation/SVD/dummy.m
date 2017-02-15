clear
rng('default');
data = generating_data_set(50,35,0,30,0.1);

[U,S,V] = svd(data);

