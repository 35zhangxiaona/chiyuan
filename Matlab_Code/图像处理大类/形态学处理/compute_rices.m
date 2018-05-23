%%����rice.png���м�������

I=imread('rice.png');
%% �Զ������ֵ��תΪ��ֵͼ��
level1=graythresh(I);
I1=im2bw(I,level1);
imshowpair(I,I1);

%% ȥ������
background=imopen(I,strel('disk',15));imshow(background);
I2=I-background; %I2=imsubtract(I,background);
imshowpair(I,I2)

%% ��ȥ��������ͼ��תΪ��ֵͼ��
level2=graythresh(I2);I3=im2bw(I2,level2);
imshowpair(I,I3);%�ɼ���ͼ������������������sparkle����Ӱ�������ļ������� ʹ�ü򵥵���ֵ�˲�ȥ��

%% �����˲���ʽ�Ƚ�
 h=[0 0.1 0;0.1 0.1 0.1 ;0 0.1 0];
K=imfilter(I3,h);imshowpair(I,K);

%% �ٶ��˲����ͼ����һ��
K1=imfilter(K,[0 -1 0;-1 5 -1 ;0 -1 0]);imshowpair(K,K1);% ����ûʲôЧ��..

%% connected-component labeling����ͼ���е���ͨ�������±�Ų�����
[labeled, numObjects]=bwlabel(K,8);
stats=regionprops(labeled,'BoundingBox');
for i=1:numObjects
    box=stats(i).BoundingBox;
%     x=box(1);%��������X
%     y=box(2);%��������Y
%     w=box(3);%���ο��w
%     h=box(4);%���θ߶�h
     rectangle('Position',[box(1,1),box(1,2),box(1,3),box(1,4)],'EdgeColor','r');
end

%% ������������ĳߴ��ƽ���ߴ�
% ��ʵ���������find()����һЩ
[m,n]=size(I);
num=zeros(numObjects,1);
for i=1:m
    for j=1:n
        for k=1:numObjects
            if (labeled(i,j)==k)
                num(k)=num(k)+1;
            end
        end
    end
end
% ���⣺����������������������Ϊ��һ������ô����� 
% ԭ�� ��ֵ�˲���ͼ�������ģ��.���˲�������ֵ��С���Էֿ����������������ǻᵼ��ͼ����С��������ʧ�����һ�ʹ�����������ϳ�����
% �ܽ᣺ͼ���񻯵�ʹ����δ���ա�
%��ʵ���Բ�����ֵ�˲��������øߵ�������ֵ���˳�������߹�С������

    