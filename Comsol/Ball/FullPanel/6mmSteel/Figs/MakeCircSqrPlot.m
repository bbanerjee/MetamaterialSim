rho = 1.2;
c = 344;
ms = 1068 * .127^2 * .019;
mc = 1068 * .05^2 * pi * .019;
A = (.089/2)^2 * pi;
A1 = A/4;

fr0 = load('../../Blank/Data/FreqRespSquare.dat');
fr1 = load('../../Blank/Data/FreqRespCircle.dat');

f0 = fr0(:,1);
w0 = fr0(:,8);

f1 = fr1(:,1);
w1 = fr1(:,6)/A1;
n = length(f1);
f2 = fr1(1:10:n,1);

P = 1000;
om0 = 2*pi*f0;
om1 = 2*pi*f1;
om2 = j*2*pi*f2;

alf0 = ms * om0.^2 .* w0;
alf1 = mc * om1.^2 .* w1;

z0 = P * (89/101.5)^2 * om0 ./ (-j*alf0);
z1 = P * om1 ./ (-j*alf1);

T0 = 20*log10( abs( 1 + 1/2/rho/c*z0 ) );
T1 = 20*log10( abs( 1 + 1/2/rho/c*z1 ) );
Tm = 20*log10( abs( 1 + 1/2/rho/c * om2 / A ) );

%plot(f0,T0,f1,T1,f2,Tm);
plot( f0,T0,'k', f1,T1,'--k', f2,Tm,'-+k', 'LineWidth',1.5 );
axis([0 2400 0 120]);
grid on;
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
%set(gca,'FontUnits','centimeters');
xlabel('f (Hz)');
ylabel('TL (dB)');
legend('Square Slab', 'Circular Slab', 'Mass Law', 'Location','NorthWest');
