function multiSVMStruct = multiSVMTrain(TrainData, nSampPerClass, nClass, C, gamma)
%C��gammaΪ��Ҫ�����������Լ��޸ģ������

%��ʼѵ������Ҫ����ÿ�����ķ��೬ƽ�棬��(nClass-1)*nClass/2��
for ii=1:(nClass-1)
    for jj=(ii+1):nClass
        clear X;
        clear Y;
        startPosII = sum( nSampPerClass(1:ii-1) ) + 1;
        endPosII = startPosII + nSampPerClass(ii) - 1;
        X(1:nSampPerClass(ii), :) = TrainData(startPosII:endPosII, :);
            
        startPosJJ = sum( nSampPerClass(1:jj-1) ) + 1;
        endPosJJ = startPosJJ + nSampPerClass(jj) - 1;
        X(nSampPerClass(ii)+1:nSampPerClass(ii)+nSampPerClass(jj), :) = TrainData(startPosJJ:endPosJJ, :);
        
        
        % �趨��������ʱ�����ǩ
        Y = ones(nSampPerClass(ii) + nSampPerClass(jj), 1);
        Y(nSampPerClass(ii)+1:nSampPerClass(ii)+nSampPerClass(jj)) = 0;
        
        % ��ii������͵�jj��������������ʱ�ķ������ṹ��Ϣ
        CASVMStruct{ii}{jj} = svmtrain( X, Y, 'Kernel_Function', @(X,Y) kfun_rbf(X,Y,gamma), 'boxconstraint', C );
     end
end

% ��ѧ�õķ�����
multiSVMStruct.nClass = nClass;
multiSVMStruct.CASVMStruct = CASVMStruct;


% �������
save('Mat/params.mat', 'C', 'gamma');



