% load('LUT1.mat')
% load('sou_data.mat')
% lut 高q低i
lut_iq_hex = textread('G:/200M/toFPGA_testdata_58LUT_1220/lut_full_8192.txt','%s');
lut_hex = char(lut_iq_hex);
lut_dec = hex2dec(lut_hex);

lut_q= floor(lut_dec/2^16);
lut_i= mod(lut_dec,2^16);
 
lut_i_sig = lut_i-(lut_i>=2^15)*2^16;
lut_q_sig = lut_q-(lut_q>=2^15)*2^16;

lut_iq_s = lut_i_sig +1i*lut_q_sig;
lut_1=lut_iq_s(1:26624);
lut_add=lut_iq_s(26625:29696);
lut_2=lut_iq_s(29697:end);
lut_512x52= reshape(lut_1,512,52);
lut_52x512 = lut_512x52.';
lut_512x6= reshape(lut_add,512,6);
lut_6x512 = lut_512x6.';

%% LUT1 52*512 I+JQ
LUT1 = lut_52x512;
LUT_add = lut_6x512;
%% LUT2 幅度地址转换表
LUT2 = lut_2;
% LUT2 = imag(lut_2);
%% 输入数据 i+jq  一列
tr_iq_hex = textread('G:/200M/toFPGA_testdata_58LUT_1220/dpd_src.txt','%s');
tr_hex = char(tr_iq_hex);
tr_dec = hex2dec(tr_hex);

tr_i= floor(tr_dec/2^16);
tr_q= mod(tr_dec,2^16);
 
tr_i_sig = tr_i-(tr_i>=2^15)*2^16;
tr_q_sig = tr_q-(tr_q>=2^15)*2^16;

tr_iq_s = tr_i_sig +1i*tr_q_sig;

tr_iq_s_d2= tr_iq_s(1:2:end);


x_n=tr_iq_s.';
%%

x_n_1 =[x_n(2 :end),zeros(1,1 )];
x_n_2 =[x_n(3 :end),zeros(1,2 )];
x_n_3 =[x_n(4 :end),zeros(1,3 )];
x_n_4 =[x_n(5 :end),zeros(1,4 )];
x_n_5 =[x_n(6 :end),zeros(1,5 )];
x_n_6 =[x_n(7 :end),zeros(1,6 )];
x_n_7 =[x_n(8 :end),zeros(1,7 )];
x_n_8 =[x_n(9 :end),zeros(1,8 )];
x_n_9 =[x_n(10 :end),zeros(1,9 )];
x_n_10=[x_n(11:end),zeros(1,10)];
x_n_11=[x_n(12:end),zeros(1,11)];
%% 均匀量化
% m0_abs =  floor(abs(x_n)/2^6);
% m0_abs_1 = floor(abs(x_n_1 )/2^6);
% m0_abs_2 = floor(abs(x_n_2 )/2^6);
% m0_abs_3 = floor(abs(x_n_3 )/2^6);
% m0_abs_4 = floor(abs(x_n_4 )/2^6);
% m0_abs_5 = floor(abs(x_n_5 )/2^6);
% m0_abs_6 = floor(abs(x_n_6 )/2^6);
% m0_abs_7 = floor(abs(x_n_7 )/2^6);
% m0_abs_8 = floor(abs(x_n_8 )/2^6);
% m0_abs_9 = floor(abs(x_n_9 )/2^6);
% m0_abs_10= floor(abs(x_n_10)/2^6);
% m0_abs_11= floor(abs(x_n_11)/2^6);

m0_abs =  floor(abs(x_n)/2^4);
m0_abs_1 = floor(abs(x_n_1 )/2^4);
m0_abs_2 = floor(abs(x_n_2 )/2^4);
m0_abs_3 = floor(abs(x_n_3 )/2^4);
m0_abs_4 = floor(abs(x_n_4 )/2^4);
m0_abs_5 = floor(abs(x_n_5 )/2^4);
m0_abs_6 = floor(abs(x_n_6 )/2^4);
m0_abs_7 = floor(abs(x_n_7 )/2^4);
m0_abs_8 = floor(abs(x_n_8 )/2^4);
m0_abs_9 = floor(abs(x_n_9 )/2^4);
m0_abs_10= floor(abs(x_n_10)/2^4);
m0_abs_11= floor(abs(x_n_11)/2^4);


