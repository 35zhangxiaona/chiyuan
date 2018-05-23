%% ���ű�ѧϰʹ��blockproc�����Ծ�����зֿ鴦������ѭ�����ɽ�ʡ����ʱ��
fun = @(block_struct) repmat(block_struct.data,5,5) ;
%ע�⴦��������������ǽṹ�壬��data�������ǵľ������ݣ�������blockproc�ֿ��Ļ��ƾ���
blockproc('moon.tif',[16 16],fun,'Destination','moonmoon.tif'); % ����ͨ��'Destination'��һѡ��������ͼ��ֱ�ӱ��汾��
imshow('moonmoon.tif');
%% ��ͼ��ÿ��С����С
i1 = imread('pears.png');
fun = @(block_struct)imresize(block_struct.data, 0.15);
i2 = blockproc(i1, [100 100], fun);
i3 = imresize(i1, 0.15);
imshowsub(i1, i2, i3)
%% ��ÿС��ı�׼������С������ֵ
i1 = imread('moon.tif');
fun2 = @(block_struct) std2(block_struct.data) * ones(size(block_struct.data)); % std2(a) ����a�ı�׼�һ������
i2 = blockproc(i1,[32,32], fun2);
imshow(i2,[])
%% ��RGBͼ��ת����GRBͼ��...
i1 = imread('peppers.png');
fun3 = @(block_struct) block_struct.data(:, :, [2 1 3]);
i2 = blockproc(i1, [200 200], fun3);
i3 = i1(:,:,[2,1,3]);
isequal(i2, i3)
imshowsub(i1, i2, i3)
%% ���������ͼ���tiff��ʽת��ΪJPEG 2000 ��ʽ
fun4 = @(block_struct) block_struct.data;
blockproc('largeImage.tif',[1024 1024],fun4,...
   'Destination','New.jp2');
