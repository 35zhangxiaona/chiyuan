clear all;
%����ԭʼͼ��
I=imread('01.jpg');
subplot(1,2,1);imshow(I);
title('ԭʼͼ��');
gray=rgb2gray(I);
ycbcr=rgb2ycbcr(I);%��ͼ��ת��ΪYCbCr�ռ�
heighth=size(gray,1);%��ȡͼ��ߴ�
width=size(gray,2);
for i=1:heighth %���÷�ɫģ�Ͷ�ֵ��ͼ��
    for j=1:width
        Y=ycbcr(i,j,1);
        Cb=ycbcr(i,j,2);
        Cr=ycbcr(i,j,3);
        if(Y<80 || Y>160)
            gray(i,j)=0;
        else
            if(skin(Y,Cb,Cr)==1)%����ɫ��ģ�ͽ���ͼ���ֵ��
                gray(i,j)=255;
            else
                gray(i,j)=0;
            end
        end
    end
end
%%
% se=strel('arbitrary',eye(5));%��ֵͼ����̬ѧ����
% gray0=imopen(gray,se);
% subplot(1,2,2);imshowsub(gray0,gray);title('��ֵͼ��');
se2 = strel('disk', 4); 
gray2 = imopen(gray,se2);
gray3=  bwareaopen(gray2,80); 
% gray4 = imopen(gray3,strel('disk',2));

imshowsub(gray,gray2,gray3);
E = edge(gray3,'canny');

[L,num]=bwlabel(gray3,8);%���ñ�Ƿ���ѡ��ͼ�еİ�ɫ����
stats=regionprops(L,'Eccentricity','Area','BoundingBox');%������������
A = regionprops(L,'Area');
Long = regionprops(L,'Perimeter');
Conv = regionprops(L,'ConvexArea');
eccentricities = [stats.Eccentricity]; % �����Ա��������������ͬ��׼�������ľص���Բ�������ʣ�����Ϊ������
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);
figure, imshow(I);
hold on;
for idx = 1 : length(idxOfSkittles)
    if  (A(idx).Area/Long(idx).Perimeter^2<0.796)
       
        h = rectangle('Position',statsDefects(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
    end
end










%%


