function [freqs,w] = RunFreqsNoFixed( mScale )

tic

freqs = [100:10:300,301:500,510:10:1000];
n = length(freqs);
strcat( num2str(n), ' iterations' )
for i = 1:n
  w(i) = SymFreqsNoFixed(freqs(i), mScale);
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flbase = 'Data/FreqRespNF';
flend = '-2.dat';
flmid = num2str( mScale );
flname = strcat( flbase, flmid, flend );
Fout = [ freqs; w ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e\n', Fout );
fclose( fl );

toc
%exit
