% ��kst�е������ݵ�ʱ��Ҫ����ʱ�䡢dfps��filter������˳������
% �ſ���������ű��Զ�����
time=watertest1.VarName1
dpfs=watertest1.VarName2
fly_filter=watertest1.VarName3
now_time = 1
j=1
length = size(time,1);
for i=1:length
    r = isequal(time(i), now_time)
    if(r==0)
        new_fpds(j) = dpfs(i)
        new_fly_filter(j) = fly_filter(i)
        j=j+1
        now_time = time(i)
    end
end