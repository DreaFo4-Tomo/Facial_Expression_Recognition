function K = kfun_sigmoid(U,V,P1,P2)
%P1����U����V��ת�ü���P2���Խ����tanh
K = tanh(P1*(U*V')+P2);