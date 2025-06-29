low_2 = [0:1:255 0:1:255];
datai = zeros(512*84,1);
data_ii=zeros(512,1);
data_ii_add=zeros(512*84,1);
data_i_rotate=zeros(512*84,1);

dataq = zeros(512*84,1);
data_qq=zeros(512,1);
data_qq_add=zeros(512*84,1);
data_q_rotate=zeros(512*84,1);

for LUT_N=84:-1:1
    data_ii = LUT_N .*(2^8*ones(512,1)) + low_2.';
    data_ii_add = [data_ii ; zeros(83*512,1)];
    datai = data_i_rotate + data_ii_add;
    data_i_rotate = [zeros(512,1);datai(1:512*83)];
end

for LUT_N_2=84:-1:1
    data_qq = LUT_N_2 .*(2^8*ones(512,1)) + low_2.';
    data_qq_add = [data_qq ; zeros(83*512,1)];
    dataq = data_q_rotate + data_qq_add;
    data_q_rotate = [zeros(512,1);dataq(1:512*83)];
end
COEF_H_16 = 2^16.*dataq;
COEF = COEF_H_16 + datai;
data_in_hex=dec2hex(COEF);
fid=fopen('.\vector\LUT_84_ADD.txt','wt');
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
