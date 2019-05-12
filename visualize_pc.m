function visualize_pc(E)

[size1 size2] = size(E);
global imgRow;
global imgCol;
row = imgRow;
col = imgCol;

%�ж�ά���Ƿ�Ϊ20
if size2 ~= 20
   error('Can only display 20 principle components');
end;
%c1~c4��Ϊȫ0�ľ���
c1 = zeros(row,col*5);
c2 = zeros(row,col*5);
c3 = zeros(row,col*5);
c4 = zeros(row,col*5);
%c1 = E��1��5�У���c1Ϊ2000*5
c1 = E(:,1:5);
c2 = E(:,6:10);
c3 = E(:,11:15);
c4 = E(:,16:20);

composite = zeros(row*4,col*5);
composite = [c1;c2;c3;c4];

figure;
colormap(gray);
imagesc(composite);   
axis image;
m=min(min(composite));
M =max(max(composite));
%�����ɷ���������Ϊcomposite.tiff
imwrite(uint8((composite-m)*(255/(M-m))),'composite.tiff');
