function test()

display(' ');
display(' ');
display('测试开始...');

nFaces = 4;
nPerson = 40;
% 读入测试集合
display('读入测试数据...');
[imgRow,imgCol,TestFace,testLabel] = ReadFaces(nPerson, nFaces, 1);
display('..............................');

% 读入相关训练结果
display('载入训练参数...');

load('Mat/PCA.mat');
load('Mat/scaling.mat');
load('Mat/trainData.mat');
load('Mat/multiSVMTrain.mat');
display('..............................');

% PCA降维
display('PCA降维处理...');
[m n] = size(TestFace);
TestFace = (TestFace-repmat(meanVec, m, 1))*V; % 经过pca变换降维
%归一化
TestFace = scaling(TestFace,1,A0,B0);
display('..............................');

% 多类 SVM 分类
display('测试集识别中...');
classes = multiSVMClassify(TestFace);
display('..............................');

% 计算识别率
nError = sum(classes ~= testLabel);
accuracy = 1 - nError/length(testLabel);
display(['SVM对于测试集表情样本的识别率为', num2str(accuracy*100), '%']);

