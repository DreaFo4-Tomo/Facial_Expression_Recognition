function K = kfun_rbf(U, V, gamma)

%m1��n1ΪU����������
[m1 n1] = size(U);
[m2 n2] = size(V);
%�½�һ��m1�С�m2�е�ȫ0����K
K = zeros(m1, m2);

for ii = 1:m1
    for jj = 1:m2
        %norm(U(ii, :)-V(jj, :))����U(ii, :)-V(jj, :)��2����
        %U�ĵ�ii�м�ȥV�ĵ�jj�У�������е�ÿ��Ԫ����ƽ������ӣ��ٳ���-gamma
        K(ii, jj) = exp( -gamma * norm(U(ii, :)-V(jj, :))^2 );
    end
end