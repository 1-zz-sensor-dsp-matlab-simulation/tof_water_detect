%��ԭ1s/100 point ת���� 1s/33 point
clc
clear
close all

dpfs_mat_struct_load = load('0_origindata/rawdpfs_grass.mat');  
dpfs_mat_select_grass = dpfs_mat_struct_load.rawdpfsgarss.VarName1;
length = size(dpfs_mat_select_grass,1)

j = 1 
for i=1:3:length 
    truedata(j) =  dpfs_mat_select_grass(i)
    j = j +1 
end