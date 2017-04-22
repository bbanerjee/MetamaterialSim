function [freqs,u] = RunBeamFR( hAcross, sType )

tic
freqs = [100:50:400,405:5:700,710:10:790,800:100:3000,3000:10:3100,3100:5:3300,3350:10:3500,3550:50:4500];
%freqs = [100:50:400,405:5:700,710:10:800];
freqs = [100:2:500];
n = length(freqs)
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
