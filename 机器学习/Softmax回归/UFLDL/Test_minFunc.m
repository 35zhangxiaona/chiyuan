%% ע�⣺������minFunc���ܽ��յĺ���fun1 �����������������(y �Լ�y �ĵ���)���������������������
x0 = 1.5;
% options = struct('Newton', 200);
 [x,fval,exitflag,output]  = minFunc(@fun1,  x0);
 fprintf('didiu');
function [y,y_] = fun1(x)
y = (x - 2)^2;
% y_ = 2*(x-2);
y_ = 2;
end
