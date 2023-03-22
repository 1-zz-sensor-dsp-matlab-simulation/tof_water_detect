clc
clear
close all

win_size = 30;       % ԭʼ�źŽ���fft�Ĵ��ڴ�С
step_size = 5        % ��������
figure_row = 3       % ��ͼ��row numble
figure_column = 1    % ��ͼ��column numble

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
% myFun(dpfs_mat_select',1)


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
y=filter(b2,a2,dpfs_mat_select');%����filter�˲�֮��õ�������y���Ǿ�����ͨ�˲�����ź�����

subplot(figure_row,figure_column,1)
plot(dpfs_mat_select')
hold on
subplot(figure_row,figure_column,2)
plot(y)
hold on
title('�Ը��Զ�����log')

% function myFun(inputdata,figure_num)
%     
%     global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% ԭʼ�źŽ���fft�Ĵ��ڴ�С
%     length = size(inputdata);
%     
% %     j = 1
% %     for i=1:3:length
% %         origindata(j) = inputdata(i)
% %         j= j+1
% %     end
% 
%     for i = 2:length
%         if (inputdata(i) < (-60)||inputdata(i)>-13)
%             inputdata(i) = inputdata(i-1);
%         end
%     end 
% 
%     % for i = 2:length
%     %     if (abs(inputdata(i-1) - inputdata(i))> 20)
%     %         inputdata(i) = inputdata(i-1);
%     %     end
%     % end 
% 
% 
% 
%     for i = win_size+1:step_size:length-win_size
% 
% 
% 
%     end
%     
%     water_cnt = 0;
%     subplot(figure_row,figure_column,figure_num)
%     plot(inputdata)
%     hold on
%     plot(result)
%     hold on
%     plot(value)
%     hold on
% end