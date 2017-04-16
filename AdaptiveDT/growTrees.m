function tree = growTrees( data, param )

disp('Training Decision Tree...');
idx = size(data,1);
idx = (1:idx)';

for T = 1:param.treeNum
    % Initialise base node
    tree(T).node(1) = struct('idx',idx,'splitter',0);

    for n = 1:2^(param.depth-1)-1
        [tree(T).node(n),tree(T).node(n*2),tree(T).node(n*2+1)] = split(data,tree(T).node(n), param.a);
    end
end

end

