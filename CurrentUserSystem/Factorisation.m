load dataset.csv

A = dataset(dataset(:,6) == 1, :);
B = unique(A(:,2:4),'rows');
D = B(:,1).* B(:,2).* B(:,3);
C = unique(A(:,1));
for i = 1: size(A,1)
    %Determine unique id for problem col 2 + 3 + 4
       A(i, 8) = find(A(i,2).* A(i,3).* A(i,4) == D);
       A(i, 7) = find(A(i,1) == C);
end

utility_matrix = zeros(max(A(:,7)), max(A(:,8)));

for i = 1: size(A,1)
    
    utility_matrix(A(i,7), A(i,8)) = A(i,5);
    
end

