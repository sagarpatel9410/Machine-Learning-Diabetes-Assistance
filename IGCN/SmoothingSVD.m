function [userAverage] = SmoothingSVD(dataset, normMethod)
%SMOOTHINGSVD - Attempts to allieviate problem of sparsity in dataset
%Based of a study by Badrul M. Sarwar Application of Dimensionality Reduction in Recommender System

[topics, users] = size(dataset);

%Manipulate the data such that unrated items (indicated by 0) take on
%either the topic average (normMethod = 0)
%or the user average (normMethod = 1). Also manipulate the data such that the ratings are
%normalised by the users average rating

zidx = find(dataset == 0);

userAverage = mean(dataset,1);


end

