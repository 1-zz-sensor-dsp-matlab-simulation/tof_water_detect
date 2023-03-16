clc
clear
close all

win_size = 100; % ԭʼ�źŽ���fft�Ĵ��ڴ�С
frequency_spectrum_x1 = 50 %�ź�Ƶ�ʴ����±߽�
frequency_spectrum_x2 = 99 %�ź�Ƶ�ʴ����ϱ߽�
scale = 100 %fft�źŷ�ֵ��ͺ������
sum_value_limit = 10  %�ź���ͺ���Ϊ��ˮ����źź���ֵ
water_cnt = 0 ; %�жϿ��ܳ�����ˮ���ϵĴ���
water_cnt_limit = 3
figure_row = 2
figure_column = 1

dpfs_mat_load = load('rawdpfs_ground1.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;          %ѡ����
length = size(dpfs_data);                      %��sԭʼ�źŵĳ���

%��ԭʼ�źŽ�����������ȥ��
for i = 2:length
    if (dpfs_data(i) < (-80)||dpfs_data(i) == 0)
        dpfs_data(i) = dpfs_data(i-1);
    end
end 
%��ԭʼ�źŽ�����ֵ�˲�
%dpfs_data_filter = medfilt1(dpfs_data,100);

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft����
    M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������       

    %��ѡ����Ƶ�ʷ�Χ�������
    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if(sum_result > sum_value_limit)
        water_cnt = water_cnt +1;
    else
        water_cnt = 0;
    end


    if water_cnt>water_cnt_limit
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
subplot(figure_row,figure_column,1)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1.mat');     %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfswater1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;       %ѡ����
length = size(dpfs_data);

for i = 2:length
    if (dpfs_data(i) < (-80)||dpfs_data(i) ==0)
        dpfs_data(i) = dpfs_data(i-1);
    end
end 
%��ԭʼ�źŽ�����ֵ�˲�
%dpfs_data_filter = medfilt1(dpfs_data,100);

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft����
    M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������       

    %��ѡ����Ƶ�ʷ�Χ�������
    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if(sum_result > sum_value_limit)
        water_cnt = water_cnt +1;
    else
        water_cnt = 0;
    end


    if water_cnt > water_cnt_limit
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
end

subplot(figure_row,figure_column,2)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)

