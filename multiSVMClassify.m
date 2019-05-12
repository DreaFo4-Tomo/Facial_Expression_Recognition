function class = multiSVMClassify(TestFace, multiSVMStruct)
% ����1��1ͶƱ���Խ� SVM �ƹ�����������ķ������
if nargin < 2
    t = dir('Mat/multiSVMTrain.mat');
    if length(t) == 0
        error('û���ҵ�ѵ������ļ������ڷ�����ǰ���Ƚ���ѵ����');
    end
    load('Mat/multiSVMTrain.mat');
end

nClass = multiSVMStruct.nClass; % ���������
CASVMStruct = multiSVMStruct.CASVMStruct; % ����������֮��ķ�������Ϣ


m = size(TestFace, 1);
Voting = zeros(m, nClass); % m������������ÿ������nFaces ������ͶƱ��
for iIndex = 1:nClass-1
    for jIndex = iIndex+1:nClass
        classes = svmclassify(CASVMStruct{iIndex}{jIndex}, TestFace);
       
        Voting(:, iIndex) = Voting(:, iIndex) + (classes == 1);
        Voting(:, jIndex) = Voting(:, jIndex) + (classes == 0);
                
    end 
end



% final decision by voting result
[vecMaxVal, class] = max( Voting, [], 2 );
%display(sprintf('TestFace��Ӧ�������:%d',class));