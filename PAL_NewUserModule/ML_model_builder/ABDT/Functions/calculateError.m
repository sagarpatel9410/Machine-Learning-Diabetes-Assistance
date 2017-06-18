function [error ,sumt, sumtsq, numRaters] = calculateError(data, set)
% data is the original utility matrix, it is required as we are only working
%with the indicies at each node t
% set are the users indicies that are associated with node t
item_set = size(data,2);

sumt = zeros(item_set,1);
sumtsq = zeros(item_set,1);
numRaters = zeros(item_set,1);

error = 0;

for j = 1:item_set
    
    sumt(j) = sum(data(set,j));
    sumtsq(j) = sum(data(set,j).^2);
    numRaters(j) = numel(find(data(set,j)));
    
    error = error + (sumtsq(j) - sumt(j)*sumt(j)/numRaters(j));
end
end