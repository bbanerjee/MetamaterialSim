function [freqs,w,wi] = RunFreqs2

cd ../Single
[f,ww] = RunFreqs;
cd ../FreqRho

tic

Vtot = 0.13^2 * 0.019;
Vres = 68 * ( 4/3 * pi * .007^3 );
Vbal = 68 * ( 4/3 * pi * .003^3 );
Vsil = Vres - Vbal;
Vepx = Vtot - Vres;
m0 = Vsil * 1300 + Vepx * 1180 + Vbal * 7780;

ld = load('../Single/Data/FreqResp.dat');
freqs = ld(:,1);
u = ld(:,2);
A = .015*.015/4;
a = -(2*pi*freqs).^2 .* u;
m = 1000 * A ./ a;
m = m * m0/m(1);
rho = m / Vtot;

freqs = transpose( freqs );
rho = transpose( rho );

n = length(freqs);
strcat( num2str(n), ' iterations' )

if( 3 > 2 )
for i = 1:n
  [w0,wi0] = SymFreqs( freqs(i), rho(i) );
  w(i) = w0;
  wi(i) = wi0;
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete' )
  end
end

Fout = [ freqs; real(w); imag(w); real(wi); imag(wi); rho ];
fl = fopen( 'Data/FreqResp.dat', 'wt' );
fprintf( fl, '%e %e %e %e %e %e\n', Fout );
fclose( fl );
end
toc




