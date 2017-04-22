function [freqs,w,wi] = RunFreqs

tic

ld = load('../Single/Data/FreqResp.dat');
freqs = ld(:,1);
P = 1000;
A = .016*.028/4;
V = A * .019;
f = freqs;
u = ld(:,2);
a = -(2*pi*f).^2 .* u;
m = P * A ./ a;
rho = m / V;

freqs = transpose( freqs );
rho = transpose( rho );

n = length(freqs);
strcat( num2str(n), ' iterations' )

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

toc




