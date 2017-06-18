function [ tree ] = train_ABDT_model( smoothing )
%TRAIN_ABDT_MODEL Summary of this function goes here
%   Detailed explanation goes here

%Load the studentmodel
load studentmodels.mat

%Smooth the data
if smoothing == 1
    utility = SmoothingSVD(utility, SVDReductionDimension);
end

data = round(utility.*100);

%Tree Parameters
param.depth = 5;        % tree max depth
param.treeNum = 10;
param.a = 10;
param.successThreshold = 50;


tree = growTrees(data,param);



end

