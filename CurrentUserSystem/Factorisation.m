load dataset.csv

A = dataset(dataset(:,6) == 1, :);
B = unique(A(:,2:4),'rows');

for i = 1: size(A,1)
    %Determine unique id for problem col 2 + 3 + 4
       [~, A(i, 7)] = ismember(A(1,2:4), B, 'rows');
end