%% 第0级记忆深度
% lookup in  table

for n=1:length(m0_abs)
    m0_lut(n) =   LUT1(1,LUT2(m0_abs(n)+1)+1) ;
    m0_lut_1(n) = LUT1(2,LUT2(m0_abs_1(n)+1)+1) ;
    m0_lut_2(n) = LUT1(3,LUT2(m0_abs_2(n)+1)+1) ;    
    m0_lut_3(n) = LUT1(4,LUT2(m0_abs_3(n)+1)+1);     
    m0_lut_4(n) = LUT1(5,LUT2(m0_abs_4(n)+1)+1); 
    m0_lut_5(n) = LUT1(6,LUT2(m0_abs_5(n)+1)+1);     
end

m0_lut_sum = m0_lut+ m0_lut_1 + m0_lut_2 + m0_lut_3 + m0_lut_4 + m0_lut_5;

m0_data_out = m0_lut_sum.* x_n;
m0_data_out_cut = floor(m0_data_out/2^13);
%% 第1级记忆深度

for n=1:length(m0_abs_1)
    m1_lut(n) =   LUT1(7,LUT2(m0_abs(n)+1)+1) ;
    m1_lut_1(n) = LUT1(8,LUT2(m0_abs_1(n)+1)+1) ;
    m1_lut_2(n) = LUT1(9,LUT2(m0_abs_2(n)+1)+1) ;    
    m1_lut_3(n) = LUT1(10,LUT2(m0_abs_3(n)+1)+1);     
end
m1_lut_sum = m1_lut+ m1_lut_1 + m1_lut_2 + m1_lut_3;

m1_data_out = m1_lut_sum.* x_n_1;
m1_data_out_cut = floor(m1_data_out/2^13);
%% 第2级记忆深度
% lookup in  table

for n=1:length(m0_abs_2)
    m2_lut(n) =   LUT1(11 ,LUT2(m0_abs(n)+1)+1) ;
    m2_lut_1(n) = LUT1(12,LUT2(m0_abs_1(n)+1)+1) ;
    m2_lut_2(n) = LUT1(13,LUT2(m0_abs_2(n)+1)+1);    
    m2_lut_3(n) = LUT1(14,LUT2(m0_abs_3(n)+1)+1) ;     
    m2_lut_4(n) = LUT1(15,LUT2(m0_abs_4(n)+1)+1) ; 
end

m2_lut_sum = m2_lut+ m2_lut_1 + m2_lut_2 + m2_lut_3 + m2_lut_4;

m2_data_out = m2_lut_sum.* x_n_2;
m2_data_out_cut = floor(m2_data_out/2^13);
%% 第3级记忆深度
% lookup in  table

for n=1:length(m0_abs_3)
    m3_lut(n) =   LUT1(16 ,LUT2(m0_abs_1(n)+1)+1) ;
    m3_lut_1(n) = LUT1(17,LUT2(m0_abs_2(n)+1)+1) ;
    m3_lut_2(n) = LUT1(18,LUT2(m0_abs_3(n)+1)+1) ;    
    m3_lut_3(n) = LUT1(19,LUT2(m0_abs_4(n)+1)+1) ;     
    m3_lut_4(n) = LUT1(20,LUT2(m0_abs_5(n)+1)+1) ; 
end

m3_lut_sum = m3_lut+ m3_lut_1 + m3_lut_2 + m3_lut_3 + m3_lut_4;

m3_data_out = m3_lut_sum.* x_n_3;
m3_data_out_cut = floor(m3_data_out/2^13);
%% 第4级记忆深度
% lookup in  table
for n=1:length(m0_abs_4)
    m4_lut(n) =   LUT1(21 ,LUT2(m0_abs_2(n)+1)+1) ;
    m4_lut_1(n) = LUT1(22,LUT2(m0_abs_3(n)+1)+1) ;
    m4_lut_2(n) = LUT1(23,LUT2(m0_abs_4(n)+1)+1) ;    
    m4_lut_3(n) = LUT1(24,LUT2(m0_abs_5(n)+1)+1) ;     
    m4_lut_4(n) = LUT1(25,LUT2(m0_abs_6(n)+1)+1) ; 
