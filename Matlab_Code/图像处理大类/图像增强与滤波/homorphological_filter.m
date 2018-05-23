%% Ƶ�����̬ͬ�˲�����most commonly used for correcting non-uniform illumination in images.
% The illumination-reflectance model of image formation: intensity at any pixel,is the product of the illumination of the scene and the reflectance(������) of the object(s) in the scene,i.e.
% ������ I(x,y)=L(x,y)*R(x,y); ���У�IΪͼ��LΪscene illumination���ֳ��նȣ��� RΪ scene reflectence.
% ��̬ͬ�˲����� ȥ��ͼ����ӵ��ĳЩ���Եĳ����������� we use a high-pass filter in the log domain to 
% remove the low-frequency illumination component while preserving the high-frequency reflectance component.
close all;
clear;
a=imread('trees.tif');imshow(a);
ad=im2double(a);
ad1=log(ad+0.01);
% adflog=fftshift(fft2(ad1));
adflog=fft2(ad1);
f=butterhp(a,15,1);
adfiltered=f.*adflog;
fftshow(adfiltered);
h=real(ifft2(adfiltered));%Ϊʲôȡʵ��������
figure,imshow(h);
h1=exp(h);%�ǵ���ָ��������ת����ȥ
figure,ifftshow(h1);

