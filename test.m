function test()

display(' ');
display(' ');
display('���Կ�ʼ...');

nFaces = 4;
nPerson = 40;
% ������Լ���
display('�����������...');
[imgRow,imgCol,TestFace,testLabel] = ReadFaces(nPerson, nFaces, 1);
display('..............................');

% �������ѵ�����
display('����ѵ������...');

load('Mat/PCA.mat');
load('Mat/scaling.mat');
load('Mat/trainData.mat');
load('Mat/multiSVMTrain.mat');
display('..............................');

% PCA��ά
display('PCA��ά����...');
[m n] = size(TestFace);
TestFace = (TestFace-repmat(meanVec, m, 1))*V; % ����pca�任��ά
%��һ��
TestFace = scaling(TestFace,1,A0,B0);
display('..............................');

% ���� SVM ����
display('���Լ�ʶ����...');
classes = multiSVMClassify(TestFace);
display('..............................');

% ����ʶ����
nError = sum(classes ~= testLabel);
accuracy = 1 - nError/length(testLabel);
display(['SVM���ڲ��Լ�����������ʶ����Ϊ', num2str(accuracy*100), '%']);

