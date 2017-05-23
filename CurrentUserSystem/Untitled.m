
parfor_progress(size(taskid,1)); % Initialize 


parfor i = 1:size(taskid,1)
    idx = strmatch(taskid{i,1}, taskidcell); 
    newData{i} = idx;
    parfor_progress
    
end

parfor_progress(0); % Clean up



for i = 1:size(uid,1)
    tic
    idx = strmatch(uid{i,1}, uidcell);
    newData(idx,1) = i;
    toc
    i
end
