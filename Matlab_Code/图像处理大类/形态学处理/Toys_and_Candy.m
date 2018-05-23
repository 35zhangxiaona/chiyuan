%�ó���ʵ��ͼ��Ŀ������ķָ����������÷ָ���������Ϣ���������Ŀ����Ŀ��

%%��ȡͼ��
I=imread('Toys_Candy.jpg');
imshow(I);

%% ��ͨ���ֱ�ͨ����ֵ
%���ȳ���ֱ�Ӷ�ԭrgbͼ����im2bw���� I_BW=im2bw(I,beta)��
%�ᷢ����ɫ��ǳ���ǹ�Ҳ���ɰ�ɫ����Ϣ��ʧ�������ͨ������ķ������ָ
% ����ͼ��ֳ�rgb�����������ֱ���ж�ֵת�����������͡�


% Im=double(I)/255;
r=I(:,:,1);
g=I(:,:,2);
b=I(:,:,3);

ir=im2bw(r,0.5);
ig=im2bw(g,0.5);
ib=im2bw(b,0.5);
Isum= (ir&ig&ib);  %Ϊʲô�������㣿  ע�⣺im2bw����֮��ͼ������Ϊ��ֵͼ�񣬼��߼�����

subplot(221);imshow(ir);title('Red Plane');
subplot(222);imshow(ig);title('Green Plane');
subplot(223);imshow(ib);title('Blue Plane');
subplot(224);imshow(Isum);title('Sum of all planes');

%%
%���ø�ʽ�� IM2 = imcomplement(IM)�����������ܣ� ��ͼ�����ݽ���ȡ�����㣨ʵ�ֵ�ƬЧ������
% ��������˵���� IM��Դͼ������ݣ� IM2��ȡ�����ͼ�����ݡ�
% һ���򵥵����ӣ�����X = uint8([ 255 10 75; 44 225 100]);����X2 = imcomplement(X)
% ����X2 = 0 245 180 211 30 155
% ע��㣺����1. ͼ���ļ�����uint8����ʾ256���Ҷȡ� �������ɫλͼ�� һ��������3��uint8�ֱ��ʾ�����ص�R��G��B������
% 
% ����2. uint8��ʾ�����ݷ�Χ�� 0~255��ͼ��ĵ�ƬЧ��������255 ��ȥԭͼ�����ݡ�
% 
% ImgData = imread('poput.bmp');����NegImgData = imcomplement(ImgData);����figure('Name','ͼ���ȡ������','NumberTitle','off');����subplot(121)����imshow(ImgData)����title('Դͼ��')��
% subplot(122)����imshow(NegImgData)����title('ȡ�����ͼ��')

Icomp=imcomplement(Isum);
Ifilled=imfill(Icomp,'holes');%  imfill��������ϸ�÷�
figure, imshow(Ifilled);



%%
%IM2 = imopen(IM,SE)
% performs morphological opening on the grayscale or binary image IM with the structuring element SE. 
% The argument SE must be a single structuring element object, as opposed to an array of objects. 
% The morphological open operation is an erosion followed by a dilation, 
% using the same structuring element for both operations.


se = strel('disk', 25);  %��Ҫ�� strel��structure element��Ϊ��̬ѧ���������պ�ѧϰ��̬ѧʱ����ϸ�˽⡣
Iopenned = imopen(Ifilled,se); %��̬ѧ �򿪲���������strel����
figure,imshowpair(Iopenned, I);


%% Extract features
%������������ �� region propoties

Iregion = regionprops(Iopenned, 'centroid');%�ú�������ǿ�󣬿�����ȡ��ֵͼ��Ķ�����Ϣ
[labeled,numObjects] = bwlabel(Iopenned,4);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];




%% Use feature analysis to count skittles objects
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);

figure, imshow(I);
hold on;
for idx = 1 : length(idxOfSkittles)
        h = rectangle('Position',statsDefects(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
end
if idx > 10
title(['There are ', num2str(numObjects), ' objects in the image!']);
end
hold off;




