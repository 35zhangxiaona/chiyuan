%% �����Կռ��˲�ʵ������������˹�񻯽���ͼ����ǿ
% ע�⣺imfilter���صĽ�����ͺ�����ͬ�࣬���������Ϊuint8�࣬������ܻ���Ϊ�������붪ʧ���ȡ�
% ����ʹ��imfilter֮ǰ��ý�ͼ��ת��Ϊ������
% ע�⣺����ģ�������ϵ��Ϊ�������������յ�ͼ��Ӧ��Ϊ��ԭͼ���ȥ��ǿ���laplacianͼ��
% �ɼ���ͨ����laplacian�񻯣�ͼ���ϸ�ڵõ�������ǿ
i = imread('moon.tif');
i= im2double(i);
%% ʵ��һ��ʹ���м�����Ϊ-4 ��������˹��ģ��
w = fspecial('laplacian',0);
i1 = imfilter(i, w, 'replicate'); %w1Ϊ���͵�������˹ͼ��
figure, imshow(i1,[]),title('laplacian image');
img_enhanced = i - i1;
figure, imshowpair(i, img_enhanced,'montage')
%% ʵ�����ʹ���м�����Ϊ-8��������˹��ģ��
% ���⣺Ϊɶ���-4��ģ��û�����Ե���ߣ�
w1 = [1 1 1 ; 1 -8 1; 1 1 1];
i2 = imfilter(i, w1, 'replicate');
figure, imshow(i2,[]),title('laplacian image');
img_enhanced2 = i - i2;
figure, imshowpair(i, img_enhanced2,'montage')
figure,imshowpair(img_enhanced,img_enhanced2,'montage')
