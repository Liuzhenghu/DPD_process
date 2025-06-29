global INPUT_WIDTH
INPUT_WIDTH = 16;
%% 16进制
data_iq_hex = textread('D:\YYQ\project\dpd_prj\fdd_DPD_double_path_0528\vector\data_odd.txt','%s');
data_hex = char(data_iq_hex);
data_dec = hex2dec(data_hex);
 
data_i= floor(data_dec/2^16);
data_q= mod(data_dec,2^16);
 
data_i_sig = data_i-(data_i>=2^15)*2^16;
data_q_sig = data_q-(data_q>=2^15)*2^16;


data_i_sig_fpga_odd = data_i_sig;
data_q_sig_fpga_odd = data_q_sig;

%% 16进制
data_iq_hex = textread('D:\YYQ\project\dpd_prj\fdd_DPD_double_path_0528\vector\data_even.txt','%s');
data_hex = char(data_iq_hex);
data_dec = hex2dec(data_hex);
 
data_i= floor(data_dec/2^16);
data_q= mod(data_dec,2^16);
 
data_i_sig = data_i-(data_i>=2^15)*2^16;
data_q_sig = data_q-(data_q>=2^15)*2^16;


data_i_sig_fpga_even = data_i_sig;
data_q_sig_fpga_even = data_q_sig;

%% 奇偶合路
% 奇偶合路

data_i_fpga_temp1 = upsample(data_i_sig_fpga_even,2);
data_i_fpga_temp2 = upsample(data_i_sig_fpga_odd,2);
data_i_fpga_temp3 = [0 ;data_i_fpga_temp2(1:end-1)];
data_i_fpga = data_i_fpga_temp1+data_i_fpga_temp3;

data_q_fpga_temp1 = upsample(data_q_sig_fpga_even,2);
data_q_fpga_temp2 = upsample(data_q_sig_fpga_odd,2);
data_q_fpga_temp3 = [0 ;data_q_fpga_temp2(1:end-1)];
data_q_fpga = data_q_fpga_temp1+data_q_fpga_temp3;
%%
data_iq_hex_src = textread('D:\YYQ\matlab_code\fdd_dpd_matlab\src_0506\FPGA_tr_2.txt','%s');
data_hex_src = char(data_iq_hex_src);
data_dec_src = hex2dec(data_hex_src);
 
data_i_src= floor(data_dec_src/2^16);
data_q_src= mod(data_dec_src,2^16);
 
data_i_sig_src = data_i_src-(data_i_src>=2^15)*2^16;
data_q_sig_src = data_q_src-(data_q_src>=2^15)*2^16;

% [e,f]=xcorr(data_i_sig_fpga,data_i_sig_src);
% figure(1)
% plot(f,e);