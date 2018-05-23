%% �ýű�ʵ��cousera�Ͻ����JPEG���ֿ顪DCT��������iDCT
%ע�⣺
% 1. blockproc���������ͼ����ߴ������������ֳɵ�С��n��������Զ������ߴ�
% Ҳ���������Ĵ������ж����һ�㣬������n
% 2. ������JPEG����ʱΪɶ����ʹ��round?����������ȡ������

%% ʵ��1��ֱ�ӷ��任
close all; clear;
I = imread('road.tif');
I1 = double(rgb2gray(I));
% figure, imshow(I1,[]);
fun_dct = @(block_struct) dct2(block_struct.data);
I_dct = blockproc(I1, [8, 8], fun_dct);
% imshow(abs(log(I_dct)));
fun2 = @(block_struct) idct2(block_struct.data);
I_idct = blockproc(I_dct, [8, 8], fun2);
% figure, imshow(I_idct,[]);
error_image  = I1 - I_idct; 
imshowsub(I1, I_idct, error_image)
%% ʵ��2����DCTϵ����������
close all; clear;
I = imread('road.tif');
I1 = double(rgb2gray(I));
I1 = imresize(I1,[688, 1024]);
figure, imshow(I1,[]);
fun_dct = @(block_struct) dct2(block_struct.data);
T = blockproc(I1, [8, 8], fun_dct);
% mask=[1 1 1 1 1 1 1 1            %������ģ������һ���ָ�Ƶ����
%     1 1 1 1 1 1 1 1
%     1 1 1 1 1 1 1 1
%     1 1 1 1 1 1 1 1
%     1 1 1 1 1 1 1 0
%     1 1 1 1 1 1 0 0
%     1 1 1 1 1 0 0 0
%     1 1 1 1 0 0 0 0];
% T = blockproc(T, [8, 8], @(block_struct) mask.*block_struct.data);
% imshow(abs(log(I_dct)));
% ������������Q
Q = [16 11 10 16 24 40 51 61
    12 12 14 19 26 58 60 55
    14 13 16 24 40 57 69 56
    14 17 22 29 51 87 80 62
    18 22 37 56 68 109 103 77
    24 35 55 64 81 104 113 92
    49 64 78 87 103 121 120 101
    72 92 95 98 112 100 103 99];
Q = 4*Q; %����ϵ����ʵ�ֲ�ͬ�̶ȵ�ѹ������ѹ���ʣ�
fun_quantize = @(block_struct) round(block_struct.data./Q).*Q; %ע�⣬������ceil��floor�����У���
T_quantized = blockproc(T, [8, 8], fun_quantize); 
fun_invDCT = @(block_struct) idct2(block_struct.data);
f_idct = blockproc(T_quantized, [8, 8], fun_invDCT);
%   imshowsub(I1, f_idct);
error_image  = I1 - f_idct; 
figure, imshow(error_image,[])
imshowsub(I1, f_idct, error_image)
%% ʵ��3 RGB-->Ycbcr, ����Yѹ���ʣ������cb��crͨ����ѹ���ʹ۲���

