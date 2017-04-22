clc, clear all, close all,

%temp= ;c=344.2*sqrt(temp/19.85);
%press= ;rho=1.186*((press*19.85)/(101.325*temp));
cs=344;
a='trac621';
b='trac622';
c='trac623';
d='trac624';
e='trac625';
g='trac626';
ep=0.45; %epaisseur de l'échantillon testé'

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
load(a)
HP1R=o2i1;
load(b)
HP2R=o2i1;
load(e)
HP3R=o2i1;
load(g)
HP4R=o2i1;
f=o2i1x;

k=2*pi().*f/cs;%-i.*1.94.*exp(-2.*sqrt(f)./(0.09*cs));

x1=-0.257;
x2=-0.187;
x3=-x2+ep;
x4=-x1+ep;

rho=1.2;

%==============TRANSFERT FUNCTIONS==========================
figure, plot(f,HP1R,'r'), hold on, plot(f,HP2R,'g'), hold on, plot(f,HP3R,'b'), hold on, plot(f,HP4R,'c'), hold on, grid on,
subplot(2,2,1),plot(f,-20*log10(HP1R),'r'), title('transfert function (in dB) 1(red),2(green),3(blue),4(cyan)'),hold on,plot(f,-20*log10(HP2R),'g'),hold on,plot(f,-20*log10(HP3R),'b'),hold on,plot(f,-20*log10(HP4R),'c'),hold on,grid on

%==============AMPLITUDES===================================
A=i*(HP1R.*exp(i.*k.*x2)-HP2R.*exp(i.*k.*x1))./(2*sin(k.*(x1-x2)));
B=i*(HP2R.*exp(-i.*k.*x1)-HP1R.*exp(-i.*k.*x2))./(2*sin(k.*(x1-x2)));
C=i*(HP3R.*exp(i.*k.*x4)-HP4R.*exp(i.*k.*x3))./(2*sin(k.*(x3-x4)));
D=i*(HP4R.*exp(-i.*k.*x3)-HP3R.*exp(-i.*k.*x4))./(2*sin(k.*(x3-x4)));
C=C.*exp(-i.*k.*ep);
D=D.*exp(i.*k.*ep);

subplot(2,2,2),plot(f,A,'r'), title('Amplitudes A(red),B(green),C(blue),D(cyan)'), hold on,plot(f,B,'g'), hold on,plot(f,C,'b'), hold on,plot(f,D,'c'), hold on,grid on
subplot(2,2,3),plot(f,(A-C)./A),title('% of difference between A & C'),grid on,axis([0 1600 -5 100]),

%==============Pression & Velocity==========================

p0=A+B; 
v0=(A-B)/(rho*cs);
pd=C.*exp(-i.*k.*ep)+D.*exp(i.*k.*ep);
vd=(C.*exp(-i.*k.*ep)-D.*exp(i.*k.*ep))/(rho*cs);
subplot(2,2,4),plot(f,(pd-p0)./pd),title('% of difference between p0 & pd'),grid on,axis([0 1600 -5 100]),

%==============Transfert matrix=============================
T11=(pd.*vd+p0.*v0)./(p0.*vd+pd.*v0);
T12=p0.*p0-pd.*pd;
T21=v0.*v0-vd.*vd;
T22=T11;
subplot(2,2,4), plot(f,T11,'b'),grid on, hold on, axis([0 1600 -5 5]),title('T12 in red & T11 in blue')%,plot(f,T12,'r'),hold on, 

%==============Transmission loss coefficient=============================
TL=10*log10((1/4)*abs(T11+T12/(rho*cs)+rho*cs*T21+T22).*abs(T11+T12/(rho*cs)+rho*cs*T21+T22));


T=(B.*D-A.*C)./(D.*D-A.*A);
R=(A.*B-C.*D)./(A.*A-D.*D);
lim=-0.5:0.01:1.5;
IA1=10*log(1./abs(T));

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


load(a)
HP1R=o2i1;
load(c)
HP2R=o2i1;
load(d)
HP3R=o2i1;
load(g)
HP4R=o2i1;
f=o2i1x;

k=2*pi().*f/cs;
x1=-0.257;
x2=-0.137;
x3=-x2+ep;
x4=-x1+ep;
%xi=(257,187,137);
rho=1.2;

%==============AMPLITUDES===================================
A=i*(HP1R.*exp(i.*k.*x2)-HP2R.*exp(i.*k.*x1))./(2*sin(k.*(x1-x2)));
B=i*(HP2R.*exp(-i.*k.*x1)-HP1R.*exp(-i.*k.*x2))./(2*sin(k.*(x1-x2)));
C=i*(HP3R.*exp(i.*k.*x4)-HP4R.*exp(i.*k.*x3))./(2*sin(k.*(x3-x4)));
D=i*(HP4R.*exp(-i.*k.*x3)-HP3R.*exp(-i.*k.*x4))./(2*sin(k.*(x3-x4)));
C=C.*exp(-i.*k.*ep);
D=D.*exp(i.*k.*ep);
%==============Pression & Velocity==========================

