function [ BestNeighbours, newUserPredicted ] = PersonalisedIGCN(BestLNeighbours, newUserPredicted, idx, userData, C, questions, newUser, max_clusters)

    loopCond = false;
    previousNeighbours = zeros(1,BestLNeighbours);
    qasked = 0;
    while ~loopCond
        %Find the best l neighbours 
        [BestNeighbours, D] = knnsearch(C, newUserPredicted(:,1)','k', BestLNeighbours);
%         BestNeighbours = BestNeighbours(D <= 1);  
        height = numel(BestNeighbours);
        height(height >= BestLNeighbours) = BestLNeighbours;
        
        BestNeighbours = BestNeighbours(1:height);
        loopCond(isequal(previousNeighbours,BestNeighbours)) = true;
        
        previousNeighbours = BestNeighbours;
    
        if ~loopCond && qasked < questions 
            
            %Calculate IG from data from best neighbours
            ridx = find(ismember(idx, BestNeighbours));
            topics = InformationGain(idx(ridx), max_clusters, userData(:,ridx'), 0.05);
            
            %Ask next Question
            newUserPredicted(topics(1),2) = newUserPredicted(topics(1),2) + 1;                 
            newUserPredicted(topics(1),1) = (newUserPredicted(topics(1),1) + (newUser(topics(1)) >= rand()))/newUserPredicted(topics(1),2);
            
            qasked = qasked + 1;
        end
    end
    


end

