clc
clear
close all

% tofampdpsfload = load('tofdpsf1.mat');
dpfs_mat_load = load('huioutrise.mat');     %����mat����
dpfs_mat_select=dpfs_mat_load.huioutorise;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;       %ѡ����

length = size(dpfs_data);
win_size = 500;

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft����
    M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������

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
plot(dpfs_data)
hold on
plot(result)

% figure

% subplot(2,1,1)
% hold on
% plot(tof_data)
% hold off
% legend("tofampdpsf")

% subplot(2,1,2)
% hold on
% plot(tof_var)
% hold off
% legend("tof var")

