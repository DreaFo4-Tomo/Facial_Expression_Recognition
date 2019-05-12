function class = multiSVMClassify(TestFace, multiSVMStruct)
% 采用1对1投票策略将 SVM 推广至多类问题的分类过程
if nargin < 2
    t = dir('Mat/multiSVMTrain.mat');
    if length(t) == 0
        error('没有找到训练结果文件，请在分类以前首先进行训练！');
    end
    load('Mat/multiSVMTrain.mat');
end

nClass = multiSVMStruct.nClass; % 读入类别数
CASVMStruct = multiSVMStruct.CASVMStruct; % 读入两两类之间的分类器信息


m = size(TestFace, 1);
Voting = zeros(m, nClass); % m个测试样本，每个样本nFaces 个类别的投票箱
for iIndex = 1:nClass-1
    for jIndex = iIndex+1:nClass
        classes = svmclassify(CASVMStruct{iIndex}{jIndex}, TestFace);
       
        Voting(:, iIndex) = Voting(:, iIndex) + (classes == 1);
        Voting(:, jIndex) = Voting(:, jIndex) + (classes == 0);
                
    end 
end



% final decision by voting result
[vecMaxVal, class] = max( Voting, [], 2 );
%display(sprintf('TestFace对应的类别是:%d',class));