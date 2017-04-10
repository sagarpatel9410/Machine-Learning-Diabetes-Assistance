function [ predictedProfile ] = PredictProfile( newUserPredicted, userNeighbourHood, thresholdUsers)

userSimilarity = corr(newUserPredicted, userNeighbourHood(:,:))';
userSimilarityNorm = normc(userSimilarity);
threshold = max(userSimilarityNorm) * thresholdUsers;

userNeighbourHood = userNeighbourHood(:,userSimilarityNorm >= threshold);
userSimilarity = userSimilarity(userSimilarityNorm >= threshold);

predictedProfile = (userNeighbourHood * userSimilarity)/sum(abs(userSimilarity));


end

