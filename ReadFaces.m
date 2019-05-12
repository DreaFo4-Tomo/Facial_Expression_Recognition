function [imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nPerson, nFaces, bTest)
%bTest = 0表示读取训练数据，bTest=1表示读取测试数据

img=imread('Data/Train/001-01.bmp');
%获取图片的行列数
[imgRow,imgCol]=size(img);

%FaceContainer是nFaces*nPerson行imgRow*imgCol列的数组，用于装载所有的样本数据，第一行的imgRow*imgCol个数据表示第一张图片
FaceContainer = zeros(nFaces*nPerson, imgRow*imgCol);
%faceLabel是nFaces*nPerson行1列的数组，用于装载数据标签，1表示neutral，2表示happy，3表示anger，4表示surprise（且每一行的标签都与FaceContainer的数据相对应，比如说FaceContainer第一行的数据表示的图片是anger，则faceLabel第一行=3）
faceLabel = zeros(nFaces*nPerson, 1);

% 读入训练数据
for i = 1 : nFaces
    for j = 1 : nPerson
        % 读入训练数据
        if bTest == 0 
            strPath='Data/Train/';
            %读取测试数据
        else
            strPath='Data/Test/';
        end
        %按顺序写出图片路径
        if j < 10
            strPath=strcat(strPath,'00',num2str(j),'-0',num2str(i),'.bmp');
        elseif j < 100
            strPath=strcat(strPath,'0',num2str(j),'-0',num2str(i),'.bmp');
        elseif j >= 100
            strPath=strcat(strPath,num2str(j),'-0',num2str(i),'.bmp');
        end
        
        %读取图片
        img=imread(strPath);
        %将图片数据存入FaceContainer，标签存入faceLabel
        FaceContainer((i-1)*nPerson+j, :) = img(:)';
        faceLabel((i-1)*nPerson+j) = i;
    end
end
%保存FaceContainer为Mat/FaceMat.mat文件
save('Mat/FaceMat.mat', 'FaceContainer')




