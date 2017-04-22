function [freqs,u,v] = RunBeamFR( hAcross, sType )

tic
freqs = [10:5:10000];
size(freqs)

for i = 1:length(freqs)
  [a,b] = BeamAngleFR( freqs(i), hAcross, sType );
  u(i) = a;
  v(i) = b;
end

flbase = 'Data/BeamAngleFR';
flend = '.dat';
flmid = num2str( sType );
flname = strcat( flbase, flmid, flend );
Fout = [ freqs; u; v];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e\n', Fout );
fclose( fl );

toc
