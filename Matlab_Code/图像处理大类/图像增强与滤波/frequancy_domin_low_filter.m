%% ��Բ����������ͨ�˲�����ͨ���ź�
a=imread('cameraman.tif');
af=fftshift(fft2(a));
imshow(af);
fftshow(af);
%% ���ɵ�ͨ�˲���
[x, y]=meshgrid(-128:127 , -128:127);
z=sqrt(x.^ 2+y.^2);
c=z<15;
figure,imshow(c);
%% ���ź�ͨ���˲���_�ռ���ľ������(conv2)��Ƶ���򱻼�Ϊ�˻�
af1=c.*af;           % ע������
fftshow(af1);
iaf1=ifft2(af1);
ifftshow(iaf1);
% �����������ԡ�������Ϊ��ͨ�˲�����cutoff�ǳ�����
%% ����cutoff
b=z<40;
af2=b.*af;           % ע������
fftshow(af2);
iaf2=ifft2(af2);
ifftshow(iaf2);
% �ܽ᣺���ð��������˲�������ringing effect
