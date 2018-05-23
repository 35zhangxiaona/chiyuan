%%  T2
rng(923) %���������
n = 1e3;
data = num2cell([unifrnd(-10, 10, n, 3), randi(1e2, [n, 1])],1);
inputdata = table(data{:}, 'VariableNames', {'X', 'Y', 'Z', 'Group'});
head(inputdata)
tic
r = compute(inputdata);
toc
%%
function result = compute(input)
input = sortrows(input,4);
input = cell2mat(table2cell(input)); %*****ע�⣺�ϸ߶˲���***** ��tableת��Ϊmat���Ӷ�������д���
group_num = unique(input(:,4),'rows'); %unique��������ȥ�أ����ﰴ�з���ȥ��
X = cell( [1, length(group_num)] ); %Ԥ����һ���յ�cell���������ĺ��뼰���е������
%%  ���ɸ�����ľ���X��j��
for j = 1:size(group_num);
    count = 0;
    for i = 1:size(input,1)
        if (input(i,4)==group_num(j,1));
            count = count + 1 ;
            X{j}(count,:) = input(i,:); % ******ע���ˣ��߶˲�����******
            %          Group_dis = pdist(A,(:,1:3));
        end
    end
end
nG =length(X);
result = cell(nG*(nG-1)/2,2); %%ע�⣺Ԥ����һ����С��cell
% result ={};
count2=0;
%% �����������������������еĵ�֮��ľ���
for m = 1:nG
    min_matrix = zeros(size(X{m},1),1); %Ԥ����
    for n = m+1:nG  %ע�⣬�����1��ʼ�Ļ���������������ظ�
        dist_2rows = zeros(size(X{n},1),1);
        for p = 1: size(X{m},1) % ������m�������ÿһ��
            %         dist_row_group = min(pdist([X{m}(p,:); X{n}])); %��m������ĵ�p�����n��������ɡ�������
            %ע�⣬�����Ǵ�ģ�Ҫ����ǵ�һ�������������е�ľ��룬���������е�֮��ľ��롣
            for q = 1:size(X{n},1) %������n�������ÿһ��
                p_2rows = [ X{m}(p,:); X{n}(q,:)];
                dist_2rows(q) = pdist(p_2rows);  %������֮��ľ���
            end
            min_matrix(p,1) = min(dist_2rows); %������󣬽��յ�m��С��ĵ�p�������n��С�����е�֮�����Сֵ
        end
        min_groups = min(min_matrix);
        %         fprintf('��%d��͵�%d��֮�����С����Ϊ%d\n',m,n,min_groups);
        count2 = count2 + 1;
        %         result{count2,1} = {['��',num2str(m), '��͵�',num2str(n),'��֮��ľ���'],min_groups};
        result{count2,1} = ['��',num2str(m), '��͵�',num2str(n),'��֮��ľ���'];
        result{count2,2} = min_groups;
    end
end
end