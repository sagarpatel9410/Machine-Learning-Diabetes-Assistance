function [tree,leavesIDX] = generateDecisionTree(data,param)

%        Base               Each node stores:
%         1                   trees.idx       - data (index only) which split into this node
%        / \                  trees.splitter  - threshold of split function
%       2   3                 
%      / \ / \               
%     4  5 6  7                

disp('Training Decision Tree...');

%Think about implementing a random forest.

[idx, num_topics] = size(data);
idx = [1:idx]';
% Initialise base node
tree(1).node(1) = struct('idx',idx,'splitter',0);

% Split Nodes
for n = 1:2^(param.depth-1)-1
    [tree(1).node(n),tree(1).node(n*2),tree(1).node(n*2+1)] = splitNode(data,tree(1).node(n),param);
end

end