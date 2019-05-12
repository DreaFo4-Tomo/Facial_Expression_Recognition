function train(C)
%C、gamma为重要参数，可以自己修改，看结果
% 整个训练过程，包括读入图像，PCA降维以及多类 SVM 训练，各个阶段的处理结果分别保存至文件：
%   将 PCA 变换矩阵 W 保存至 Mat/PCA.mat
%   将 scaling 的各维上、下界信息保存至 Mat/scaling.mat
%   将 PCA 降维并且 scaling 后的数据保存至 Mat/trainData.mat
%   将多类 SVM 的训练信息保存至 Mat/multiSVMTrain.mat

global imgRow;
global imgCol;

display(' ');
display(' ');
display('训练开始...');
%4种表情
nFaces=4;
%每种表情150张图片
nPerson = 150;
display('读入人脸数据...');
[imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nPerson,nFaces,0);

%判断读取的数据是否不为空
if (isempty(FaceContainer) == 0) && (isempty(faceLabel) == 0)
    display('读取成功...');
else
    display('读取失败...');
end

display('..............................');

%Faces为样本总数即nFaces*nPerson
Faces=size(FaceContainer,1);

display('PCA降维...');
%pca为主成分分析，即将数据降维。降维是将高维度的数据保留下最重要的一些特征，去除噪声和不重要的特征，从而实现提升数据处理速度的目的。可自行百度pca了解原理
%此处将每个样本数据降至20维
% pcaFaces --- 降维后的 k 维样本特征向量组成的矩阵，每行一个样本，列数 k 为降维后的样本特征维数
% 则pcaFaces为480*20的矩阵(480个样本，每个样本20维度）
% W --- 主成分向量(2000*20)
[pcaFaces, W] = fastPCA(FaceContainer, 20); 

%将主成分向量可视化（这一行可有可无，删了也可以）
visualize_pc(W);
display('..............................');
X = pcaFaces;

%归一化数据
display('归一化开始...');
display('.........');
[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');

TrainData = X;
trainLabel = faceLabel;
save('Mat/trainData.mat', 'TrainData', 'trainLabel');

display('归一化完成...');

display('训练分类器开始，这个过程可能会花上几分钟.........................');
%统计每种表情各有多少样本
for iPerson = 1:nPerson
    nSplPerClass(iPerson) = sum( (trainLabel == iPerson) );
end
[optSigma, B_bar, W_bar] = sigmaSelection(TrainData,trainLabel,'w1');
fprintf('选取的gamma值为%f\n',optSigma);
%C、gamma为重要参数，可以自己修改，看结果
multiSVMStruct = multiSVMTrain(TrainData, nSplPerClass, nFaces, C, optSigma);
save('Mat/multiSVMTrain.mat', 'multiSVMStruct');   

display('..............................');
display('训练完成。');