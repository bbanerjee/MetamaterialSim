function [yf, yff] = FitLine( ff )

D1 = load('Sil83-1.dat');
D2 = load('Sil83-2.dat');
D3 = load('Sil83-3.dat');
D4 = load('Sil83-4.dat');

f = D1(:,1);
e1 = D1(:,2);
e2 = D2(:,2);
e3 = D3(:,2);
e4 = D4(:,2);
e = (e1+e2+e3+e4)/4;

[x,y] = polyfit(log(f),log(e),5);

fl = log( ff );

yff = polyval( x, fl );
yf = exp(yff);
