function [freqs,w] = RunFreqs( mScale )

tic

freqs = [100:10:300,301:500,510:10:1000];
for i = 1:length(freqs)
	    w(i) = SymFreqs(freqs(i), mScale);
end

flbase = 'Data/FreqResp';
flend = '.dat';
flmid = num2str( mScale );
flname = strcat( flbase, flmid, flend );
Fout = [ freqs; w ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e\n', Fout );
fclose( fl );

toc
exit
