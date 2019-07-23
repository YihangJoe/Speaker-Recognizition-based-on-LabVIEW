% x=audioread('D:\Desktop\train\1.wav');
function ccc_1=mfcc1(x)
%%-------准备工作-------------
%归一化mel滤波器组系数(24个窗)
bank=melbankm2(24,256,8000,0,0.5,'m'); 
bank=full(bank);
bank=bank/max(bank(:));

%DCT系数，12(欲求的mfcc个数)×24
for k=1:12
 n=0:23;
 dctcoef(k,:)=cos(pi*k*(2*n+1)/(2*24));
end

%归一化的倒谱提升窗口
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

%--------提取特征-------------
%预加重滤波器
xx=double(x);
xx=filter([1 -0.9375],1,xx);

%语音信号分帧
xx=enframe(x,256,80);

%计算每帧的MFCC参数
for i=1:size(xx,1)
  y=xx(i,:);
  s=y'.*hamming(256);
  t=abs(fft(s));
  t=t.^2;
  c1=log(bank*t(1:129)); 
  c1=dctcoef*c1;
  c2=c1.*w';
  m(i,:)=c2';
end
%求一阶差分系数
dtm=zeros(size(m));
for i=3:size(m,1)-2
    dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;
%求取二阶差分系数
dtmm=zeros(size(dtm));
for i=3:size(dtm,1)-2
    dtmm(i,:)=-2*dtm(i-2,:)-dtm(i-1,:)+dtm(i+1,:)+2*dtm(i+2,:);
end
dtmm=dtmm/3;
%合并mfcc参数和一阶差分mfcc参数
ccc=[m dtm dtmm];
%去除首尾两帧，以为这两帧的一阶差分参数为0
ccc=ccc(3:size(m,1)-2,:);
ccc;
ccc_1=ccc(:,1);

% plot(ccc_1);title('MFCC');ylabel('幅值');