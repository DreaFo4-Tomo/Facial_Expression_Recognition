function K = kfun_sigmoid(U,V,P1,P2)
%P1乘以U乘以V的转置加上P2，对结果求tanh
K = tanh(P1*(U*V')+P2);