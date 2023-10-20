clc
clear all
close all

setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
%% ����Դ�ļ�������ļ���Ϊwater_detect����չ������ƽ̨��windows��Ϊmexw64
mex -R2018a 8mextest\3_water_detect\mex_c_to_m.cpp 8mextest\3_water_detect\water_detect_ffc.cpp -output water_detect
%% �������ļ����ý��л�ϱ��

%% ԭʼ���ݵ���
filename = '6python/0data/10�Ӿ����ˮ/4����Ҫ��������';
delimiterIn = ' '; % �����ո�ֿ�
ffc_log_struct = importdata(filename, delimiterIn);

input.raw.time_infact = ffc_log_struct(:, 1);
input.raw.fly_state_now = ffc_log_struct(:, 2);
input.raw.dpfs_new = ffc_log_struct(:, 3);
input.raw.fly_higt = ffc_log_struct(:, 4);
output.raw.water_flag_infly = ffc_log_struct(:, 5);

% ��ȡʵ�ʵı仯ʱ��
length = size(input.raw.time_infact);
j = 1;
extract_times(j) = 1;
for i= 1:length-1
    if((input.raw.time_infact(i+1) - input.raw.time_infact(i)) > 0)
        j = j +1;
        extract_times(j) = i;
    end
end

% ��ȡʵ�ʵ���������
length_extract = size(extract_times);
for i = 1:length_extract(2)

    input.time_infact(i) = input.raw.time_infact(extract_times(i));
    input.fly_state_now(i) = input.raw.fly_state_now(extract_times(i));
    input.dpfs_new(i) = input.raw.dpfs_new(extract_times(i));
    input.fly_higt(i) = input.raw.fly_higt(extract_times(i));
    output.water_flag_infly(i) = output.raw.water_flag_infly(extract_times(i));
end


% ���ñ�����Ķ������ļ�����֤C/C++ʵ�ֵ��㷨
for i = 1:length_extract(2)
    [mean_temp,variance_temp,stdvariance_temp,hpf_dpfs_temp,water_flag_inmatlab_temp,fly_state_change_temp] = ...
    water_detect(...
    input.time_infact(i),...
    input.fly_state_now(i),...
    input.dpfs_new(i),...
    input.fly_higt(i)...
    );

    output.mean_arr(i) = mean_temp;
    output.variance_arr(i) = variance_temp;
    output.stdvariance_arr(i) = stdvariance_temp;
    output.hpf_dpfs_arr(i) = hpf_dpfs_temp;
    output.water_flag_inmatlab(i) = water_flag_inmatlab_temp;
    output.fly_state_change(i) = fly_state_change_temp;    
end

figure_size = 5

figure
subplot(figure_size,1,1)
plot(input.time_infact,input.dpfs_new,'b') 
xlabel('t(s)')
ylabel('dpfs')
hold on
plot(input.time_infact,output.hpf_dpfs_arr,'r')
legend('dpfs�˲�ǰ','dpfs�˲���')

subplot(figure_size,1,2)
plot(input.time_infact,output.stdvariance_arr,'b') 
hold on;
limit = 0.2;
for i= 1:length_extract(2)
    line_arr(i) = limit;
end
plot(input.time_infact,line_arr,'r') 
hold on;
xlabel('t(s)')
ylabel('stdvariance')
legend('ʵʱ��׼��','��׼����ֵ')

subplot(figure_size,1,3)
plot(input.time_infact,output.water_flag_infly,'b') 
hold on
plot(input.time_infact,output.water_flag_inmatlab*0.5,'r') 
xlabel('t(s)')
legend('�Ż�ǰˮ���־λ','�Ż���ˮ���־λ')

subplot(figure_size,1,4)
plot(input.time_infact,input.fly_higt,'r') 
hold on
xlabel('t(s)')
legend('�ɻ��߶�')

% subplot(figure_size,1,5)
% plot(input.time_infact,output.matlab.tof_speed,'b') 
% hold on
% xlabel('t(s)')
% legend('tof speed')

%% ��ȫ�������ͷ��ڴ�
clear water_detect