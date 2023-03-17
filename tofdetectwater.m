clc
clear
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% ԭʼ�źŽ���fft�Ĵ��ڴ�С
win_size = 300;  % ԭʼ�źŽ���fft�Ĵ��ڴ�С
frequency_spectrum_x1 = win_size - 200 %�ź�Ƶ�ʴ����±߽�
frequency_spectrum_x2 = win_size - 50 %�ź�Ƶ�ʴ����ϱ߽�
scale = 100         %fft�źŷ�ֵ��ͺ������
sum_value_limit = 5  %�ź���ͺ���Ϊ��ˮ����źź���ֵ
water_cnt_limit = 5  % �����ж��Ƿ���ˮ���ϵĴ���
water_cnt = 0 ;      %�жϿ��ܳ�����ˮ���ϵĴ���
step_size = 100      % ��������
figure_row = 3       % ��ͼ��row numble
figure_column = 1    % ��ͼ��column numble
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_ground1.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;          %ѡ����
myFun(dpfs_data,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfswater1;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;         %ѡ����
myFun(dpfs_data,2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.rawdpfswater2;  %ѡ��mat
dpfs_data = dpfs_mat_select.VarName1;         %ѡ����

myFun(dpfs_data,3)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myFun(inputdata,figure_num)
    
    global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% ԭʼ�źŽ���fft�Ĵ��ڴ�С
    length = size(inputdata);

    for i = 2:length
        if (inputdata(i) < (-60)||inputdata(i)>-13)
            inputdata(i) = inputdata(i-1);
        end
    end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 



    for i = win_size+1:step_size:length-win_size
        y= fft(inputdata(i-win_size:i)); %fft����
        M = abs(y);         %���źŷ��� ������ ��Ƶ�ʴ�С�������       
        %��ѡ����Ƶ�ʷ�Χ�������
        sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
        for a = i:i+win_size
            value(a)=sum_result;       
        end
    
        %�ж��Ƿ񳬹�ˮ���źŵ�Ҫ������ǣ�����ˮ��ʶ�������1
        if(sum_result > sum_value_limit)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0;
        end
    
    %�ж��Ƿ񳬹�ˮ��ʶ��Ĵ����������������������Ϊ��һ��ʱ����ˮ����
        if water_cnt>water_cnt_limit
           %for a = i:i-win_size
           result(i)=1*(-80);         
           %end
        else
           %for a = i:i+win_size 
           result(i)=0;         
           %end
        end
    end
    
    water_cnt = 0;
    subplot(figure_row,figure_column,figure_num)
    plot(inputdata)
    hold on
    plot(result)
    hold on
    plot(value)
    hold on
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
