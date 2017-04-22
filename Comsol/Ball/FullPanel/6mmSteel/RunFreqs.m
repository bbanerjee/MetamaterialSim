function [freqs,w,wi,w2] = RunFreqs

tic

freqs = [100:20:2200];
%freqs = 100:20:120;
freqs = [100:5:700];
n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n
  [w0,wi0,w20] = SymFreqs( freqs(i) );
  w(i) = w0;
  wi(i) = wi0;
  w2(i) = w20;
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete' )
  end
end

Fout = [ freqs; real(w); imag(w); real(wi); imag(wi); real(w2); imag(w2) ];
fl = fopen( 'Data/FRBalls.dat', 'wt' );
fprintf( fl, '%e %e %e %e %e %e %e\n', Fout );
fclose( fl );

toc
