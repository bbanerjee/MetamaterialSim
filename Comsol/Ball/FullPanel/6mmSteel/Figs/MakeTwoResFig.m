A = (.025/4)^2;
h = 0.025;
P = 1000;
F = P*A;

fr0 = load('../../../../Resonator-25/Array/OneMass/Data/FreqResp1.0.dat');
fr1 = load('../../../../Resonator-25/Array/OneMass/Data/FreqResp1.2.dat');

f  = fr0(:,1);
om = (2*pi*f).^2;
w0 = fr0(:,2);
w1 = fr1(:,2);

a0 = om.*w0;
a1 = om.*w1;

semilogy( f,abs(F./a0),'k', f,abs(F./a1),'--k','LineWidth',1.5 );
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
xlim([f(1),1000]);
xlabel('f (Hz)');
ylabel('F/a (kg)');
legend('10mm Ball', '12mm Ball', 'Location','NorthEast');
