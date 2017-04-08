clear
%values to alternate:
dimension = 10;
clusterSize = 10;

rng('default');

%Generating the data set & simulate random user
[user_data_set, new_user] = GenerateData(10,35,0.4,20,0.1);

%--------------------------------------------------------------------------
% SVD Smoothing
user_data_set = SmoothingSVD(user_data_set, dimension);

%--------------------------------------------------------------------------
%Determine clusters
[idx, C] = ClusterUsers(clusterSize,user_data_set);

%--------------------------------------------------------------------------


%----------------------IGCN-----------------------%