p0=A+B; 
v0=(A-B)/(rho*cs);
pd=C.*exp(-i.*k.*ep)+D.*exp(i.*k.*ep);
vd=(C.*exp(-i.*k.*ep)-D.*exp(i.*k.*ep))/(rho*cs);

%==============Transfert matrix=============================
T11=(pd.*vd+p0.*v0)./(p0.*vd+pd.*v0);
T12=p0.*p0-pd.*pd;
T21=v0.*v0-vd.*vd;
T22=T11;

%==============Transmission loss coefficient=============================
TL2=10*log10((1/4)*abs(T11+T12/(rho*cs)+rho*cs*T21+T22).*abs(T11+T12/(rho*cs)+rho*cs*T21+T22));

T2=(B.*D-A.*C)./(D.*D-A.*A);
R=(A.*B-C.*D)./(A.*A-D.*D);
lim=-0.5:0.01:1.5;
IA2=10*log(1./abs(T2));

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


load(b)
HP1R=o2i1;
load(c)
HP2R=o2i1;
load(d)
HP3R=o2i1;
load(e)
HP4R=o2i1;
f=o2i1x;

k=2*pi().*f/cs;
x1=-0.187;
x2=-0.137;
x3=-x2+ep;
x4=-x1+ep;
%xi=(257,187,137);
rho=1.2;


%==============AMPLITUDES===================================
A=i*(HP1R.*exp(i.*k.*x2)-HP2R.*exp(i.*k.*x1))./(2*sin(k.*(x1-x2)));
B=i*(HP2R.*exp(-i.*k.*x1)-HP1R.*exp(-i.*k.*x2))./(2*sin(k.*(x1-x2)));
C=i*(HP3R.*exp(i.*k.*x4)-HP4R.*exp(i.*k.*x3))./(2*sin(k.*(x3-x4)));
D=i*(HP4R.*exp(-i.*k.*x3)-HP3R.*exp(-i.*k.*x4))./(2*sin(k.*(x3-x4)));
C=C.*exp(-i.*k.*ep);
D=D.*exp(i.*k.*ep);
%==============Pression & Velocity==========================

p0=A+B; 
v0=(A-B)/(rho*cs);
pd=C.*exp(-i.*k.*ep)+D.*exp(i.*k.*ep);
vd=(C.*exp(-i.*k.*ep)-D.*exp(i.*k.*ep))/(rho*cs);

%==============Transfert matrix=============================
T11=(pd.*vd+p0.*v0)./(p0.*vd+pd.*v0);
T12=p0.*p0-pd.*pd;
T21=v0.*v0-vd.*vd;
T22=T11;

%==============Transmission loss coefficient=============================
TL3=10*log10((1/4)*abs(T11+T12/(rho*cs)+rho*cs*T21+T22).*abs(T11+T12/(rho*cs)+rho*cs*T21+T22));
T3=(B.*D-A.*C)./(D.*D-A.*A);
R=(A.*B-C.*D)./(A.*A-D.*D);
lim=-0.5:0.01:1.5;
IA3=10*log(1./abs(T3));


%load(['Z:\xavierbremaud On My Mac\Stage NZ\mesurescube\trac203.mat']);
%figure,plot(f,TL),title('TL (in dB) in function of the frequency'),grid on,hold on,plot(o2i1x,20*log10(abs(o2i1)),'b'),xlabel('frequency (Hz)'),ylabel('magnitude (dB)'),legend('Spherical resonator - steel - 10mm')

figure,plot(f,TL),grid on,axis([50 2300 0 70]),legend('transmission loss of a sample hardly clamped')
%figure, plot(f,[T abs(R)]),grid on,axis([100 1800 -0.2 1.2]),xlabel('frequency (Hz)'),ylabel('transmission coefficient & reflexion coefficient'),legend('transmission coefficient','reflexion coefficient')
%figure,subplot(2,1,1),semilogy(f,abs(T2),'g'),hold on,semilogy(f,abs(T3),'c'),hold on,semilogy(f,abs(T),'b'),hold on, plot(f,abs(R),'r'),xlabel('frequency (Hz)'),ylabel('Transmission coefficient(blue) & Reflexion coefficient(red)'),grid on,hold on,plot(330,lim,'x'),axis([50 2300 -0.5 1.5])
%ubplot(2,1,2),plot(f,10*log10(1+(11^2.*f.*f.*pi()^2)./(rho*cs)^2),'c'),hold on,grid on,axis([50 2300 -10 120]),plot(f,TL,'g'),hold on,plot(f,TL2,'r'),hold on, plot(f,TL3,'c'),hold on,legend('theory Gip board','t1256','t1346','t2345')
