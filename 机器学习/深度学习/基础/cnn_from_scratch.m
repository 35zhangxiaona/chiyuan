% function [cost, grad, preds] = cnnCost(theta,images,labels,numClasses,...
%                                 filterDim,numFilters,poolDim,pred)

%  �ο���http://www.cnblogs.com/dmzhuo/p/5142438.html
%-------------------------------------------�����ò���-----------------------------------
numClasses = 10;  % Number of classes (MNIST images fall into 10 classes)
   % Pooling dimension, (should divide imageDim-filterDim+1)
imageDim = 28;
% Load MNIST Train
addpath ..\rb
addpath ..\ex1
images = loadMNISTImages('..\rb\train-images.idx3-ubyte');
images = reshape(images,imageDim,imageDim,[]);
labels = loadMNISTLabels('..\rb\train-labels.idx1-ubyte');
labels(labels==0) = 10; % Remap 0 to 10
numFilters = 2;
   filterDim = 9;
    poolDim = 5;
    images = images(:,:,1:10);
    labels = labels(1:10);
% Initialize Parameters
theta = cnnInitParams(imageDim,filterDim,numFilters,poolDim,numClasses);
%---------------------------------------------------------------------------------------------
%%
% Calcualte cost and gradient for a single layer convolutional
% neural network followed by a softmax layer with cross entropy
% objective.
%
% Parameters:
%  theta      -  unrolled parameter vector
%  images     -  stores images in imageDim x imageDim x numImges
%                array
%  numClasses -  number of classes to predict
%  filterDim  -  dimension of convolutional filter
%  numFilters -  number of convolutional filters
%  poolDim    -  dimension of pooling area
%  pred       -  boolean only forward propagate and return
%                predictions
%
%
% Returns:
%  cost       -  cross entropy cost
%  grad       -  gradient with respect to theta (if pred==False)
%  preds      -  list of predictions for each example (if pred==True)


if ~exist('pred','var')
    pred = false;
end;


imageDim = size(images,1); % height/width of image
numImages = size(images,3); % number of images

%% Reshape parameters and setup gradient matrices

% Wc is filterDim x filterDim x numFilters parameter matrix
% bc is the corresponding bias

% WcΪ�������˲�������9,9,2����������9*9��feature 
% WdΪsoftmax��Weighs������(10*32)����pooled features��obj��ԭ����4-D��(4,4,2,10)reshape��(32, 10)��
% Ȼ����Weighs������ˣ��ټ���numClasses��bias

% Wd is numClasses x hiddenSize parameter matrix where hiddenSize
% is the number of output units from the convolutional layer
% bd is corresponding bias
[Wc, Wd, bc, bd] = cnnParamsToStack(theta,imageDim,filterDim,numFilters,...
    poolDim,numClasses);

% Same sizes as Wc,Wd,bc,bd. Used to hold gradient w.r.t above params.
Wc_grad = zeros(size(Wc));
Wd_grad = zeros(size(Wd));
bc_grad = zeros(size(bc));
bd_grad = zeros(size(bd));

%%======================================================================
%% STEP 1a: Forward Propagation
%  In this step you will forward propagate the input through the
%  convolutional and subsampling (mean pooling) layers.  You will then use
%  the responses from the convolution and pooling layer as the input to a
%  standard softmax layer.

%% Convolutional Layer
%  For each image and each filter, convolve the image with the filter, add
%  the bias and apply the sigmoid nonlinearity.  Then subsample the
%  convolved activations with mean pooling.  Store the results of the
%  convolution in activations and the results of the pooling in
%  activationsPooled.  You will need to save the convolved activations for
%  backpropagation.
convDim = imageDim-filterDim+1; % dimension of convolved output
outputDim = (convDim)/poolDim; % dimension of subsampled output

% convDim x convDim x numFilters x numImages tensor for storing activations
% ����Ľ��������activations��
activations = zeros(convDim,convDim,numFilters,numImages);

% outputDim x outputDim x numFilters x numImages tensor for storing
% subsampled activations          %����ػ�֮��Ľ��
activationsPooled = zeros(outputDim,outputDim,numFilters,numImages);

%%% YOUR CODE HERE %%%
% ����ֱ�ӵ���cnnConvolve���������Ҳ�����Լ���ϰһ�飨ע��rot90������������sig��bias��
% activations0 = cnnConvolve(filterDim, numFilters, images, Wc, bc);
for i = 1:numImages
    for j = 1: numFilters
        im = images(:,:,i);
        feature_filter = rot90(Wc(:,:,j),2);
        conved_im = conv2(im, feature_filter, 'valid');
        activations(:,:,j,i) = sigmoid(conved_im+bc(j));
    end
end
activationsPooled = cnnPool(poolDim, activations);
% Reshape activations into 2-d matrix, hiddenSize x numImages,
% for Softmax layer
% ��һ��ʵ���ǽ�����ػ�֮��Ľ������flatten�����softmax��Data����ʽ
% ע�⣺����ѭ�����о���ͳػ�����֤flatten֮�������ά��������̫��
activationsPooled = reshape(activationsPooled, outputDim^2*numFilters, numImages);

%% Softmax Layer
%  Forward propagate the pooled activations calculated above into a
%  standard softmax layer. For your convenience we have reshaped
%  activationPooled into a hiddenSize x numImages matrix.  Store the
%  results in probs.

% numClasses x numImages for storing probability that each image belongs to
% each class.
probs = zeros(numClasses,numImages);

