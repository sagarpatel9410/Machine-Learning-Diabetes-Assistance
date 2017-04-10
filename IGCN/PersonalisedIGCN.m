function [ BestNeighbours, newUserPredicted ] = PersonalisedIGCN(BestLNeighbours, newUserPredicted, idx, userData, C, questions, newUser)

    loopCond = false;
    previousNeighbours = zeros(1,BestLNeighbours);
    
    while ~loopCond
        %Find the best l neighbours 
        [BestNeighbours, D] = knnsearch(C, newUserPredicted(:,1)','k', BestLNeighbours, 'Distance', 'Correlation');
        BestNeighbours = BestNeighbours(D <= 1);  
        height = numel(BestNeighbours);
        height(height >= BestLNeighbours) = BestLNeighbours;
        
        BestNeighbours(1:height);
        loopCond(isequal(previousNeighbours,BestNeighbours)) = true;
        
        previousNeighbours = BestNeighbours;
    
        if ~loopCond
            
            %Calculate IG from data from best neighbours
            ridx = find(ismember(idx, BestNeighbours));
            topics = InformationGain(idx(ridx), 10, userData(:,ridx'), 0.05);
            
            for i = 1:questions
                newUserPredicted(topics(i),2) = newUserPredicted(topics(i),2) + 1;                 
                newUserPredicted(topics(i),1) = (newUserPredicted(topics(i),1) + (newUser(topics(i)) >= rand()))/newUserPredicted(topics(i),2);
            end
        end
    end
    


end

