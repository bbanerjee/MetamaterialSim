A = (.025/4)^2;
h = 0.025;
P = 1000;
F = P*A;

fr0 = load('../../../../Resonator-25/Array/OneMass/Data/FreqResp1.0.dat');
fr1 = load('../../../../Resonator-25/Array/OneMass/Data/FreqResp1.2.dat');
fr2 = load('../../../../Resonator-25/Array/TwoMass/Data/FreqResp1.2.dat');

f  = fr0(:,1);
om = (2*pi*f).^2;
w0 = fr0(:,2);
w1 = fr1(:,2);
w2 = fr2(:,2);

a0 = om.*w0;
a1 = om.*w1;
a2 = om.*w2;

r0 = P/h ./ a0;
r1 = P/h ./ a1;
rc = (r0 + r1)/2;
ac = P/h ./ rc;

semilogy( f,abs(F./ac),'k', f,abs(F./a2),'--k','LineWidth',1.5 );
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
%set(gca,'FontUnits','centimeters');
xlim([f(1),1000]);
f(1)
xlabel('f (Hz)');
ylabel('F/a (kg)');
legend('Double Resonator', 'Composite Accel.', 'Location','NorthEast');
