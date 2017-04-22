function [freqs,w] = RunBeam

tic
freqs = [1:4,5:5:495,500:0.5:600,605:5:1200];
strcat(num2str(length(freqs)),' iterations')
n = length(freqs);
for i = 1:n
  w(i) = NewBeamCentered( freqs(i) );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/BeamCenterFine.dat';
Fout = [ freqs; abs(w); w ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e \n', Fout );
fclose( fl );

toc
