%% �ýű�ʵ��ֱ��ͼ���⻯������matlab�Դ���histeq�������жԱ�
% �ܽ�
% 1.����ʹ��[count,gray_level]=imhist(I) ����ػ��ͼ��I�ĻҶȼ��Լ���Ӧ�Ҷȼ�����������
% 2. ����ʹ��cumsum����ֱ�ӻ�ȡ������ۼ�
% 3. ע����ѭ��������û������ͬʱ���£��ȸ��µ�ֵ�ֲ��뵽���ĸ����е��´�������һ������
% 4. �Ż���ʹ��arrayfun()���������о���Ԫ��ʹ��ͬһ���������㣬����ѭ��
close all;clear;
dbstop if error
I = imread('dark.jpg');
[m, n] = size(I);
imhist(I),figure,imshow(I),title('Original Image');
[count,gray_level]=imhist(I);
gray_list = unique(sort(I(:)));
L = length(gray_list);
% num_gray = size(find(I==gray_list),1).*size(find(I==gray_list),2);
%���⣺����е�find(I==gray_list)����þ�������ʵ�֣���һ���������ʵ�֣��������һ��������ʸ������ʵ��,����ѭ����
num_gray = zeros(L,1);
% for i = 1:L
% %     num_gray(i) = size(find(I==gray_list(i)),1)*size(find(I==gray_list(i)),2); %ɵ��д��...
% num_gray(i) = length(find(I==gray_list(i)));
% end
%% �𰸣�ʹ��arrayfun() ���������о���Ԫ��ʹ��ͬһ���������㡣
% f = @(i) length(find(I == gray_list(i))); %����д��...
f = @(x) length(find(I == x));
num_gray = arrayfun(f, gray_list);
%%
probability_gray = num_gray/(m*n);
for j = 1:L
probability_accumulated(j) = sum(probability_gray(1:j)); %����ʹ��cumsum������������ۼӲ���
end
probability_accumulated = probability_accumulated';
gray_equalized = round(probability_accumulated*256);
% �������ԭ��д���ǣ�
% for k = 1:L
% I(find(I == gray_list(k))) = gray_equalized(k); 
% end
% �������ڣ�I��ĳ���Ҷȼ�150��������֮����158��Ȼ��I�лҶȼ�Ϊ158���ֱ����⻯Ϊ�µĻҶȼ�208
% ����I��ĳЩֵ�����ѱ��޸ģ�������ѭ�����У��ٴα��޸ģ������ǲ�ϣ��������==>����I1����I�ĻҶ�ֵ
% ������֤I�е�ÿ������ֻ���޸�һ�Σ�������I1.
I1 = zeros(m,n);
for k = 1:L
I1(find(I == gray_list(k))) = gray_equalized(k); 
end
%
figure, imhist(uint8(I1));
figure, imshow(uint8(I1)),title('Equalized Image')
load handel;
sound(y,Fs); 
