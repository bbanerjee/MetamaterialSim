function [freqs,w,v] = RunFreqs( betak )

tic

freqs = [10:10:800,820:20:1000,1050:50:1200,1300:100:2000];
eta = betak * 2*pi * 492;

n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n
  w(i) = SymComplexE( freqs(i), eta, 0 );
  v(i) = SymComplexE( freqs(i), eta, 1 );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = strcat( 'Data/FR--', num2str(betak), '.dat' );
Fout = [ freqs; real(w); imag(w); real(v); imag(v) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );

toc
