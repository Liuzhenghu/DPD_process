function [ x ] = fa_mag_compute( data_i,data_q )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 输入参数为       ：
%                 data_i：I路输入数据
%                 data_q：Q路输入数据
%                 
% 输出参数为        x：输入数据幅值
%                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=data_i;
y=data_q;
a=0;
d=1;
k=0.6073;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mapper%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(x)
    if x(i)<0
        x(i)=abs(x(i))-1;
    end
    if y(i)<0
        y(i)=abs(y(i))-1;
    end
end
for qq=1:length(x)
    if y(qq)>x(qq)
        t=x(qq);
        x(qq)=y(qq);
        y(qq)=t;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end mapper%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cordic stages%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii=1:length(x)
for a=0:5
    if y(ii)>=0;
        d=1;
    else
        d=-1;
    end
    xNew=x(ii);
    yNew=y(ii);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % if ((yNew<0)&(xNew<0))
% %     yNew=abs(yNew);
% %     y1=dec2bin(yNew,16);
% %     y2=y1(1:(16-a));
% %     y3=bin2dec(y2);
% %     yNew=(-1)*yNew;
% %     x(ii)=xNew+(-1)*d*y3;
% %     xNew=abs(xNew);
% %     x1=dec2bin(xNew,16);
% %     x2=x1(1:(16-a));
% %     x3=bin2dec(x2);
% %     xNew=(-1)*xNew;
% %     y(ii)=yNew-(-1)*d*x3;
% % elseif  (xNew<0)
% %     xNew=abs(xNew);
% %     y1=dec2bin(yNew,16);
% %     y2=y1(1:(16-a));
% %     y3=bin2dec(y2);
% %     xNew=(-1)*xNew;
% %     x(ii)=xNew+d*y3;
% %     x1=dec2bin(xNew,16);
% %     x2=x1(1:(16-a));
% %     x3=bin2dec(x2);
% %     y(ii)=yNew-(-1)*d*x3;
% % elseif  (yNew<0)
% %     yNew=abs(yNew);
% %     y1=dec2bin(yNew,16);
% %     y2=y1(1:(16-a));
% %     y3=bin2dec(y2);
% %     x(ii)=xNew+(-1)*d*y3;
% %     x1=dec2bin(xNew,16);
% %     x2=x1(1:(16-a));
% %     x3=bin2dec(x2);
% %     yNew=(-1)*yNew;
% %     y(ii)=yNew-d*x3;
% % else
% %     y1=dec2bin(yNew,16);
% %     y2=y1(1:(16-a));
% %     y3=bin2dec(y2);
% %     x(ii)=xNew+d*y3;
% %     x1=dec2bin(xNew,16);
% %     x2=x1(1:(16-a));
% %     x3=bin2dec(x2);
% %     y(ii)=yNew-d*x3;
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aa=floor(yNew*(1/2^a));
    x(ii)=xNew+d*aa;
    bb=floor(xNew*(1/2^a));
    y(ii)=yNew-d*bb;
%     a=a+1;
%     x(ii)=x(ii)+(y(ii)*d*(1/2^a));
%     y(ii)=y(ii)-(x(ii)*d*(1/2^a));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x(ii)=(x(ii)*256-x(ii))+(x(ii)*64-x(ii)*8);
x1=dec2bin(x(ii),25);
x2=x1(1:16);
x3=bin2dec(x2);
x(ii)=x3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x(ii)=k*x(ii);
y(ii)=y(ii);
ii=ii+1;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end cordic stages%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=round(x);
end

