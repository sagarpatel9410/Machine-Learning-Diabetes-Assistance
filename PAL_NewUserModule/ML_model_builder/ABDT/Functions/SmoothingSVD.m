function [data] = SmoothingSVD(dataset, dimension)
%SMOOTHINGSVD - Attempts to allieviate problem of sparsity in dataset
%Based of a study by Badrul M. Sarwar Application of Dimensionality Reduction in Recommender System

[topics, ~] = size(dataset);
data = dataset;
%Manipulate the data such that unrated items take on
%topic average. Also manipulate the data such that the ratings are
%normalised by the users average rating
[zrow ,zcol] = find(dataset == 0);
zidx = find(dataset == 0);

userAverage = mean(dataset,1);
topicAverage = mean(dataset,2);

dataset(zidx) = topicAverage(zrow);
dataset = dataset - (ones(topics, 1) * userAverage);

%%%%%%%%%%%%%%%%%%%%
%SVD Smoothing
[U,S,V] = svd(dataset');

%Reduce the SVD matrix to dimension
Uk = U(:,1:dimension);
Vk = V(:,1:dimension);
Sk = S(1:dimension,1:dimension);
% Form a prediction matrix
A =  ((Uk*sqrtm(Sk)) * (sqrtm(Sk)*Vk'))';

% Replace the zero idx with predicted values
data(zidx) = userAverage(zcol);
data(zidx) = data(zidx) + A(zidx);
end

