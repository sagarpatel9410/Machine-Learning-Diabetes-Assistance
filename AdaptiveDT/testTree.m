function [user_neighbourhood, predicted_profile] = testTree(tree,newUser,param)


%Find the number of trees
TSize = size(tree,2);

disp('Testing Random Forest...');

for T = 1:TSize
    pp = zeros(size(newUser,2),2);
    nd = 1;
    for n = 1:param.depth
        %The node is not a leaf
        if (tree(T).node(nd).splitter && ~isempty(tree(T).node(nd).idx))
            
            user_result = newUser(tree(T).node(nd).splitter) >= (rand()*100);
            pp(tree(T).node(nd).splitter, 2) = pp(tree(T).node(nd).splitter, 2) + 1;
            pp(tree(T).node(nd).splitter, 1) = (user_result + pp(tree(T).node(nd).splitter, 1))/pp(tree(T).node(nd).splitter, 2);

            if user_result == 1
                nd = nd*2;
            else
                nd = nd*2 + 1;
            end
        end
    end
    
    predicted_profile{T} = pp;
    user_neighbourhood{T} = tree(T).node(nd).idx;

end

