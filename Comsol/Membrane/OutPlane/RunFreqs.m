function [freqs,w,w0,w1] = RunFreqs

tic

freqs = [100:10:300,301:600,610:10:1000];
freqs = [1:10:91];
n = length(freqs);
strcat( num2str(n), ' iterations' )

for i = 1:n
  [ww,ww0,ww1] = SymFreqs( freqs(i) );
  w(i) = ww;
  w0(i) = ww0;
  w1(i) = ww1;
  
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/FreqResp.dat';
Fout = [ freqs; w; w0; w1 ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e\n', Fout );
fclose( fl );

toc

