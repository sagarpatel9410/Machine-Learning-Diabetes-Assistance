function [ predictedProfile ] = PredictProfile( newUserPredicted, userNeighbourHood, thresholdUsers)

userSimilarity = corr(newUserPredicted, userNeighbourHood(:,:))';
if isnan(userSimilarity)
    [r,~] = size(userSimilarity);
    userSimilarity = ones(3,1);
    predictedProfile = (userNeighbourHood * userSimilarity)/sum(abs(userSimilarity));
else
    userSimilarityNorm = normc(userSimilarity);
    threshold = max(userSimilarityNorm) * thresholdUsers;

    userNeighbourHood = userNeighbourHood(:,userSimilarityNorm >= threshold);
    userSimilarity = userSimilarity(userSimilarityNorm >= threshold);

    predictedProfile = (userNeighbourHood * userSimilarity)/sum(abs(userSimilarity));
end

end

