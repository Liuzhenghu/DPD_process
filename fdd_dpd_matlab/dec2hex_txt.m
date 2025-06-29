% % rom=round(rom.*65536);
data_in = data_in_16_q;
rom=data_in;
rom(find(rom<0))=rom(find(rom<0))+65536;
data_in_hex=dec2hex(rom.');
fid=fopen('D:\YYQ\project\cfr_prj\fdd_cfr_prj_3cpg_0210\sim\data_in\data_tr_imag_hex.txt','wt');
[row col]=size(data_in_hex);
for i=1:1:row
    for j=1:1:col
        if(j==col)
            fprintf(fid,'%s\n',data_in_hex(i,j));
        else
            fprintf(fid,'%s',data_in_hex(i,j));
        end
    end
end
% fclose(fid);

% 
% fid=fopen('D:\YYQ\project\Intel_cfr_2hb_8cpg_test\cfr_yyq.txt','r');
% A=textscan(fid,'%d');
% fclose(fid);
% out=cell2mat(A);
% out(find(out>32767))=0-(65536-out(find(out>32767)));
% OUT_I=int32(OUT_I);