function [ Topic ] = FPS(topicModel)
%Fitness Proportionate Selection.
%Determine Fitness Wieghts
averagePerformance = mean(topicModel);
for t = 1:size(topicModel,2)
    fitness(t) = 1/abs(topicModel(t) - averagePerformance);
end

Topic = RouletteWheelSelection(fitness);


end

