A = .015^2;
P = 1000;
F1 = 1000*A;

fr6 = load('../Single/Data/FreqResp.dat');
fr10 = load('../10mm/Single/Data/FreqResp0.dat');

f0 = fr6(:,1);
w0 = fr6(:,2);

f1 = fr10(:,1);
w1 = fr10(:,2);

P = 1000;
om0 = j*2*pi*f0;
om1 = j*2*pi*f1;

Fa0 = abs( F1 ./ ( om0.^2 .* w0 ) );
Fa1 = abs( F1 ./ ( om1.^2 .* w1 ) );

semilogy( f0,Fa0,'k', f1,Fa1,'--k', 'LineWidth',1.5 );
xlim([0 2200]);
%ylim([1.e-3,1.e3]);
set(gca,'FontName','Arial');
set(gca,'FontSize', 16);
xlabel('f (Hz)');
ylabel('F/a (kg)');
legend('6mm Ball', '10mm Ball', 'Location','NorthEast');
