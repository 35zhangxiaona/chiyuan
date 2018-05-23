%% 
clear;clc;close all;
I1=imread('23425.png');I2=imread('23439.png');
I1=imresize(I1,[500,600]);
I2=imresize(I2,[500,600]);
%δ���ָ�ֵ
I_diff = imabsdiff(I2,I1); 
% I_diff = imsubtract(I2,I1); 
subplot(121),imshow(I1,[]),subplot(122),imshow(I2,[]);
 level = graythresh(I_diff);
 level1=0.09;
bw = im2bw(I_diff,level);figure,imshow(bw);title('imabsdiffUint8');

%% �ɼ���õ�bwͼ���кܶ�sparkles��������ȥ�룺
% background = imopen(I1,strel('disk',15));figure,imshow(background);
% ע�⣺����ʹ��imnoise�����ֵͼ��
bw_denois=bwareaopen(bw,35); %ʹ����̬ѧ�ĺ������������ͣ�ȥ��bw������������35����ͨ��
h1=figure,imshow(bw_denois);title('ȥ����״����֮��');
%   g=imdilate(f,strel('disk',2));figure,imshow(g);
%% ���������˶��ٶȣ��Ȼ�ȡ���ص���룬Ȼ���Ҳο�������ת��
[coor1,coor2]=ginput(2); %��GUI����ʽ��ȡn�����ص�����꣨���԰�enter����ǰ��������
X=[coor1';coor2'];DIS=pdist(X); %pdist()����õ��ǽ����е������Ž�һ��n*2����ά������n*3����ά���ľ���X��
DIS_real = DIS*7.5/120.62;% �������Ӽ�����Ƚ��й��ƣ���ʵ����Ϊ
delta_T = 57.057/1368;
speed=DIS_real/(delta_T*(39-25));
fprintf('HenryVIIIʱ���ؼ��������ٶ�ԼΪ%d m/s\n',speed);

