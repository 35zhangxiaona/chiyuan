%% ������д��ʹ��Normal Equation������Իع����⡣
% ���ַ�����theta�Ƚϱ�����theta_set.mat��
% ע�⣺ �ǵý�ԭʼ�����Ƚ���ϴ�ơ�����ϴ����test���ݻ�ǳ���ɢ����׼ȷ���½�
load housing.data;
temp = housing';
temp = [ones(1, size(temp, 2)); temp];
temp = temp(:, randperm(size(temp,2)));  %randperm�������ڲ�����������������������

train.X = temp(1:end - 1, 1:400);
train.y = temp(end, 1:400);
test.X = temp(1:end - 1, 401:end);
test.y = temp(end, 401:end);
%% design_matrix ���� X
X = train.X';
y = train.y' ;
theta_best = inv(X'*X)*X'*y;
actual_prices = test.y;
predicted_prices = theta_best'*test.X;
%% plot 
  [actual_prices,I] = sort(actual_prices);
  predicted_prices=predicted_prices(I);
  plot(actual_prices, 'rx');
  hold on;
  plot(predicted_prices,'bx');
  legend('Actual Price', 'Predicted Price');
  xlabel('House #');
  ylabel('House price ($1000s)');