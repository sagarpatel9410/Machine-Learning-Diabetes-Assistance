parfor i = 1:size(abc,1)
   
    idx = find(ismember(dataset(:,[1,2,3]), abc(i,:) ,'rows'));
    a(i) = floor(mean(dataset(idx,4)));   
    i
end

