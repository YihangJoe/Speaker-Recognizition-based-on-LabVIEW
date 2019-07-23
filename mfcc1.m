% x=audioread('D:\Desktop\train\1.wav');
function ccc_1=mfcc1(x)
%%-------׼������-------------
%��һ��mel�˲�����ϵ��(24����)
bank=melbankm2(24,256,8000,0,0.5,'m'); 
bank=full(bank);
bank=bank/max(bank(:));

%DCTϵ����12(�����mfcc����)��24
for k=1:12
 n=0:23;
 dctcoef(k,:)=cos(pi*k*(2*n+1)/(2*24));
end

%��һ���ĵ�����������
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

%--------��ȡ����-------------
%Ԥ�����˲���
xx=double(x);
xx=filter([1 -0.9375],1,xx);

%�����źŷ�֡
xx=enframe(x,256,80);

%����ÿ֡��MFCC����
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
%��һ�ײ��ϵ��
dtm=zeros(size(m));
for i=3:size(m,1)-2
    dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;
%��ȡ���ײ��ϵ��
dtmm=zeros(size(dtm));
for i=3:size(dtm,1)-2
    dtmm(i,:)=-2*dtm(i-2,:)-dtm(i-1,:)+dtm(i+1,:)+2*dtm(i+2,:);
end
dtmm=dtmm/3;
%�ϲ�mfcc������һ�ײ��mfcc����
ccc=[m dtm dtmm];
%ȥ����β��֡����Ϊ����֡��һ�ײ�ֲ���Ϊ0
ccc=ccc(3:size(m,1)-2,:);
ccc;
ccc_1=ccc(:,1);

% plot(ccc_1);title('MFCC');ylabel('��ֵ');