end
m4_lut_sum = m4_lut+ m4_lut_1 + m4_lut_2 + m4_lut_3 + m4_lut_4;

m4_data_out = m4_lut_sum.* x_n_4;
m4_data_out_cut = floor(m4_data_out/2^13);
%% 第5级记忆深度
% lookup in  table

for n=1:length(m0_abs_5)
    m5_lut(n) =   LUT1(26,LUT2(m0_abs_3(n)+1)+1) ;
    m5_lut_1(n) = LUT1(27,LUT2(m0_abs_4(n)+1)+1) ;
    m5_lut_2(n) = LUT1(28,LUT2(m0_abs_5(n)+1)+1) ;    
    m5_lut_3(n) = LUT1(29,LUT2(m0_abs_6(n)+1)+1) ;     
    m5_lut_4(n) = LUT1(30,LUT2(m0_abs_7(n)+1)+1) ; 
end
m5_lut_sum = m5_lut+ m5_lut_1 + m5_lut_2 + m5_lut_3 + m5_lut_4;

m5_data_out_old = m5_lut_sum;

for n=1:length(m0_abs_5)
    m5_lut_add(n) =   LUT_add(1,LUT2(m0_abs_4(n)+1)+1) ;
end

m5_data_out_add = m5_lut_add.* (abs(x_n_3 )/1024);
m5_data_out = (m5_data_out_old + m5_data_out_add).* x_n_5;

m5_data_out_cut = floor(m5_data_out/2^13);
%% 第6级记忆深度
% lookup in  table

for n=1:length(m0_abs_6)
    m6_lut(n) =   LUT1(31,LUT2(m0_abs_4(n)+1)+1) ;
    m6_lut_1(n) = LUT1(32,LUT2(m0_abs_5(n)+1)+1) ;
    m6_lut_2(n) = LUT1(33,LUT2(m0_abs_6(n)+1)+1) ;    
    m6_lut_3(n) = LUT1(34,LUT2(m0_abs_7(n)+1)+1) ;     
    m6_lut_4(n) = LUT1(35,LUT2(m0_abs_8(n)+1)+1) ; 
end

m6_lut_sum = m6_lut+ m6_lut_1 + m6_lut_2 + m6_lut_3 + m6_lut_4;

m6_data_out_old = m6_lut_sum;

for n=1:length(m0_abs_6)
    m6_lut_add(n) =   LUT_add(2,LUT2(m0_abs_5(n)+1)+1) ;
end

m6_data_out_add = m6_lut_add.* (abs(x_n_4 )/1024);
m6_data_out =(m6_data_out_old + m6_data_out_add).* x_n_6;

m6_data_out_cut = floor(m6_data_out/2^13);
%% 第7级记忆深度
% lookup in  table

for n=1:length(m0_abs_7)
    m7_lut(n) =   LUT1(36,LUT2(m0_abs_5(n)+1)+1) ;
    m7_lut_1(n) = LUT1(37,LUT2(m0_abs_6(n)+1)+1) ;
    m7_lut_2(n) = LUT1(38,LUT2(m0_abs_7(n)+1)+1) ;    
    m7_lut_3(n) = LUT1(39,LUT2(m0_abs_8(n)+1)+1) ;     
    m7_lut_4(n) = LUT1(40,LUT2(m0_abs_9(n)+1)+1) ; 
end

m7_lut_sum = m7_lut+ m7_lut_1 + m7_lut_2 + m7_lut_3 + m7_lut_4;

m7_data_out_old = m7_lut_sum;

for n=1:length(m0_abs_7)
    m7_lut_add(n) =   LUT_add(3,LUT2(m0_abs_6(n)+1)+1) ;
end

m7_data_out_add = m7_lut_add.* (abs(x_n_5 )/1024);
m7_data_out = (m7_data_out_old + m7_data_out_add).* x_n_7;

