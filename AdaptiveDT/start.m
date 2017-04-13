clear
rng('default');
[ratingsMatrix, newUser] =  GenerateData(20,35,0,20,0.1);


ratingsMatrix = round(ratingsMatrix' .* 100);
% Set the decision tree parameters ...
param.num = 10;
param.depth = 5;        % tree depth
param.successThreshold = 70;     % Number of split functions to try ie. Vary the success threshold function

tree = generateDecisionTree(ratingsMatrix,param);

userProfilePredicted = zeros(35,2);

n = 1;
for i = 1:param.depth
   if (tree.node(n).splitter ~= 0 && ~isempty(tree.node(n).idx))
       
        userProfilePredicted(tree.node(n).splitter, 1) = newUser(tree.node(n).splitter) >= rand();
        userProfilePredicted(tree.node(n).splitter, 2) = userProfilePredicted(tree.node(n).splitter, 2) + 1;
        
        if userProfilePredicted(tree.node(n).splitter, 1) == 1
            n = n*2;
        else
            n = n*2 + 1;
        end
   end  
end

if tree.node(n).splitter
    userProfilePredicted(tree.node(n).splitter, 1) = newUser(tree.node(n).splitter) >= rand();
    userProfilePredicted(tree.node(n).splitter, 2) = userProfilePredicted(tree.node(n).splitter, 2) + 1;
end

userNeighbourHood = ratingsMatrix(tree.node(n).idx, :);
newUserAdjusted = round(newUser * 100);

predictedProfile = PredictProfile( userProfilePredicted(:,1), userNeighbourHood', 0.8);

error = immse(predictedProfile/100, newUserAdjusted/100);

plot(newUserAdjusted/100)
hold on
plot(predictedProfile/100)


