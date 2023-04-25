
clc
clear
close all

win_size = 30;  
step_size = 2 
figure_row = 3  
figure_column =1
time_begin = 5000
time_end = 5500

%�˲�������
Fs = 33
%�Ľ׵İ�����˹��ͨ�˲�
high_pass = 10
Wc=2*high_pass/Fs;            % ��ֹƵ�� 10Hz
[b2,a2]=butter(4,Wc,'high');  % �Ľ׵İ�����˹��ͨ�˲�

scale_value = 10

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('1_truesensordata/rawdpfs_grass.mat');  
dpfs_mat_select_grass = dpfs_mat_struct_load.truedata;

% length = size(dpfs_mat_select_grass,1)
        

for i = win_size+time_begin:step_size:time_end-win_size
    %����ʵ���ϻ�õ�ʱ�䴰�����˲���ֵ�����糤��31����ô�˲���Ҳ��31
    inputdata_filter_ = filter(b2,a2,dpfs_mat_select_grass(i-win_size:i));%inputdata_filter_����Ĵ�С��win_size+1������
    
    %��ȡʱ�䴰���ڵ��źŷ��ֵ
    bsort = sort(dpfs_mat_select_grass(i-win_size:i),"ascend");
    a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

    %���潫�˲�������һ��ֵ��Ϊ�˲��������ֵ����ͬʱ��������
    if (a<0.1)
        after_filter_data(i) = inputdata_filter_(win_size+1) * a
        deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
    else
        after_filter_data(i) = inputdata_filter_(win_size+1)
        deviation = std(after_filter_data(i-win_size:i),'omitnan')
    end 

    result(i) = deviation * scale_value
end

for i = win_size+time_begin:step_size:time_end-win_size
    deviation = std(result(i-win_size:i),'omitnan')
    result2(i) = deviation
end

subplot(figure_row,figure_column,1)


plot(dpfs_mat_select_grass)  
hold on
plot(result)    
hold on
plot(result2,'g')
hold on

title('Asphalt pavement')
xlabel('time(1s/100point)')
ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('origindata/rawdpfs_water1.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.rawdpfswater1.VarName1;

time_begin_hebian = 8909
time_end_hebian = time_begin_hebian + time_end - time_begin 

% for i = win_size+time_begin:step_size:time_end-win_size
%     deviation = std(dpfs_mat_select_water(i-win_size:i),'omitnan')
%     result(i) = deviation
% end

% for i = win_size+time_begin:step_size:time_end-win_size
%     deviation = std(result(i-win_size:i),'omitnan')
%     result2(i) = deviation
% end

% subplot(figure_row,figure_column,2)

% plot(dpfs_mat_select_water)  
% hold on
% plot(result)    
% hold on
% plot(result2,'g')
% hold on


for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    %����ʵ���ϻ�õ�ʱ�䴰�����˲���ֵ�����糤����31����ô�˲���Ҳ��31
    inputdata_filter_ = filter(b2,a2,dpfs_mat_select_water(i-win_size:i));%inputdata_filter_����Ĵ�С��win_size+1������
    
    %��ȡʱ�䴰���ڵ��źŷ��ֵ
    bsort = sort(dpfs_mat_select_water(i-win_size:i),"ascend");
    a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

    %���潫�˲�������һ��ֵ��Ϊ�˲��������ֵ����ͬʱ��������ֵ
    if (a<0.1)
        after_filter_data(i) = inputdata_filter_(win_size+1) * a
        deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
    else
        after_filter_data(i) = inputdata_filter_(win_size+1)
        deviation = std(after_filter_data(i-win_size:i),'omitnan')
    end 

    result(i) = deviation * scale_value
end

for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    deviation = std(result(i-win_size:i),'omitnan')
    result2(i) = deviation
end

subplot(figure_row,figure_column,2)


plot(dpfs_mat_select_water)  
hold on
plot(result)    
hold on
plot(result2,'g')
hold on

title('water1')
xlabel('time(1s/100point)')
ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('origindata/rawdpfs_hebian.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.hebian.VarName1;

time_begin_hebian = 7241
time_end_hebian = time_begin_hebian + time_end - time_begin 

% for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
%     deviation = std(dpfs_mat_select_water(i-win_size:i),'omitnan')
%     result(i) = deviation
% end

% for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
%     deviation = std(result(i-win_size:i),'omitnan')
%     result2(i) = deviation
% end

for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    %����ʵ���ϻ�õ�ʱ�䴰�����˲���ֵ�����糤��31����ô�˲���Ҳ��31
    inputdata_filter_ = filter(b2,a2,dpfs_mat_select_water(i-win_size:i));%inputdata_filter_����Ĵ�С��win_size+1������
    
    %��ȡʱ�䴰���ڵ��źŷ��
    bsort = sort(dpfs_mat_select_water(i-win_size:i),"ascend");
    a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

    %���潫�˲�������һ��ֵ��Ϊ�˲��������ֵ����ͬʱ��������
    if (a<0.1)
        after_filter_data(i) = inputdata_filter_(win_size+1) * a
        deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
    else
        after_filter_data(i) = inputdata_filter_(win_size+1)
        deviation = std(after_filter_data(i-win_size:i),'omitnan')
    end 

    result(i) = deviation * scale_value
end

for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    deviation = std(result(i-win_size:i),'omitnan')
    result2(i) = deviation
end

subplot(figure_row,figure_column,3)

plot(dpfs_mat_select_water)  
hold on
plot(result)    
hold on
plot(result2,'g')
hold on

title('water2')
xlabel('time(1s/100point)')
ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%