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
amp2lut_amp = amp2lut_lut(amp_cast+43008+1);

%% 
% m=18;n=17;
coef_q_lut= zeros(Depth,Depth);
coef_i_lut= zeros(Depth,Depth);
coef_q_lut_dual= zeros(Depth,Depth);
coef_i_lut_dual= zeros(Depth,Depth);
dual_mode_coef_i = zeros(Depth,Depth);
dual_mode_coef_q = zeros(Depth,Depth);

coef_sum_i = zeros(Depth,1);
coef_sum_q = zeros(Depth,1);
coef_sum = zeros(Depth,1);
data_complex_mult = zeros(Depth,1);
dout_coef_sum_i = zeros(Depth,1);
dout_coef_sum_q = zeros(Depth,1);
data_out = zeros(length(data_i),1);
data_out_i = zeros(length(data_i),1);
data_out_q = zeros(length(data_i),1);
for pp =1:1:length(data_i)
    for m = Depth:-1:1
       for n = Depth:-1:1
           % 当前数据查lut表指针
           mag_index = pp-Depth+m + LUT_AN(m,n);  
           % 判断当前位置列向量，LUT_LUT值是否为0
           if(LUT_LUT(m,n) > 0)
               lut_index = LUT_LUT(m,n);
           else
               lut_index = 1; 
           end           
           % 用指针查表模值
           if ((0 < mag_index)&&(mag_index <= length(data_i)))
               amp2lut_coef_q = LUT_COEF_Q(amp2lut_amp(mag_index)+1,lut_index);
               amp2lut_coef_i = LUT_COEF_I(amp2lut_amp(mag_index)+1,lut_index);               
           else 
               amp2lut_coef_q = 0;
               amp2lut_coef_i = 0;  
           end                   
           % 查传统lut表
           coef_q_lut(m,n) = (LUT_LUT(m,n)>0)*amp2lut_coef_q;
           coef_i_lut(m,n) = (LUT_LUT(m,n)>0)*amp2lut_coef_i;    
           % 双模值当前数据指针
           dual_mag_index = pp-Depth+m;           
           % 查双模值lut表列向量
           if(LUT_DUAL_MODE(m,n) > 0)
               lut_dual_index = LUT_DUAL_MODE(m,n);
           else
               lut_dual_index = 1;  
           end
           % 用双模值指针查双模值表
           if ((0 < dual_mag_index)&&(dual_mag_index <= length(data_i)))
               dual_amp2lut_coef_q = LUT_COEF_Q(amp2lut_amp(dual_mag_index)+1,lut_dual_index);
               dual_amp2lut_coef_i = LUT_COEF_I(amp2lut_amp(dual_mag_index)+1,lut_dual_index);               
           else 
               dual_amp2lut_coef_q = 0;
               dual_amp2lut_coef_i = 0;  
           end  
           coef_q_lut_dual(m,n) = (LUT_DUAL_MODE(m,n)>0)*dual_amp2lut_coef_q;
           coef_i_lut_dual(m,n) = (LUT_DUAL_MODE(m,n)>0)*dual_amp2lut_coef_i;            
           % 双模值当前数据指针
           dual_full_mag_index = pp-Depth+m+LUT_BN(m,n);              
           % 全精度模值乘双模值系数
           if ((0 < dual_full_mag_index)&&(dual_full_mag_index <= length(data_i)))
               dual_mode_coef_q(m,n) = floor(amp(dual_full_mag_index).* (coef_q_lut_dual(m,n)./1024));
               dual_mode_coef_i(m,n) = floor(amp(dual_full_mag_index).* (coef_i_lut_dual(m,n)./1024));     
           else
               dual_mode_coef_q(m,n) = 0;
               dual_mode_coef_i(m,n) = 0;
           end
       end
           %计算各深度内的系数和
           coef_sum_i(m,1) = sum(coef_i_lut(m,:)) + sum(dual_mode_coef_i(m,:));
           coef_sum_q(m,1) = sum(coef_q_lut(m,:)) + sum(dual_mode_coef_q(m,:));
           %数据防饱和溢出
           index_i = find(coef_sum_i >= 2^(18-1));
           coef_sum_i(index_i) = 2^(18-1)-1;
           index_ii = find(coef_sum_i <= -2^(18-1));
           coef_sum_i(index_ii) = (-2^(18-1))+1;
           %
           index_q = find(coef_sum_q >= 2^(18-1));
           coef_sum_q(index_q) = 2^(18-1)-1;
           index_qq = find(coef_sum_q <= -2^(18-1));
           coef_sum_q(index_qq) = (-2^(18-1))+1;
           % 当前记忆深度对应的数据指针
           data_index = pp-Depth+m;
           % 系数变为复数
           coef_sum(m,1) = coef_sum_i(m) + j* coef_sum_q(m);
           % 复乘
           if((0 < data_index)&&(data_index <= length(data_i)))
           data_complex_mult(m,1) = (data_i(data_index)+ j* data_q(data_index))*coef_sum(m,1);
           else
           data_complex_mult(m,1) = 0;
           end
           if (pp == 33 && m == 1 && n == 1)
               keyboard
           end
    end
    % 各记忆深度相加
    data_out_pp = sum(data_complex_mult);
    % 数据截位
    data_out_pp_cut = floor(data_out_pp/2^13);
    data_out(pp)= data_out_pp_cut;
    data_out_i(pp) = real(data_out_pp_cut);
    data_out_q(pp) = imag(data_out_pp_cut);    
end


% % dual_amp = amp.*()