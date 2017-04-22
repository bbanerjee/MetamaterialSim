function [freqs,w] = RunFreqs

tic

freqs = [2:2:2200];

n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n

  w(i) = SymFreqs( freqs(i) );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end

end

flname = 'Data/FreqResp0.dat';
Fout = [ freqs; real(w); imag(w) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );

toc
