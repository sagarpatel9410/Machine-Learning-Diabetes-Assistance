function [ N, idx, C, topics ] = train_IGCN_model(smoothing)
%train_IGCN_model
%   This function is responsible for training the IGCN algorithm, its
%   returns the size of the neighbourhood (N), the cluster centres (C) and the
%   cluster that each user in the dataset belongs to (idx)
%   The smoothing input indicates whether the dataset should be smoothed
%   before the neighbourhoods are found.

SVDReductionDimension = 25;

%Load the studentmodel
load studentmodels.mat

utility = utility';
%Smooth the data
if smoothing == 1
    utility = SmoothingSVD(utility, SVDReductionDimension);
end

%Get the number of users and topics in the studentdata
num_users = size(utility,2);
num_topics = size(utility,1);

%Determine clusters
[idx,C,~,N] = best_kmeans(utility');

%Once the neighbourhood has been determined we can build a general list of
%topics to ask questions in based of all users in the student model.

[topics, ~] = InformationGain(idx, N, utility, 0.05);

end

