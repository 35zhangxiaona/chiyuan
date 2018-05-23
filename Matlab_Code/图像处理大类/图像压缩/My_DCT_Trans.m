function [B, F] = My_DCT_Trans(I)
T = dctmtx(8); %��д��DCT�ı任�ˣ��̶���
% mask = [1   1   1   1   0   0   0   0  % ѡ��һ������(masking)��ʽ��������ֱ��ϵ����ǰ�Ÿ�����ϵ��           
%     1   1   1   0   0   0   0   0            %�����Ͻ�Ϊֱ��ϵ����
%     1   1   0   0   0   0   0   0            % ע��: δ�����ĸ�Ƶϵ�������������ﵽͼ��ѹ����Ŀ��
%     1   0   0   0   0   0   0   0            % Ϊ�˹۲��ͨ�˲�Ч������δʹ��mask
%     0   0   0   0   0   0   0   0
%     0   0   0   0   0   0   0   0
%     0   0   0   0   0   0   0   0
%     0   0   0   0   0   0   0   0];
mask = ones(8,8); mask(4:6,4:6)=0;
fun = @(block_struct)  T * block_struct.data * T'; %DCT���任��T*B*T' , ����BΪ���任��ͼ���
B = blockproc(I, [8, 8], fun); %������ͼ��I���зֿ鴦��ͬʱ��DCT�任
% F = B;
fun2 = @(block_struct) mask .*  block_struct.data; % ����ÿ��С����ָ��һ���ָ�Ƶ������ʵ��ѹ��
F = blockproc(B, [8, 8], fun2); 
end