m7_data_out_cut = floor(m7_data_out/2^13);
%% 第8级记忆深度
% lookup in  table

for n=1:length(m0_abs_8)
    m8_lut(n) =   LUT1(41,LUT2(m0_abs_6(n)+1)+1) ;
    m8_lut_1(n) = LUT1(42,LUT2(m0_abs_7(n)+1)+1) ;
    m8_lut_2(n) = LUT1(43,LUT2(m0_abs_8(n)+1)+1) ;    
    m8_lut_3(n) = LUT1(44,LUT2(m0_abs_9(n)+1)+1) ;     
    m8_lut_4(n) = LUT1(45,LUT2(m0_abs_10(n)+1)+1) ; 
end

m8_lut_sum = m8_lut+ m8_lut_1 + m8_lut_2 + m8_lut_3 + m8_lut_4;

m8_data_out_old = m8_lut_sum;

for n=1:length(m0_abs_8)
    m8_lut_add(n) =   LUT_add(4,LUT2(m0_abs_7(n)+1)+1) ;
end

m8_data_out_add = m8_lut_add.* (abs(x_n_6 )/1024);
m8_data_out = (m8_data_out_old + m8_data_out_add).* x_n_8;

m8_data_out_cut = floor(m8_data_out/2^13);
%% 第9级记忆深度
% lookup in  table

for n=1:length(m0_abs_9)
    m9_lut(n) =   LUT1(46,LUT2(m0_abs_7(n)+1)+1) ;
    m9_lut_1(n) = LUT1(47,LUT2(m0_abs_8(n)+1)+1) ;
    m9_lut_2(n) = LUT1(48,LUT2(m0_abs_9(n)+1)+1) ;    
    m9_lut_3(n) = LUT1(49,LUT2(m0_abs_10(n)+1)+1) ;     
    m9_lut_4(n) =0 ; 
end

m9_lut_sum = m9_lut+ m9_lut_1 + m9_lut_2 + m9_lut_3 + m9_lut_4;

m9_data_out_old = m9_lut_sum;

for n=1:length(m0_abs_9)
    m9_lut_add(n) =   LUT_add(5,LUT2(m0_abs_8(n)+1)+1) ;
end

m9_data_out_add = m9_lut_add.* (abs(x_n_7 )/1024);
m9_data_out = (m9_data_out_old + m9_data_out_add).* x_n_9;

m9_data_out_cut = floor(m9_data_out/2^13);
%% 第10级记忆深度
% lookup in  table

for n=1:length(m0_abs_10)
    m10_lut(n) =   LUT1(50,LUT2(m0_abs_8(n)+1)+1) ;
    m10_lut_1(n) = LUT1(51,LUT2(m0_abs_9(n)+1)+1) ;
    m10_lut_2(n) = LUT1(52,LUT2(m0_abs_10(n)+1)+1);    
    m10_lut_3(n) =0 ;     
    m10_lut_4(n) = 0 ; 
end

m10_lut_sum = m10_lut+ m10_lut_1 + m10_lut_2 + m10_lut_3 + m10_lut_4;
m10_data_out_old = m10_lut_sum;

for n=1:length(m0_abs_10)
    m10_lut_add(n) =   LUT_add(6,LUT2(m0_abs_9(n)+1)+1) ;
end

m10_data_out_add = m10_lut_add.* (abs(x_n_8 )/1024);
m10_data_out = (m10_data_out_old + m10_data_out_add).* x_n_10;

m10_data_out_cut = floor(m10_data_out/2^13);

