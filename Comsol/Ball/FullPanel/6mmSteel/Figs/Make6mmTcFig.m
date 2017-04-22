rho = 1.2;
c = 344;
m = 0.440;
A = (.1015/2)^2 * pi;
A1 = A/4;

fr0 = load('../Data/FreqResp.dat');
fr1 = load('../FreqRho/Data/FreqResp.dat');

f0 = fr0(:,1);
w0 = fr0(:,4);

f1 = fr1(:,1);
w1 = fr1(:,4)/A1;
n = length(f1);
f2 = fr1(1:10:n,1);

P = 1000;
om0 = j*2*pi*f0;
om1 = j*2*pi*f1;
om2 = j*2*pi*f2;

z0 = P./(om0.*w0);
z1 = P./(om1.*w1);

T0 = 20*log10( abs( 1 + 1/2/rho/c*z0 ) );
T1 = 20*log10( abs( 1 + 1/2/rho/c*z1 ) );
Tm = 20*log10( abs( 1 + 1/2/rho/c * om2 * m / A ) );

plot( f0,T0,'k', f1,T1,'--k', f2,Tm,'-+k', 'LineWidth',1.5 );
axis([0 2200 0 110]);
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
%set(gca,'FontUnits','centimeters');
xlabel('f (Hz)');
ylabel('TL (dB)');
legend('Detailed', 'Homogenized', 'Mass Law', 'Location','NorthEast');
