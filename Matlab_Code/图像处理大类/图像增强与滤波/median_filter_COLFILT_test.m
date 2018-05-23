%%�ýű�ʹ�ü��ַ���ʵ����ֵ�˲������ȽϽ��
%% Ҫ��1. ͨ��colfilt�����ֿ飨�ص�С�飬���߻������ڣ�������ͼ��ֿ촦��
% �﷨��I2 = colfilt(I, [5,5], 'sliding', @max);
% ���⣺�Ƚ�colfilt��conv2�����Ĳ�֮ͬ����
% ��ʹ��conv2��ͼ����ģ����о����ֻ��ʵ�������˲������ֵ�˲����߼�Ȩ��ֵ�˲���������ʵ�ַ������˲���
% ��ʹ��colfilt���Զ�ÿ������С��ͬʱʹ���Զ�������㣬����ʵ������ͼ������Ի�������˲���
%% Ҫ�� 2. �ڷֿ鴦��֮ǰ��������Ҫ��ȷ������ʹ���߼���������ʹ��padarray����Ԥ�����Ӷ�ʹ����ͼ��ĳߴ�����С��ߴ�
% �﷨�� padInput = padarray(input,[f f],'symmetric'); 
%% ʵ��һ����ѭ���ķ�����������������
close all; clear;
dbstop if error
I = imread('tire.tif');
figure, imshow(I,[])
I = imnoise(I, 'salt & pepper', 0.2);
figure, imshow(I,[]);
size_win = 3;
pad_I = padarray(I, [size_win, size_win]); % ����ʹ��padarray���Խ��߽紦��������Ҳ�����
% imshow(I,[])
% figure, imshow(pad_I,[])
[m, n] = size(pad_I);
step_row = 1;
step_col = 1;
block = zeros(size_win, size_win);
for i = 1:step_row :m- size_win+1
    for j = 1:step_col :n - size_win +1
        block = pad_I(i:i+2, j:j+2);
        val_median = median(block(:));
        block((size_win+1)/2, (size_win+1)/2) = val_median;
        pad_I(i:i+2, j:j+2) = block;
    end
end
denoised = pad_I(size_win+1: m-size_win, size_win + 1: n - size_win); %pad��ϲ�
figure, imshow(denoised,[]);title('ʹ��ѭ����������������')
%% ʵ�����ʹ��colfilter����ѭ��
I_denoised = colfilt(I, [3, 3], 'sliding', @median); %ע�������fun����Ϊ�������ɣ�����Ҫ����
figure, imshow(I_denoised, []);title('ʹ��colfilter����ѭ��')
%% ʵ������ʹ��matlab�Դ�����ֵ�˲�
I1 = medfilt2(I, [3, 3]);
figure, imshow(I1, []); title('ʹ��matlab�Դ���medfilt2ȥ��')


        