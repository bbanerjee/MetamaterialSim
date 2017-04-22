function [freqs,w,v] = RunFreqsUP( betak )

tic

freqs = [10:100:810,820:10:1000,1020:20:1100,1200:100:2000];
beta0 = betak * 1.e-5;
eta = beta0 * 2*pi * 942;

n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n
  w(i) = SymRayleigh( freqs(i), beta0, 1 );
  v(i) = SymComplexE( freqs(i), eta, 1 );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = strcat( 'Data/FRUP-', num2str(betak), '.dat' );
Fout = [ freqs; real(w); imag(w); real(v); imag(v) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e %e\n', Fout );
fclose( fl );

toc
