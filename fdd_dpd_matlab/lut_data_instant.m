global INPUT_WIDTH LUT_LUT  LUT_DUAL_MODE LUT_AN LUT_BN  Depth  LUT_N
LUT_N=84;
Depth = 12;
INPUT_WIDTH = 16;   
load('LUT.mat');
%% lut_init
data_lut_96 = textread('.\vector\lut_84.txt','%s');
data_lut_96_char=char(data_lut_96);
data_lut_96_dec = hex2dec(data_lut_96_char);
data_lut_q = floor(data_lut_96_dec/2^INPUT_WIDTH);
data_lut_i = mod(data_lut_96_dec,2^INPUT_WIDTH);
data_lut_q = data_lut_q-(data_lut_q>=2^(INPUT_WIDTH-1))*2^INPUT_WIDTH;
data_lut_i = data_lut_i-(data_lut_i>=2^(INPUT_WIDTH-1))*2^INPUT_WIDTH;
% input_data
data_qi = textread('./vector/dpd_src.txt','%s');
[doutq, douti] = input_signal_qi(INPUT_WIDTH, 1, data_qi);
% 奇偶合路
data_even_i = douti;
data_odd_i = douti;
data_i_temp1 = upsample(data_even_i,2);
data_i_temp2 = [0 data_i_temp1(1:end-1)];
data_i = data_i_temp1+data_i_temp2;

data_even_q = doutq;
data_odd_q = doutq;
data_q_temp1 = upsample(data_even_q,2);
data_q_temp2 = [0 data_q_temp1(1:end-1)];
data_q = data_q_temp1+data_q_temp2;
%% LUT_coef
LUT_COEF_Q = reshape(data_lut_q(1:43008),512,LUT_N);
LUT_COEF_I = reshape(data_lut_i(1:43008),512,LUT_N);
%% cordic
[amp_cordic] = fa_mag_compute( data_i,data_q );
%%  amp2lut
amp = amp_cordic;
amp_cast = floor(amp/2^4);
data_lut_i_signed = data_lut_i-(data_lut_i>=2^(INPUT_WIDTH-1))*2^(INPUT_WIDTH);
amp2lut_lut = mod(data_lut_96_dec,2^9);
amp2lut_amp = amp2lut_lut(amp_cast+43008);

%% 查表
coef_q_lut(m,n) = (LUT_LUT(m,n)>0).*(data_lut_q((LUT_LUT(m,n)-1).*512+amp2lut_amp+1));
coef_i_lut(m,n) = (LUT_LUT(m,n)>0).*(data_lut_i((LUT_LUT(m,n)-1).*512+amp2lut_amp+1));
coef_q_lut_dual(dm,dn) = (LUT_DUAL_MODE(m,n)>0).*(data_lut_q((LUT_DUAL_MODE(m,n)-1).*512+amp2lut_amp+1));
coef_i_lut_dual(dm,dn) = (LUT_DUAL_MODE(m,n)>0).*(data_lut_i((LUT_DUAL_MODE(m,n)-1).*512+amp2lut_amp+1));    

