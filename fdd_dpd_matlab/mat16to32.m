data_in = phase_0_q.';
rom=data_in;
rom(find(rom<0))=rom(find(rom<0))+2^16;
data_in_hex=dec2hex(rom.');
data_in_hex_32_q = [data_in_hex;zeros(1,4)];
%% ตอ16bit.
rom2 = phase_0_i.';
rom2(find(rom2<0))=rom2(find(rom2<0))+2^16;
data_in_hex2=dec2hex(rom2.');
data_in_hex_32_i = [data_in_hex2;zeros(1,4)];
data_in_hex_32 = [data_in_hex_32_q data_in_hex_32_i];
fid=fopen('D:\YYQ\project\cfr_prj\fdd_cfr_prj_3cpg_0210\sim\data_in\cfr_coef_hex_16384.txt','wt');
[row col]=size(data_in_hex_32);
for i=1:1:row
    for j=1:1:col
        if(j==col)
            fprintf(fid,'%s\n',data_in_hex_32(i,j));
        else
            fprintf(fid,'%s',data_in_hex_32(i,j));
        end
    end
end