%% �ýű��԰�ť��Ƶ���з�������ȡ��ť��ʱ��仯����Ϣ
clear all;clc;close all;
C1 = [121,168]; C2 = [682, 168]; % ������ťԲ������
vidobj = VideoReader('1_tablet_test_manual.mp4');
NumFrames = vidobj.NumberOfFrames;
frames = read(vidobj, [1180, 2000]); %�޸Ķ�ȡ����Ƶ֡����������������Ƶ��ʹ��[1, Inf]
numFrames = size(frames, 4);
bw = zeros(500,800, numFrames);
Cell_Behavior = cell(numFrames,3);
Flag_plot = 0;
% %% ����һ���µ���Ƶ����������
% fps = vidobj.FrameRate;
% videoName = 'test.avi';
% newobj=VideoWriter(videoName);  %����һ��avi��Ƶ�ļ����󣬿�ʼʱ��Ϊ��
% newobj.FrameRate=29.6292;
% open(newobj); %����д����Ƶ֮ǰ�����ȴ�
%%
for i = 1: numFrames
    fprintf('����ִ�е�%s֡\n',num2str(i));
    frame = imresize(frames(:,:,:,i),[500,800]);
    txt = ocr(frame(302:322,516:591)); 
    Cell_Behavior{i, 3} = txt.Text(1:6);
    %    figure,  imshow(frame);
    for r = 65:270
        for c = [20:220, 585:780]  %����Ҫ��������ͼ��ֻ������ť����������
            if frame(r, c, 1) == 255 && frame(r, c, 2) == 28 && frame(r, c, 3) == 76
                bw(r,c,i) = 1;
                
            end
        end
    end
    %     figure, imshow(frame);
    %     [x, y]=find(bw(:,:,i)==1); C_bw = [round(mean(y)), round(mean(x))];
    %     d1 = pdist([C1;C_bw]); d2 =pdist([C2;C_bw]);
    se = strel('disk', 3);
    bw2 = imerode(imdilate(bw(:,:,i),se),se);
    [labeled, numObjs] = bwlabel(bw2, 8);
    if numObjs>2 error('Error: ���ִ���������ͨ��'); end  %###################
    props =  regionprops(labeled, 'Centroid','Area');
    for q = 1:numObjs
        C_bw(q,:) = props(q).Centroid;
    end
    Flag_plot=zeros(1,numObjs);
    for  row_obj = 1:numObjs
        d1 = pdist([C1;C_bw(row_obj,:)]); d2 =pdist([C2;C_bw(row_obj,:)]);
        if d1 < d2 %left control
            if d1>28 % discard those guodu frames
                Flag_plot(row_obj) = 1;
                Cell_Behavior{i, 1} = i / vidobj.FrameRate;
                if C_bw(row_obj, 1)>148
                    Cell_Behavior{i, 2} = 'right';
                elseif C_bw(row_obj, 1)<92
                    Cell_Behavior{i, 2} = 'left';
                elseif C_bw(row_obj, 2)<136
                    Cell_Behavior{i, 2} = 'rise';
                elseif C_bw(row_obj, 2)>190
                    Cell_Behavior{i, 2} = 'descent';
                end
            end
        else %ѡ��ڶ�����ť
            if d2>28
                Flag_plot(row_obj) = 1;
                Cell_Behavior{i, 1} = [num2str(i / vidobj.FrameRate),'s'];
                degree = degree_Behavior(C_bw(row_obj,:), C2);
                Cell_Behavior{i, 2} = [num2str(degree),'��'];
            end
            
        end
    end
    if sum(Flag_plot)==2 error('Bug: ������ťͬʱ�ж�������'); end
%     
%     figure('Visible','off'), imshow(frame),hold on;
%     if  sum(Flag_plot) == 1
%         index_flag = find(Flag_plot == 1);
%         text(C_bw(index_flag, 1),C_bw(index_flag, 2), [Cell_Behavior{i, 2},'  ', num2str(Cell_Behavior{i, 1}),'s'],'Color','g','FontSize',10);
%     end
%     
%     f = getframe(gca);
%         writeVideo(newobj,f.cdata);
    clear frame d1 d2 
end
% close(newobj);


