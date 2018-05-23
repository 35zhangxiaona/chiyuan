%% �ýű�ѧϰʹ��CVT�е���Ƶ������VideoReader�ȣ��Լ�ForegroundDetectorǰ�����
% �����������Ӵ�blob��������ͨ�����е�ʹ��
% ע�⣬�ýű�˵����CVT�Դ���ǰ��Ԥ�⺯�����м��ߵ�׼ȷ��
%% ע�⣺computer vision toolbox���и߶ȷ�װ�ԡ�һ�ֳ�����ʹ�÷����ǣ�
%%����Ԥ����һϵ��constructor��Ȼ��ʹ��step������Ҫ�����ͼ�񶪸�constructor����

% Constructor 1: VideoReader, VideoWriter, VideoPlayer����Ƶ��object
videoReader = vision.VideoFileReader('sequence.avi');
videoPlayer = vision.VideoPlayer('Name', 'sequence');  %ע��NameҪ��д
videoWriter = vision.VideoFileWriter('Traffic Detect.avi','FrameRate', videoReader.info.VideoFrameRate);
% Constructor 2: foregroundDetector object��ʼ��
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);  
% Constructor 3 Blobanalysis �����ʼ����ѡ��true��blob��������ʹ�ø÷������ڱ����м�ʹ�����
% boundingbox
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 10);
%%
% Ԥ����һ��ģ�����ڿ�������ȥ����״����
se = strel('disk', 2); % ע�⣬�������̬ѧ������Ҫ��������

% videoPlayer.Position(3:4) = [600 400];
count = 0;
while ~isDone(videoReader)
    count = count + 1;
    frame = step(videoReader);
    foreground = step(foregroundDetector, frame);
    foreground_filtered = imopen(foreground, se);
    bbox = step(blobAnalysis, foreground_filtered);
    result0 = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
        numCars = size(bbox, 1);
    result1 = insertText(result0, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    step(videoWriter, result1);
    step(videoPlayer, result1);
end
release(videoReader);
release(videoPlayer);
release(videoWriter);