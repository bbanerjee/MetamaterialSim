function [freqs,w,w1] = RunFreqs

tic

freqs = [100:10:300,301:500,510:10:1000];
n = length(freqs);
strcat( num2str(n), ' iterations' )
for i = 1:n
  w(i) = SymFreqs(freqs(i), 1);
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/FreqRespUMF.dat';
Fout = [ freqs; real(w); imag(w) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );
w1 = w;
toc

tic

freqs = [100:10:300,301:500,510:10:1000];
n = length(freqs);
strcat( num2str(n), ' iterations' )
for i = 1:n
  w(i) = SymFreqs(freqs(i), 0);
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/FreqRespSP.dat';
Fout = [ freqs; real(w); imag(w) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );

toc
%exit
