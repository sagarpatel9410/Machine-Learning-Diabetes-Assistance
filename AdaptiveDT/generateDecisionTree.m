function tree = generateDecisionTree(dataSet, items, successThreshold)

%splitting item selection
for i = 1:items
    %Loop over all users in the dataset S_t that have rated the item i
    raters = find(dataSet(:,i));
    %determine if user belongs to success or failure branch
    raters(:,2) = dataSet(raters(:,1),i) > successThreshold;
    L = raters(raters(:,2) == 1 ,1);
    H = raters(raters(:,2) == 0 ,1);
    
    sumTL = sum(dataSet(L,i));
    sumTH = sum(dataSet(H,i));
    
    sumSquTL = sum(dataSet(L,i).^2);
    sumSquHL = sum(dataSet(H,i).^2);
    
    
    
        
end
end