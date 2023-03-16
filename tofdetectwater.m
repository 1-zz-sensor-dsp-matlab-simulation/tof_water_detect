clc
clear
close all

% tofampdpsfload = load('tofdpsf1.mat');
dpfs_mat_load = load('rawdpfs_ground1.mat');     %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;       %ѡ����

length = size(dpfs_data);
win_size = 500;

n = 0:win_size; % ��������

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft����
    M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������

    sum_result= sum(M(400:500))/10000;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if M(499) > 500
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
end

figure
subplot(2,1,1)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)

% tofampdpsfload = load('tofdpsf1.mat');
dpfs_mat_load = load('rawdpfs_ground1.mat');     %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;       %ѡ����

length = size(dpfs_data);

n = 0:win_size; % ��������

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft����
    M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������

    sum_result= sum(M(400:500))/10000;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if M(499) > 500
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
end

subplot(2,1,2)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)

