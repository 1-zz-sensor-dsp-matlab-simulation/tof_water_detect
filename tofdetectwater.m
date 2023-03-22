clc
clear
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% ԭʼ�źŽ���fft�Ĵ��ڴ�С
win_size = 30;                        % ԭʼ�źŽ���fft�Ĵ��ڴ�С
frequency_spectrum_x1 = win_size/2 % �ź�Ƶ�ʴ����±߽�
frequency_spectrum_x2 = win_size      % �ź�Ƶ�ʴ����ϱ߽�
scale = 100                            % fft�źŷ�ֵ��ͺ������
sum_value_limit = 0.15             % �ź���ͺ���Ϊ��ˮ����źź���ֵ
water_cnt_limit = 5                    % �����ж��Ƿ���ˮ���ϵĴ���
water_cnt = 0 ;      % �жϿ��ܳ�����ˮ���ϵĴ���
step_size = 5       % ��������
figure_row = 3       % ��ͼ��row numble
figure_column = 1    % ��ͼ��column numble
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',1)
title('�Ը��Զ�����log')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',2)
title('�Ը�ˮ��log1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',3)
title('�Ը�ˮ��log2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myFun(inputdata,figure_num)
    
    global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% ԭʼ�źŽ���fft�Ĵ��ڴ�С
    length = size(inputdata);
    
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

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
        amp_sum = sum(inputdata(i-win_size:i))
        %��ѡ����Ƶ�ʷ�Χ�������
        sum_result= sum(M(frequency_spectrum_x1/2:frequency_spectrum_x2/2))/(-amp_sum); %���㵥��Ƶ�׵�Ƶ���к�
%         for a = i-win_size:i
%             value(a)=sum_result;       
%         end
        value(i) = sum_result;
    
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

% /*
% *********************************************************************************************************
% *	�� �� ��: cfft
% *	����˵��: ������ĸ�������п��ٸ���Ҷ�任��FFT��
% *	��    ��: *_ptr �����ṹ������׵�ַָ��struct�� 
% *             FFT_N ��ʾ����
% *	�� �� ֵ: ��
% *********************************************************************************************************
% */
function cfft(ptr,FFT_N)
    global MAX_FFT_N

    z=FFT_N/2; 
    j = 1
    for i=1:FFT_N-1        
        % /* 
        %     ���i<j,�����б�ַ i=j˵����������i>j˵��ǰ���Ѿ��任���ˣ������ٱ仯��ע������һ����ʵ�� ���������� ���óɽ���� 
        % */
        if i<j                    				    
            TempReal1  = ptr(j).real;           	
            ptr(j).real= ptr(i).real;
            ptr(i).real= TempReal1;
        end
            
        k=z;                    				  % ��j����һ����λ�� 
        
        while k<=j               				  % ���k<=j,��ʾj�����λΪ1                  
            j=j-k;                 				  % �����λ���0 */
            k=k/2;                 				  % k/2���Ƚϴθ�λ���������ƣ�����Ƚϣ�ֱ��ĳ��λΪ0��ͨ�������Ǿ�j=j+kʹ���Ϊ1 */
        end
        
        j=j+k;                   				  % ����һ������ţ������0�����0��Ϊ1 */
    end

    Butterfly_NoPerColumn = FFT_N;						     
	Butterfly_NoPerGroup = 1;	
    M = log2(FFT_N);

    for L = 1:M		     					
    
            Butterfly_NoPerColumn = Butterfly_NoPerColumn /2;		%/* �������� ����N=8����(4,2,1) */
            
            %/* ��L������ ��Butterfly_NoOfGroup��	��0,1��....Butterfly_NoOfGroup-1��*/					
            for Butterfly_NoOfGroup = 1: Butterfly_NoPerColumn            
                for J = 1: Butterfly_NoPerGroup	    %/* �� Butterfly_NoOfGroup ���еĵ�J�� */
                					   						    %/* �� ButterflyIndex1 �͵� ButterflyIndex2 ��Ԫ������������,WNC */
                    ButterflyIndex1 = ( ( Butterfly_NoOfGroup * Butterfly_NoPerGroup ) *2 ) + J;  %/* (0,2,4,6)(0,1,4,5)(0,1,2,3) */
                    ButterflyIndex2 = ButterflyIndex1 + Butterfly_NoPerGroup;                       %/* ����Ҫ����������������Butterfly_NoPerGroup (ge=1,2,4) */
                    P = J * Butterfly_NoPerColumn;				                                    %/* �����൱��P=J*2^(M-L),����һ�������±궼��N (0,0,0,0)(0,2,0,2)(0,1,2,3) */
                    
                    %/* �����ת�����ӳ˻� */
                    TempReal2 = ptr(ButterflyIndex2).real * costab( P ) +  ptr(ButterflyIndex2).imag *  sin( 2 * PI * P / MAX_FFT_N );
                    TempImag2 = ptr(ButterflyIndex2).imag * costab( P )  -  ptr(ButterflyIndex2).real * sin( 2 * PI * P / MAX_FFT_N );
                    TempReal1 = ptr(ButterflyIndex1).real;
                    TempImag1 = ptr(ButterflyIndex1).imag;
                    
                    % �������� */
                    ptr(ButterflyIndex1).real = TempReal1 + TempReal2;	
                    ptr(ButterflyIndex1).imag = TempImag1 + TempImag2;
                    ptr(ButterflyIndex2).real = TempReal1 - TempReal2;
                    ptr(ButterflyIndex2).imag = TempImag1 - TempImag2;
                end
            end
            
            Butterfly_NoPerGroup = Butterfly_NoPerGroup *2;							%/* һ���е��εĸ���(1,2,4) */
    end

end