function [node,nodeL,nodeR] = splitNode(data,node,param)

% Initilise child nodes
nodeL = struct('idx',[],'splitter',0);
nodeR = struct('idx',[],'splitter',0);

% Make this node a leaf if has less than 5 users 
% Todo add a check that will determine the error and see if it if worth
% spliting the data.
if length(node.idx) <= 5
    return;
end

idx = node.idx;
dataSet = data(idx,:);

Err = zeros(35,1);
%splitting item selection
for i = 1:35
    %Loop over all users in the dataset S_t that have rated the item i
    raters = find(dataSet(:,i));
    %determine if user belongs to success or failure branch
    raters(:,2) = dataSet(raters(:,1),i) > param.successThreshold;
    L = raters(raters(:,2) == 1 ,1);
    H = raters(raters(:,2) == 0 ,1);
    
    sumTLj = sum(dataSet(L,:),1);
    sumTHj = sum(dataSet(H,:),1);
    
    sumSquTLj = sum(dataSet(L,:).^2,1);
    sumSquTHj = sum(dataSet(H,:).^2,1);
    
    
    for j = 1:35
       
       n_TL(j) = norm(dataSet(intersect(find(dataSet(:,j)), L),:));
       n_TH(j) = norm(dataSet(intersect(find(dataSet(:,j)), H),:));
       
       if n_TL(j) == 0
           eTL = 0;
       else
           eTL = sumSquTLj(j) - (sumTLj(j))^2/n_TL(j);
       end
       
       if n_TH(j) == 0
           eTH = 0;
       else
           eTH = sumSquTHj(j) - (sumTHj(j))^2/n_TH(j);
       end
       
       Err(i) = Err(i) + eTL + eTH;
       
    end
end

node.splitter = find(Err(:) == min(Err(:)));

raters = intersect(find(data(:,node.splitter)), node.idx);



%determine if user belongs to success or failure branch
raters(:,2) = data(raters(:,1),node.splitter(1)) > param.successThreshold;
L = raters(raters(:,2) == 1 ,1);
H = raters(raters(:,2) == 0 ,1);

nodeL.idx = L;
nodeR.idx = H;

end