%%% YOUR CODE HERE %%%
y_hat = Wd * activationsPooled + bd;
h = exp(y_hat);  % ǰ�򴫲��������x(i)��Ӧ��h��(x)������exp��sigmoid�򻯣�
probs = h./sum(h, 1);  %
%��һ�γ��Դ���
% theta_sftmx = 0.005 * randn(numClasses*imageDim^2, 1);
% %����softmax��thetaӦ���Ƕ��٣����³�ʼ����
% lambda = 1e-4;
% options = struct('MaxIter', 200);
% theta(:)=minFunc(@softmax_regression_vec, theta_sftmx(:), options, activationsPooled, labels');
%%======================================================================
%% STEP 1b: Calculate Cost
%  In this step you will use the labels given as input and the probs
%  calculate above to evaluate the cross entropy objective.  Store your
%  results in cost.
cost = 0; % save objective into cost

%%% YOUR CODE HERE %%%
lambda = 1e-4; %������ͷ���ϵ��
groundTruth_label = full(sparse(labels, 1:numClasses, 1));
% cost  = -1/numImages * groundTruth_label(:)' * log(probs(:)) + lambda * (sum(Wd(:).^2) +sum( Wc(:).^2));
cost  = crossentropy(groundTruth_label, probs) + lambda * (sum(Wd(:).^2) +sum( Wc(:).^2));
% ����ʹ���Դ�����crossentropy(groundTruth_label, probs)����-1/numImages *
% groundTruth_label(:)' * log(probs(:))  ǰ�߽��Ϊ0.2610�����߽��Ϊ0.260978

%-----------------------------------------------------------
%���ϴ𰸣�
% weightDecay = 0.0001;
% logProbs = log(probs);   
% labelIndex=sub2ind(size(logProbs), labels', 1:size(logProbs,2));  %�е����ƽ�1*10��labelת����10*10��one-hot����������ȡ����1��Ӧ������
% %�ҳ�����logProbs����������������labelsָ��������1:size(logProbs,2)ָ�������������������ظ�labelIndex
% values = logProbs(labelIndex);  
% cost = -sum(values);
% weightDecayCost = (weightDecay/2) * (sum(Wd(:) .^ 2) + sum(Wc(:) .^ 2));
% cost = cost / numImages+weightDecayCost; 


% Makes predictions given probs and returns without backproagating errors.
if pred
    [~,preds] = max(probs,[],1);
    preds = preds';
    grad = 0;
    return;
end;

%%======================================================================
%% STEP 1c: Backpropagation
%  Backpropagate errors through the softmax and convolutional/subsampling
%  layers.  Store the errors for the next step to calculate the gradient.
%  Backpropagating the error w.r.t the softmax layer is as usual.  To
%  backpropagate through the pooling layer, you will need to upsample the
%  error with respect to the pooling layer for each filter and each image.
%  Use the kron function and a matrix of ones to do this upsampling
%  quickly.

%%% YOUR CODE HERE %%%
% ��SOFTMAX ERROR:
softmaxError = probs - groundTruth_label;
% �� I.����ػ����������(3)
%------------------------------------------------------------------------------------------------------------------------------------------------------------
%ע�⣺
% pooledError = Wd' * softmaxError .* (activationsPooled.*(1-activationsPooled)); % %�����һ��ֱ���õĳػ�����
%Ӧ�ý��ػ������������򴫲����������ػ��㣬��ɾ��������
%��������������������������������������ʾ��ͼ�У���ô˵�ǲ���Ӧ���þ��������������Ǿ���ػ��������������hidden
%layer����Ԫ������������������������������������������
%-------------------------------------------------------------------------------------------------------------------------------------------------------------
pooledError = Wd' * softmaxError;
pooledError = reshape(pooledError, outputDim, outputDim, numFilters, numImages);
% II. ���ػ�֮�������(2) upsample�ɳػ�ǰ�ĳߴ磨convolved feature map�����������
unpoolError = zeros(convDim, convDim, numFilters, numImages);
for i = 1:numImages
    for j = 1:numFilters
        unpoolError(:, :, j, i) = 1/poolDim^2 * kron(pooledError(:, :, j, i), ones(poolDim));
    end
end
convError = unpoolError .* activations .* (1 - activations); %����ʱ����Կ���һ����Ԫ��ÿ��ֵ����ÿ���ڵ�Ħ�
%%======================================================================
%% STEP 1d: Gradient Calculation
%  After backpropagating the errors above, we can use them to calculate the
%  gradient with respect to all the parameters.  The gradient w.r.t the
%  softmax layer is calculated as usual.  To calculate the gradient w.r.t.
%  a filter in the convolutional layer, convolve the backpropagated error
%  for that filter with each image and aggregate over images.

%%% YOUR CODE HERE %%%
% softmax�ݶȣ�
Wd_grad = 1/numClasses * softmaxError * activationsPooled' + lambda * Wd;
bd_grad = 1/numClasses * sum(softmaxError, 2);
% Gradient of the convolutional layer


Wc_filter = zeros(size(Wc));
bc_grad = zeros(size(bc));
%����bc_grad
for filterNum = 1 : numFilters
 %  ��(l)���Ӿ���������ֱ����
  bc_grad(filterNum) = (1/numImages) * sum(sum(sum(squeeze(convError(:,:, filterNum,:))))); 
end
% ����Wc_grad
%ע�⣬����ÿ������˶�Ӧ�ݶ�ʱ��Ҫ������example��ԭͼ��ĵľ��������
for i = 1 : numFilters
    for j = 1 : numImages
        %???????????���⣺Ϊʲô����תdelta_conv����������ת�������һ�εļ��������Ｔԭͼ��???????????
        Wc_filter(:, :, i) =Wc_filter(:, :, i) + conv2(images(:,:,j), rot90(convError(:, :, i, j), 2), 'valid');
    end
end
Wc_grad =1/numClasses * Wc_filter + lambda * Wc;
%% Unroll gradient into grad vector for minFunc
grad = [Wc_grad(:) ; Wd_grad(:) ; bc_grad(:) ; bd_grad(:)];
% end
