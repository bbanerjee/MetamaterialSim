function [freqs,u,v] = RunBeamFR( hAcross, sType, Fphi )

tic

freqs = [100:50:400,405:5:700,710:10:800];
size(freqs)
for i = 1:length(freqs)
  [a,b] = BeamFR( freqs(i), hAcross, sType, Fphi );
  u(i) = a;
  v(i) = b;
end

flbase = 'Data/BeamFR';
flend = '.dat';
flmid = num2str( sType );
flname = strcat( flbase, flmid, flend );
Fout = [ freqs; u; v ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );

toc
