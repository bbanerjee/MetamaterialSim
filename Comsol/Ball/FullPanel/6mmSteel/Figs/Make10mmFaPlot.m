rho = 1.2;
c = 344;
m = 0.621;
A = (.1015/2)^2 * pi;
A1 = A/4;
P = 1000;
F1 = 1000*A1;

fr0 = load('../10mm/Data/FRFine.dat');
fr1 = load('../10mm/FreqRho/Data/FreqResp.dat');

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

Fa0 = 4 * abs( F1 ./ ( om0.^2 .* w0 ) );
Fa1 = 4 * abs( F1 ./ ( om1.^2 .* w1 ) );

semilogy( f0,Fa0,'k', f1,Fa1,'--k', f2,m,'-+k', 'LineWidth',1.5 );
xlim([0 2200]);
ylim([1.e-3,1.e3]);
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
xlabel('f (Hz)');
ylabel('F/a (kg)');
legend('Detailed', 'Homogenized', 'Mass Law', 'Location','NorthEast');
