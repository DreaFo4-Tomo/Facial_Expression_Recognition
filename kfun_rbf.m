function K = kfun_rbf(U, V, gamma)

%m1、n1为U的行数列数
[m1 n1] = size(U);
[m2 n2] = size(V);
%新建一个m1行、m2列的全0矩阵K
K = zeros(m1, m2);

for ii = 1:m1
    for jj = 1:m2
        %norm(U(ii, :)-V(jj, :))即求U(ii, :)-V(jj, :)的2范数
        %U的第ii行减去V的第jj行，将结果中的每个元素求平方再相加，再乘以-gamma
        K(ii, jj) = exp( -gamma * norm(U(ii, :)-V(jj, :))^2 );
    end
end