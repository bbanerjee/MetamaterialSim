function [freqs,w,wi] = RunFreqs

tic

freqs = [10,20:20:2200];
%freqs = 100:20:120;
%freqs = 10;
n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n
  [w0,wi0] = SymFreqs( freqs(i) );
  w(i) = w0;
  wi(i) = wi0;
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete' )
  end
end

Fout = [ freqs; real(w); imag(w); real(wi); imag(wi) ];
fl = fopen( 'Data/FRFine.dat', 'wt' );
fprintf( fl, '%e %e %e %e %e\n', Fout );
fclose( fl );

toc
