function [node,nodeL,nodeH] = split( data,node, a, successThreshold )


% Initilise child nodes
nodeL = struct('idx',[],'splitter',0);
nodeH = struct('idx',[],'splitter',0);

% Make this node a leaf if has less than 3 users 
if length(node.idx) <= 3
    return;
end

%Calculate error before split
eBefore = calculateError(data,node.idx);
Err = zeros(size(data,2),1);
for i = 1:size(data,2)
    idxL = (data(node.idx, i) >= successThreshold);
    idxH = ~idxL;
    idxL = node.idx(idxL.*node.idx ~= 0);
    idxH = node.idx(idxH.*node.idx ~= 0);
    
    eL = calculateError(data,idxL);
    eH = calculateError(data,idxH);
    
    Err(i) = eL + eH;
end

%Randomisation of split function
splitter = RouletteWheelSelection(max(0, eBefore-Err).^a);

%[~ , splitter] = min(Err);

%Terminate if the error from splitting is greater than error from not
if isempty(splitter) || Err(splitter) >= eBefore
    return;
end

%Split node
node.splitter = splitter(1);

idxL = (data(node.idx, node.splitter) >= successThreshold);
idxH = ~idxL;
idxL = node.idx(idxL.*node.idx ~= 0);
idxH = node.idx(idxH.*node.idx ~= 0);

nodeL.idx = idxL;
nodeH.idx = idxH;

end

