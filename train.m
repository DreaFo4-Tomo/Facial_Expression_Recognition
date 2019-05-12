function train(C)
%C��gammaΪ��Ҫ�����������Լ��޸ģ������
% ����ѵ�����̣���������ͼ��PCA��ά�Լ����� SVM ѵ���������׶εĴ������ֱ𱣴����ļ���
%   �� PCA �任���� W ������ Mat/PCA.mat
%   �� scaling �ĸ�ά�ϡ��½���Ϣ������ Mat/scaling.mat
%   �� PCA ��ά���� scaling ������ݱ����� Mat/trainData.mat
%   ������ SVM ��ѵ����Ϣ������ Mat/multiSVMTrain.mat

global imgRow;
global imgCol;

display(' ');
display(' ');
display('ѵ����ʼ...');
%4�ֱ���
nFaces=4;
%ÿ�ֱ���150��ͼƬ
nPerson = 150;
display('������������...');
[imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nPerson,nFaces,0);

%�ж϶�ȡ�������Ƿ�Ϊ��
if (isempty(FaceContainer) == 0) && (isempty(faceLabel) == 0)
    display('��ȡ�ɹ�...');
else
    display('��ȡʧ��...');
end

display('..............................');

%FacesΪ����������nFaces*nPerson
Faces=size(FaceContainer,1);

display('PCA��ά...');
%pcaΪ���ɷַ������������ݽ�ά����ά�ǽ���ά�ȵ����ݱ���������Ҫ��һЩ������ȥ�������Ͳ���Ҫ���������Ӷ�ʵ���������ݴ����ٶȵ�Ŀ�ġ������аٶ�pca�˽�ԭ��
%�˴���ÿ���������ݽ���20ά
% pcaFaces --- ��ά��� k ά��������������ɵľ���ÿ��һ������������ k Ϊ��ά�����������ά��
% ��pcaFacesΪ480*20�ľ���(480��������ÿ������20ά�ȣ�
% W --- ���ɷ�����(2000*20)
[pcaFaces, W] = fastPCA(FaceContainer, 20); 

%�����ɷ��������ӻ�����һ�п��п��ޣ�ɾ��Ҳ���ԣ�
visualize_pc(W);
display('..............................');
X = pcaFaces;

%��һ������
display('��һ����ʼ...');
display('.........');
[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');

TrainData = X;
trainLabel = faceLabel;
save('Mat/trainData.mat', 'TrainData', 'trainLabel');

display('��һ�����...');

display('ѵ����������ʼ��������̿��ܻỨ�ϼ�����.........................');
%ͳ��ÿ�ֱ�����ж�������
for iPerson = 1:nPerson
    nSplPerClass(iPerson) = sum( (trainLabel == iPerson) );
end
[optSigma, B_bar, W_bar] = sigmaSelection(TrainData,trainLabel,'w1');
fprintf('ѡȡ��gammaֵΪ%f\n',optSigma);
%C��gammaΪ��Ҫ�����������Լ��޸ģ������
multiSVMStruct = multiSVMTrain(TrainData, nSplPerClass, nFaces, C, optSigma);
save('Mat/multiSVMTrain.mat', 'multiSVMStruct');   

display('..............................');
display('ѵ����ɡ�');