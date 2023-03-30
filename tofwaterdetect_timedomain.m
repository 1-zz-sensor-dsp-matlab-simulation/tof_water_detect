clc
clear
close all

global win_size step_size figure_row figure_column 
global std_limit_value water_cnt_limit water_cnt 
global b2 a2 %�˲������ݺ�����ϵ��

% ϵͳ����
win_size = 30;        % ԭʼ�źŽ���fft�Ĵ��ڴ�С
step_size = 1         % ��������
figure_row = 3        % ��ͼ��row numble
figure_column = 1     % ��ͼ��column numble
std_limit_value = 0.3 % �ж��Ƿ�Ϊˮ���ϵı�׼����ֵ
water_cnt_limit = 2   % �ж��Ƿ�Ϊˮ���ϵ�����������ֵ
water_cnt = 0 ;       % �жϿ��ܳ�����ˮ���ϵĴ���

%�˲�������
Fs = 33
fp1=7;fs1=16;
Fs2=Fs/2;
% ������Ҫ����һ�����⣬Ϊ����Ҫ��ͨ����������Բ���Ƶ�ʵ�һ��Fs2�أ�
% ���Ƕ�֪��һ�仰������ʱ�������Ƶ�����ء�Ƶ���������Ҫ��������Ϊ2 �� 2\pi2�н������ء�
% Ҳ����ζ�ţ�������ɢʱ�丵��Ҷ�任DTFT����Ƶ������2 �� 2\pi2��Ϊ���ڵġ�
% ����ο���ƪ����ʱ�������Ƶ�����ء���ˣ����ǵ��˲���ʵ����������
Wp=fp1/Fs2; Ws=fs1/Fs2;
Rp=1; Rs=30;
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b2,a2]=butter(n,Wn,'high','s');
%y=filter(b2,a2,dpfs_mat_select');%����filter�˲�֮��õ�������y���Ǿ�����ͨ�˲�����ź�����

%�Ľ׵İ�����˹��ͨ�˲�
high_pass = 10
Wc=2*high_pass/Fs;            % ��ֹƵ�� 10Hz
[b2,a2]=butter(4,Wc,'high');  % �Ľ׵İ�����˹��ͨ�˲�

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ݵ��봦��
dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat

raw_data = dpfs_mat_select'; %����ԭʼ����
length = size(dpfs_mat_select',1);

window_size = 11;
window_data = zeros(window_size,1);
Median_filter = zeros(length,1);

for i = 1:length
    if i <= window_size
        Median_filter(i) = raw_data(i);
        window_data(i) = raw_data(i);
    else
        window_data(1:window_size-1) = window_data(2:window_size);
        window_data(window_size) = raw_data(i);
        Median_filter(i) = GetMedianNum(window_data,window_size);
    end
end

myFun(Median_filter,1)
title('�Ը��Զ�����log')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %����mat����
% dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat

% raw_data = dpfs_mat_select'; %����ԭʼ����
% length = size(dpfs_mat_select',1);

% window_size = 11;
% window_data = zeros(window_size,1);
% Median_filter = zeros(length,1);

% for i = 1:length
%     if i <= window_size
%         Median_filter(i) = raw_data(i);
%         window_data(i) = raw_data(i);
%     else
%         window_data(1:window_size-1) = window_data(2:window_size);
%         window_data(window_size) = raw_data(i);
%         Median_filter(i) = GetMedianNum(window_data,window_size);
%     end
% end

% myFun(Median_filter,2)
% title('�Ը�ˮ��log1')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat

raw_data = dpfs_mat_select'; %����ԭʼ����
length = size(dpfs_mat_select',1);

window_size = 11;
window_data = zeros(window_size,1);
Median_filter = zeros(length,1);

for i = 1:length
    if i <= window_size
        Median_filter(i) = raw_data(i);
        window_data(i) = raw_data(i);
    else
        window_data(1:window_size-1) = window_data(2:window_size);
        window_data(window_size) = raw_data(i);
        Median_filter(i) = GetMedianNum(window_data,window_size);
    end
end

myFun(Median_filter,3)
title('�Ը�ˮ��log2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ݴ�����
function myFun(inputdata,figure_num)
    
    global win_size step_size figure_row figure_column 
    global std_limit_value water_cnt_limit water_cnt 
    global b2 a2 %�˲������ݺ�����ϵ��

    length = size(inputdata,1)/2;
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

    %�޷��˲�
    for i = 2:length
        if (inputdata(i) < (-80)||inputdata(i)>-13)
            inputdata(i) = inputdata(i-1);
        end
    end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 
    subplot(figure_row,figure_column,figure_num)
    for i = win_size+1:step_size:length-win_size
        inputdata_filter_ = filter(b2,a2,inputdata(i-win_size:i));%����filter�˲�֮��õ�������y���Ǿ�����ͨ�˲�����ź�����
        
        bsort = sort(inputdata(i-win_size:i),"ascend");
        a =abs(1/ (bsort(1) -(bsort(31) )))

        if (a<0.1)
            after_filter_data(i) = inputdata_filter_(31) * a
            deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
        else
            after_filter_data(i) = inputdata_filter_(31)
            deviation = std(after_filter_data(i-win_size:i),'omitnan')
        end 
    
        result(i) = deviation
        if(deviation > std_limit_value)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0
        end

        if water_cnt>water_cnt_limit            
            water_flag(i)=1*(-80);                     
         else
            water_flag(i)=0;         
         end        
    end

    plot(inputdata)  %�˲�ǰ��ʱ��ͼ
    hold on
    plot(result)     %��Ӧ��ı�׼��ͼ
    hold on
    plot(water_flag) %��Ӧ���Ƿ���ˮ��ı�־λ���
    hold on
    plot(after_filter_data) %�˲��������
    hold on
end

%������ֵ�˲�
function mid_data = GetMedianNum(bArray,window_size)
    bsort = sort(bArray,"ascend");
    if mod(window_size , 2) ~= 0
        mid_data = bsort((window_size+1) / 2);
    else
        mid_data = (bsort(window_size/2) + bsort(window_size/2+1)) / 2;
    end
    end