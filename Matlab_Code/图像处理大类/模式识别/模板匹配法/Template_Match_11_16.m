% ����һ�� �ȶԻҶ�ͼ����д����������ʾrgbͼ��
% clear all;close all;clc;
I1 = double(rgb2gray(imread('template_cg.jpg')))/255;
I0 = imread('group_pic.jpg');
I2 = double(rgb2gray(I0))/255;
m = size(I1, 1); n = size(I1, 2);
M = size(I2, 1); N = size(I2, 2);
Measure = zeros(M-m+1, N-n+1);
%%
I1(m+n-1, m+n-1) = 0; %ע�⣺��(m+n-1)��fft
F1 = fftshift(fft2(I1));
search_step =10;
for u = 1: search_step: M-m+1  %%##
    for v = 1: search_step: N-n+1
% for u = 56
%     for v = 146
% for u = 106 %ǽ��
%     for v = 1066
% for u = 271 % ��Զ
%     for v = 241
% for u = 226 %����
%     for v= 434
% for u = 421
%     for v = 71
         fprintf('Now excuting row: %d, colom: %d \n', u, v);
        %% Fourier Transform
        I2_patch = I2(u:u+m-1, v:v+n-1);
        I2_patch(m+n-1, m+n-1) = 0;
        F2 = fftshift(fft2(I2_patch));
        Fc = conj(F1).* F2;  %Ϊʲô�ǵ��
        fc = ifft2(Fc); %fc ��һ����ά�ĸ�������δ����ȳ���ֱ��ȡģ��
        fc_abs = abs(fc);
        % ����ʱʹ���¾����visualize��
%         subplot(121), imshow(I1);subplot(122), imshow(I2_patch);title(['u:',num2str(u),'   v:', num2str(v)]);
%         pause(0.05);
           
        %         Cross_corr= max(fc_abs(:));      
        sum_patch = sum(sum(I2_patch));  %#############ע�⣺������ЩС��ȫ�ڣ�����ֵ֮��Ϊ�㡣�ʿ���������ֵ
       %%%%%%%%%%%%%%���⣺ ʶ������ױ���λ�����Ⱥܸߵĵط�����ǽ�ڴ���������%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%��ˣ����ǽ�fc_abs�ĳ������ƽ��������������ȵ�Ӱ��%%%%%%%
       %%%%%%%%%%%%%%%��ˣ��������ĵ�������ʹ��        fc_t =fc_abs/sqrt��sum_patch);
        fc_t =fc_abs/sum_patch;
            Measure(u, v) = max(max(fc_t));
        clear fc_abs ;
    end
end
%%
[x1, y1] = find(Measure == max(Measure(:)));
imshow(I0);
% rectangle('Position',[x1, y1, n, m],'EdgeColor','r');
rectangle('Position',[y1, x1, n, m],'EdgeColor','r');