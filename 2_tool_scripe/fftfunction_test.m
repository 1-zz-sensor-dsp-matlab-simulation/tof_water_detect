clc
clear
close all

Fs = 256; % ������
L = 256; % ��������
n = 0:L-1; % ��������
t = 0:1/Fs:1-1/Fs; % ʱ������

global MAX_FFT_N
MAX_FFT_N = 1024

for i = 1 : MAX_FFT_N
    s(i).real = 1 + cos(2*3.1415926*10*i/MAX_FFT_N + 3.1415926/3);
    s(i).imag = 0 ;
end 

for i = 1 : MAX_FFT_N
    origin(i) = s(i).real 
end 

subplot(2,1,1)
plot(origin)
hold on

cfft(s, MAX_FFT_N);
	
for i=1:MAX_FFT_N
    amp(i) = s(i).real *s(i).real+ s(i).imag*s(i).imag 		
end

subplot(2,1,2)
plot(amp)
hold on

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
        
        j=uint32(j+k);                   				  % ����һ������ţ������0�����0��Ϊ1 */
    end

    Butterfly_NoPerColumn = FFT_N-2;						     
	Butterfly_NoPerGroup = 1;	
    M = uint32(log2(FFT_N))

    for L = 1:M		     					
    
            Butterfly_NoPerColumn = uint32(Butterfly_NoPerColumn /2);		%/* �������� ����N=8����(4,2,1) */            
            %/* ��L������ ��Butterfly_NoOfGroup��	��0,1��....Butterfly_NoOfGroup-1��*/					
            for Butterfly_NoOfGroup = 1: Butterfly_NoPerColumn            
                for J = 1: Butterfly_NoPerGroup	    %/* �� Butterfly_NoOfGroup ���еĵ�J�� */
                					   						    %/* �� ButterflyIndex1 �͵� ButterflyIndex2 ��Ԫ������������,WNC */
                    ButterflyIndex1 = ( ( Butterfly_NoOfGroup * Butterfly_NoPerGroup ) *2 ) + J;  %/* (0,2,4,6)(0,1,4,5)(0,1,2,3) */
                    ButterflyIndex2 = ButterflyIndex1 + Butterfly_NoPerGroup;                       %/* ����Ҫ����������������Butterfly_NoPerGroup (ge=1,2,4) */
                    P = J * Butterfly_NoPerColumn;				                                    %/* �����൱��P=J*2^(M-L),����һ�������±궼��N (0,0,0,0)(0,2,0,2)(0,1,2,3) */
                    
                    if ButterflyIndex2>1024
                         TempReal2 = ptr(ButterflyIndex2).real * cos(single(2 * pi * P / MAX_FFT_N)  ) +  ptr(ButterflyIndex2).imag *  sin( single(2 * pi * P / MAX_FFT_N ));
                    end
                    %/* �����ת�����ӳ˻� */
                    TempReal2 = ptr(ButterflyIndex2).real * cos(single(2 * pi * P / MAX_FFT_N)  ) +  ptr(ButterflyIndex2).imag *  sin( single(2 * pi * P / MAX_FFT_N ));
                    TempImag2 = ptr(ButterflyIndex2).imag * cos( single(2 * pi * P / MAX_FFT_N) )  -  ptr(ButterflyIndex2).real * sin(single( 2 * pi * P / MAX_FFT_N ));
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