function [dout_i, dout_q] = input_signal_qi(INPUT_WIDTH, CHANNEL_NUM, data)

%% 转16进制    
data_fpga = char(data);

data_fpga_imag = data_fpga(:,1:INPUT_WIDTH/4);
data_fpga_real = data_fpga(:,INPUT_WIDTH/4+1:INPUT_WIDTH/2);
%% 16进制转10进制
data_in_real_dec = hex2dec(data_fpga_real);
data_in_imag_dec = hex2dec(data_fpga_imag);

%% 定标
data_fpga_sig_i = data_in_real_dec-(data_in_real_dec>=2^(INPUT_WIDTH-1))*2^(INPUT_WIDTH);
data_fpga_sig_q = data_in_imag_dec-(data_in_imag_dec>=2^(INPUT_WIDTH-1))*2^(INPUT_WIDTH);

%% 解交织
dout_i = data_fpga_sig_i(1:CHANNEL_NUM:end).';
dout_q = data_fpga_sig_q(1:CHANNEL_NUM:end).';

%% 分奇偶输出
% fid=fopen('.\src_0506\data_tr_even_hex.txt','wt');
% [row col]=size(data_fpga);
% for i=1:2:row
%     for j=1:1:col
%         if(j==col)
%             fprintf(fid,'%s\n',data_fpga(i,j));
%         else
%             fprintf(fid,'%s',data_fpga(i,j));
%         end
%     end
% end
% 
% 
% fid2=fopen('.\src_0506\data_tr_odd_hex.txt','wt');
% [row col]=size(data_fpga);
% for i=2:2:row
%     for j=1:1:col
%         if(j==col)
%             fprintf(fid2,'%s\n',data_fpga(i,j));
%         else
%             fprintf(fid2,'%s',data_fpga(i,j));
%         end
%     end
% end
end


