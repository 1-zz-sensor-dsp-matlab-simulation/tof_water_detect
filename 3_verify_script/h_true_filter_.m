clc
clear all
close all

%% �˲�ϵ���������
global N
global a b
global x y

x = [0 0 0]
y = [0 0 0]

N = 2;
b = [0.20169205911526   -0.40338411823052    0.20169205911526 ]
a = [1                   0.392116929473767   0.198885165934809]

%% �㷨�ؼ���������
global win_length
global standard_deviation_value_threshold
global water_cnt_threshold

win_length = 800
standard_deviation_value_threshold = 0.2
water_cnt_threshold = 100

%% ԭʼ���ݵ���
filename = '6python/1scipe/ffc.1.csv';
delimiterIn = ' '; % �����ո�ֿ�
ffc_log_struct = importdata(filename,delimiterIn);
dspf_raw = ffc_log_struct.data(:,2);
dspf_hpf_dsp = ffc_log_struct.data(:,3);

%% �㷨����

length_raw = size(dspf_raw,1);
length_end = length_raw;

for i = 1:length_end
    dspf_hpf_matlab(i) = filter_hpl(dspf_raw(i));
    dspf_dev(i) = variance(dspf_hpf_matlab(i));
    water_flag_result(i) = water_judge(dspf_dev(i)); 
end


% �����ͼ
timeview = 1:length_end
timeview = timeview*(1/500)
subplot(4,1,1)
plot(timeview,dspf_raw,'r') 
xlabel('time(500point/s)')
ylabel('dpfs')
% legend('�˲�ǰdspfԭʼ����')
hold on
title('dspfԭʼ����,������500hz')

subplot(4,1,2)
plot(timeview,dspf_hpf_matlab,'g') 
xlabel('time(500point/s)')
ylabel('dpfs')
% legend('�˲���ԭʼ����')
title('dspf��ͨ�����,�������ڴ�С��=',num2str(win_length))
hold on

subplot(4,1,3)
plot(timeview,dspf_dev,'b') 
xlabel('time(500point/s)')
ylabel('dpfs')
% legend('��׼������')
title('��׼������')
hold on

subplot(4,1,4)
plot(timeview,water_flag_result,'k') 
xlabel('time(500point/s)')
ylabel('dpfs')
legend('water flag')
hold on
title(['ˮ������,����׼����ֵ=��',num2str(standard_deviation_value_threshold),',��������ֵ��=',num2str(water_cnt_threshold)])

%% �˲�����

function r=filter_hpl(new_data)
    global N
    global a b
    global x y

    persistent old_new_data;
    if isempty(old_new_data)
        water_cnt = 0;
    end

    if(new_data<-70||new_data>-5)
        new_data = old_new_data;
    else
        old_new_data = new_data;
    end

    begin = N +1;
    y0= 0;
    for i=begin:-1:2 %��3��ʼ��2������N��2
        x(i) = x(i-1);
        y(i) = y(i-1);
        y0 = y0 + b(i) * x(i) - a(i) * y(i) ;
    end
    x(1) = new_data;
    y(1) = y0 + b(1)*x(1);
    r= y(1);
end

%% ��׼�����

function standard_deviation = variance(data_filter)
    global win_length;
    persistent cnt;
    persistent arr;
    if isempty(cnt)
        cnt = 1;
    end
    if isempty(arr)
        for i=1:win_length
            arr(i)  = 0;
        end
    end

    if(cnt ~= win_length)
        arr(cnt) = data_filter;
        cnt = cnt+1;
    else
        for i = 2:win_length
            arr(i-1) = arr(i); 
        end
        arr(win_length)= data_filter;
    end
    standard_deviation = std(arr(1:win_length),'omitnan');
end


%% ˮ����ֵ�жϺ���

function flag = water_judge(standard_deviation)
    global water_cnt_threshold
    persistent water_cnt;
    if isempty(water_cnt)
        water_cnt = 0;
    end
    if (standard_deviation > 0.15)
        water_cnt = water_cnt +1;
    else
        water_cnt = 0;
    end
    if (water_cnt > water_cnt_threshold)
        flag = 1;
    else
        flag = 0;
    end
end



