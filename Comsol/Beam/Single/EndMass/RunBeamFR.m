function [freqs,u] = RunBeamFR( hAcross, sType )

tic
freqs = [3000:10:4000];
strcat(num2str(length(freqs)),' iterations')
n = length(freqs);
for i = 1:n
  u(i) = BeamFR( freqs(i), hAcross, sType );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flbase = 'Data/BeamFR';
flend = '.dat';
flmid = num2str( sType );
flname = strcat( flbase, flmid, flend );
Fout = [ freqs; abs(u); real(u); imag(u) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e\n', Fout );
fclose( fl );

toc