% %% 第11级记忆深度
% % lookup in  table
% for n=1:length(m0_abs_11)
%     m11_lut(n) =   LUT1(12,LUT2(m0_abs_11(n)+1)+1) ;
%     m11_lut_1(n) =0 ;
%     m11_lut_2(n) =0 ;    
%     m11_lut_3(n) =0 ;     
%     m11_lut_4(n) =0 ; 
% end
% 
% m11_lut_sum = m11_lut+ m11_lut_1 + m11_lut_2 + m11_lut_3 + m11_lut_4;
% 
% m11_data_out = m11_lut_sum.* x_n_11;
% m11_data_out_cut = floor(m11_data_out/2^13);
%% %%%%%%%%%%%%%%%%%%%%add all 11 mem%%%%%%%%%%%%%%%%%%%%%%%%%
data_out = m0_data_out+m1_data_out+m2_data_out+m3_data_out...
           + m4_data_out +m5_data_out+m6_data_out+m7_data_out...
           + m8_data_out +m9_data_out +m10_data_out ;
       
 data_cut = m0_data_out_cut+m1_data_out_cut+m2_data_out_cut+m3_data_out_cut...
           + m4_data_out_cut +m5_data_out_cut+m6_data_out_cut+m7_data_out_cut...
           + m8_data_out_cut +m9_data_out_cut +m10_data_out_cut ;

 

       
       
 %% 分析频谱
 fs=491.52
 %  before lut
 data_before_lut = x_n;
y1 = 20*log10(fftshift(abs(fft(data_before_lut)/length(data_before_lut)/2^15)));
xa = linspace(-fs/2,fs/2,length(data_before_lut));
figure(1)
plot(xa',y1);grid on;
mean_amp=mean(abs(data_before_lut).^2);
i_data_abfs0=10*log10(mean_amp/((2^15-1).^2))

%  after lut
 result = data_cut;
 %result = data_out;
y2 = 20*log10(fftshift(abs(fft(result)/length(result)/2^15)));
xa = linspace(-fs/2,fs/2,length(result));
figure(2)
plot(xa',y2);grid on;
mean_amp=mean(abs(result).^2);
i_data_abfs1=10*log10(mean_amp/((2^15-1).^2))

%% modelsim_result
tr_iq_hex = textread('G:/200M/toFPGA_testdata_58LUT_1220/dpd_result_vivado_58.txt','%s');
tr_hex = char(tr_iq_hex);
tr_dec = hex2dec(tr_hex);

tr_i= floor(tr_dec/2^16);
tr_q= mod(tr_dec,2^16);
 
fpga_i_sig = tr_i-(tr_i>=2^15)*2^16;
fpga_q_sig = tr_q-(tr_q>=2^15)*2^16;


mlt_i_sig = real(data_cut);
mlt_q_sig = imag(data_cut);


fpga_i=fpga_i_sig(11:end);
l= min(length(mlt_i_sig),length(fpga_i));
err_i=fpga_i(1:l)'-mlt_i_sig(1:l);


fpga_q=fpga_q_sig(11:end);
l= min(length(mlt_q_sig),length(fpga_q));
err_q=fpga_q(1:l)'-mlt_q_sig(1:l);

%% compare
s=textread('G:/200M/toFPGA_testdata_58LUT_1220/dpd_result_8192.txt','%s');
s_char=char(s);
s_dec= hex2dec(s_char);
data_i= floor(s_dec/2^16);
data_q= mod(s_dec,2^16);
 
data_i_sig = data_i-(data_i>=2^15)*2^16;
data_q_sig = data_q-(data_q>=2^15)*2^16;

mlt_i_sig = real(data_cut);
mlt_q_sig = imag(data_cut);
 
data = data_i_sig+1j* data_q_sig;
y = 20*log10(fftshift(abs(fft(data)/length(data)/2^15)));
xa = linspace(-fs/2,fs/2,length(data));
figure(3)
plot(xa',y);grid on;
mean_amp=mean(abs(data).^2);
i_data_abfs = 10*log10(mean_amp/((2^15-1).^2));

data_i_sig1=data_i_sig(11:end);
li= min(length(mlt_i_sig),length(data_i_sig1));
err_i_2=data_i_sig1(1:li)'-mlt_i_sig(1:li);

data_q_sig1=data_q_sig(11:end);
lq= min(length(mlt_q_sig),length(data_q_sig1));
err_q_1=data_q_sig1(1:lq)'-mlt_q_sig(1:lq);

[c,d]=xcorr(data_cut(1:end),data(11:end));
figure(4)
plot(d,c);


[c,d]=xcorr(mlt_i_sig(1:end),fpga_i_sig(11:end));
figure(5)
plot(d,c);









