%% �ýű��о�����ƥ���ϸ�ڡ����ֱ�ʹ�û���غ;���ķ���
% С���⣺imshow��С�ľ���ʱ����ʾ�����С����ηŴ󣿣������������subplot��
n = 11;  m = 3;
A=eye(n);
B=A(:,end:-1:1);
C=A+B; C((n+1)/2, (n+1)/2)=1;
a = eye(m);
b = a(:, end:-1:1);
c = a+b;c((m+1)/2, (m+1)/2)=1;
subplot(121),imshow(c),title('ģ��(3x3)'), subplot(122), imshow(C),title('ԭͼ(11x11)');
%% ʵ��һ��ʹ���Դ��������һ������غ�������normxcorr2:
cross_corr0 = normxcorr2(c, C);
cc_abs = abs(cross_corr0);
imshowsub(c,C,cc_abs);title('��һ������ؾ���');
% ͨ���۲��֪������ؾ���ֵΪ1ʱΪ���ƥ��㣬���Կ�����ƥ���������ꡣ
[x_peak, y_peak] = find(cc_abs == max(cc_abs(:)));
x = x_peak - (m-1);
y = y_peak - (m-1);
imshow(C),hold on;
rectangle(gca,'Position',[x, y, m,m],'EdgeColor','r');
%% ʵ���ʹ����ʦ�ķ�����������Ҷ�任���һ������غ���
% �۲���ۣ���u=5,v=5 ��������С���ģ��һ��ʱ��fc_abs�������ֵΪ5��Ӧ��������fc_abs������ֵ������
% ��ʱfc_abs����������������ֵ������
% ��ˣ�����ÿ��u, v ����Ӧ�ý�fc_abs����ĺʹ���õ㻥��غ�������Ӧ��ʹ��fc_abs�������ֵ������
I1 = c;
I2  = C;
I1(m+m-1, m+m-1) = 0; %ע�⣺��(m+m-1)��fft
F1 = fftshift(fft2(I1));
search_step = 1;
for u = 1: search_step: n-m+1
    for v = 1: search_step: n-m+1
        % for u = 5
        %     for v = 5
        % for u = 1
        %     for v = 1
       % Fourier Transform
        I2_patch = I2(u:u+m-1, v:v+m-1);
        I2_patch(m+m-1, m+m-1) = 0; %ע��۲�u = 5, v = 5��С��
        F2 = fftshift(fft2(I2_patch));
        %fftshow(F1), fftshow(F2);
        Fc = conj(F1).* F2;  %Ϊʲô�ǵ��
        fc = ifft2(Fc);
        fc_abs = abs(fc);
        %         ����ʱʹ�ã�
        %         imshowsub(I1, I2_patch, fc_abs);imshow(fc_abs,[]);
        %         subplot(121), imshow(I2_patch);subplot(122), imshow(I1),  title(['u:',num2str(u),'   v:', num2str(v)]);
        %         pause(0.2);
        Cross_corr= max(fc_abs(:));
        sum_patch = sum(sum(I2_patch));  %#############ע�⣺������ЩС��ȫ�ڣ�����ֵ֮��Ϊ�㡣�ʿ���������ֵ
        if sum_patch <1
            Measure(u, v) = 0;
        else
            Measure(u, v) = Cross_corr/sqrt(sum_patch);
        end
        clear Cross_corr ave_patch;
    end
end
[x1, y1] = find(Measure == max(Measure(:))); %ע�⣺find�����������Է��ص��±������������Է��ض��±���������
imshow(C);
rectangle('Position',[x1, y1, m, m],'EdgeColor','r');

%% ʵ����������ʹ�þ��һ�������� (�����������޷����ں��յĴ���Ӧ���ǲ��û����ͼ������)
close all;
% conv = conv2(C, c);
% subplot(121),imshow(C),subplot(122),imshow(conv,[]);
% for i = 1 : 10
%     conv = conv2(conv, c, 'same');
%     subplot(121),imshow(C),subplot(122),imshow(conv,[]); pause(0.5); title(['��',num2str(i),'����...']);%�ƺ�ûʲôЧ��
% end
conv_Cc = conv2(C, c ,'same');
[conv_x, conv_y] = find(conv_Cc == max(conv_Cc(:)));
x_m3 = conv_x - .5*(m+1); % method_3
y_m3 = conv_y - .5*(m+1);
subplot(121), imshow(C), subplot(122), imshow(C), hold on;
rectangle('Position',[x_m3, y_m3, m, m],'EdgeColor','r');
%%  ʵ���ģ�����ʹ�þ������С�����
% I1 = c;
% I2  = C;
% search_step = 1;
%  for u = 1: search_step: n-m+1
%      for v = 1: search_step: n-m+1
% for u = 5
%     for v = 5
%                 I2_patch = I2(u:u+m-1, v:v+m-1);
%                 conv0 = conv2(I2_patch, I1);
%                 subplot(131),imshow(I1),subplot(132),imshow(I2_patch);
%                 subplot(133), imshow(conv0, []); pause(0.5);
%     end
% end
I1 = c;
I2  = C;
search_step = 1;
for u = 1: search_step: n-m+1
    for v = 1: search_step: n-m+1
        I2_patch = I2(u:u+m-1, v:v+m-1);
        conv_matrix2 = conv2(I1, I2_patch, 'same');
        % ��ȣ�
        conv_max= max(conv_matrix2(:));
        sum_patch = sum(sum(I2_patch));  %#############ע�⣺������ЩС��ȫ�ڣ�����ֵ֮��Ϊ�㡣�ʿ���������ֵ
        Measure(u, v) = conv_max/sqrt(sum_patch);
        clear conv_max ave_patch;
    end
end
[x1, y1] = find(Measure == max(Measure(:))); %ע�⣺find�����������Է��ص��±������������Է��ض��±���������
imshow(C);
rectangle('Position',[x1, y1, m, m],'EdgeColor','r');


