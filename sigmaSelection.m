function [optSigma, B_bar, W_bar] = sigmaSelection(feaVal,species,method)
% ERPHM LAB Codes
% 2013-10-23 Created by Zhiliang Liu
% If you have any problems, feel free to contact Zhiliang_Liu@uestc.edu.cn
% 
% This function is to find the optimal sigma for Gaussian SVM.
% [1] feaVal    - N instances x d features;
% [2] species   - column vectors (category: nominal);
% [3] method    - corresponding to different values of w, two options: {'w1','w2'}
%                 w1 = [0.5;0.5]';
%                 w2 = [W_bar;B_bar]/(W_bar+B_bar);
% Reference
% [1] Zhiliang Liu, Ming J. Zuo, Xiaomin Zhao, and Hongbing Xu. An Analytical Approach
% to Fast Parameter Selection of Gaussian RBF Kernel for Support Vector Machine. Journal of Information Science and Engineering. Accepted on Mar. 11, 2013.
%
% Example:
% load fisheriris; 
% [optSigma B_bar W_bar] = sigmaSelection(meas,species,'w1')

% [1] feaVal    - X
% [2] species   - 作为标签的列向量Y
% [3] method    - corresponding to different values of w, two options: {'w1','w2'}
%                 w1 = [0.5;0.5]';
%                 w2 = [W_bar;B_bar]/(W_bar+B_bar);
if nargin < 3 error('no w specified!'); end%若输入参数小于3个，报错，程序结束
dataset.feaVal = zscore(feaVal,0,1);%数据标准化 feaVal中每个值减去平均值并除以标准差(feaVal - mean(feaVal))/std(feaVal)
dataset.species = nominal(species);%将species存到dataset.species里
[dataset.nSample, dataset.nFeature] = size(feaVal);%nSample为X的样本个数（行数），nFeature为X的参数个数（列数）
[dataset.iNSample, dataset.label] = summary(dataset.species);%label里存储所有种类的名字，iNSample存储每种种类的个数
dataset.nClass = length(dataset.label);%nClass为总种类个数
% (1) compuate W_bar and B_bar
W_sum = 0; B_sum = 0;
%两两之间一个分类器
for i = 1:dataset.nClass
    for j = i:dataset.nClass
        if i == j
            %求种类i的参数和种类i参数之间的成对欧氏矩阵的元素和并加到W_sum上
            W_sum = W_sum + EuclideanMatrixSum(dataset.feaVal(dataset.species == nominal(dataset.label(i)),:),...
            dataset.feaVal(dataset.species == nominal(dataset.label(j)),:));
        else
            %求种类i的参数和种类j的参数之间的成对欧氏矩阵的元素和并加到B_sum上
            B_sum = B_sum + EuclideanMatrixSum(dataset.feaVal(dataset.species == nominal(dataset.label(i)),:),...
            dataset.feaVal(dataset.species == nominal(dataset.label(j)),:));
        end
    end
end
nW = sum(dataset.iNSample.^2);%所有种类的个数的平方相加
nB = (dataset.nSample^2-nW)/2;%样本个数的平方减去nW除以2
W_bar = W_sum/nW;
B_bar = B_sum/nB;  
% (2) check the condition that a maximizer exists in a dataset
if W_bar >= B_bar 
    error('W_bar >= B_bar! The method is not applicable!'); 
end
% (3) compuate the optimal sigma
%w1 w2是两种计算方法 都是作者设定的
switch lower(method)
    case {'w1'}
        optSigma = sqrt((B_bar-W_bar)/(2*log(B_bar/W_bar)));	% Liu's 1st sigma formula
    case {'w2'}
        optSigma = sqrt((B_bar-W_bar)/(4*log(B_bar/W_bar)));    % Liu's 2nd sigma formula
    otherwise
        disp('No such method!');
%         optSigma = sqrt((B_bar-W_bar)/(2*log(w1/w2*B_bar/W_bar)));
end
end
%计算x和y的成对欧氏矩阵的元素和
function mSum = EuclideanMatrixSum(X,Y)
% compute the element-wise sum of pairwise-Euclidean matrix of X and Y
blockSize = 1000; % block size
mSum = 0;
nBlock = ceil([size(X,1) size(Y,1)]./blockSize);
for i = 1:nBlock(1)
    if i == nBlock(1) iEnd = size(X,1) - blockSize*(i-1); else iEnd = blockSize; end % if i go to the last block
    for j = 1:nBlock(2)
        if j == nBlock(2) jEnd = size(Y,1) - blockSize*(j-1); else jEnd = blockSize; end % if j go to the last block
        EuclideanM = pdist2(X([1:iEnd]+(i-1)*blockSize,:),Y([1:jEnd]+(j-1)*blockSize,:),'euclidean').^2;
        mSum = mSum + sum(sum(EuclideanM));
    end
end
end

