%% �ýű�Ϊ��ʮ���±����ҵ����ʵ��DCT�任 ����DCT��ʾ��ͨ�˲���ͼ����ǿ����
%% Ҫ�㣺
% 1.��DCTͬFFT��ȣ����� ������Ƶ����ĸ�ͨ�˲� 
% 2.blockproc������ʹ�� 
% 3. DCT��ʵ�֣�T *B* T'; ��DCT��ʵ��: T' *B* T���Լ�ͨ��mask������Ƶ����ʵ��ͼ��ѹ��
% ע�⣺��ÿһС����и�ͨ�˲�֮��Ч��������������, ����м䲿��ֱ��ʹ������ͼ��DC
I = imread('cameraman.tif');
I_gray = double(I);
% imshow(I2);
[B, F]= My_DCT_Trans(I_gray);
% B = ifftshift(B);
% F = ifftshift(F);
imshowsub(log(abs(B(1:8,1:8))), log(abs(F(1:8,1:8)))); title('��ͨ�˲�ǰ���Ƶ�ף�һС�飩');
inverse_DCT = My_iDCT(F);
 figure, imshowpair(I_gray, inverse_DCT,'montage');

 %% ������ͼ����DCT
 close all; clear;
I = imread('xu.jpg');
I= imresize(I,[480,480]);
I = imrotate(I, -90);
I_gray = im2double(rgb2gray(I));
[k,l]=size(I_gray);
T = dctmtx(480);
F = T*I_gray*T';
F = fftshift(F);
B = F; 
% B(2/5*k:3/5*k,2/5*l:3/5*l)=0; 
B(4/9*k:5/9*k,4/9*l:5/9*l)=0;
imshowsub(log(abs(F)), log(abs(B))); title('��ͨ�˲�ǰ���Ƶ��');
inversed0 = T' *F * T;
inversedDCT = T' *B * T;
figure, imshow(inversed0), title('ֱ����DCT���任');
figure, imshow(I_gray),title('DCT��ͨ�˲�֮ǰ');
figure, imshow(inversedDCT), title('DCT��ͨ�˲�֮��')
