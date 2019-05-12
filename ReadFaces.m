function [imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nPerson, nFaces, bTest)
%bTest = 0��ʾ��ȡѵ�����ݣ�bTest=1��ʾ��ȡ��������

img=imread('Data/Train/001-01.bmp');
%��ȡͼƬ��������
[imgRow,imgCol]=size(img);

%FaceContainer��nFaces*nPerson��imgRow*imgCol�е����飬����װ�����е��������ݣ���һ�е�imgRow*imgCol�����ݱ�ʾ��һ��ͼƬ
FaceContainer = zeros(nFaces*nPerson, imgRow*imgCol);
%faceLabel��nFaces*nPerson��1�е����飬����װ�����ݱ�ǩ��1��ʾneutral��2��ʾhappy��3��ʾanger��4��ʾsurprise����ÿһ�еı�ǩ����FaceContainer���������Ӧ������˵FaceContainer��һ�е����ݱ�ʾ��ͼƬ��anger����faceLabel��һ��=3��
faceLabel = zeros(nFaces*nPerson, 1);

% ����ѵ������
for i = 1 : nFaces
    for j = 1 : nPerson
        % ����ѵ������
        if bTest == 0 
            strPath='Data/Train/';
            %��ȡ��������
        else
            strPath='Data/Test/';
        end
        %��˳��д��ͼƬ·��
        if j < 10
            strPath=strcat(strPath,'00',num2str(j),'-0',num2str(i),'.bmp');
        elseif j < 100
            strPath=strcat(strPath,'0',num2str(j),'-0',num2str(i),'.bmp');
        elseif j >= 100
            strPath=strcat(strPath,num2str(j),'-0',num2str(i),'.bmp');
        end
        
        %��ȡͼƬ
        img=imread(strPath);
        %��ͼƬ���ݴ���FaceContainer����ǩ����faceLabel
        FaceContainer((i-1)*nPerson+j, :) = img(:)';
        faceLabel((i-1)*nPerson+j) = i;
    end
end
%����FaceContainerΪMat/FaceMat.mat�ļ�
save('Mat/FaceMat.mat', 'FaceContainer')




