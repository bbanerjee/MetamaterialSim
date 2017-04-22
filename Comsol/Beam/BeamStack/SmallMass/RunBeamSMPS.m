function [freqs,u] = RunBeamSMPS( hAcross )

tic
freqs = [1:0.25:1000];
strcat(num2str(length(freqs)),' iterations')
n = length(freqs);
for i = 1:n
  u(i) = BeamSMPS( freqs(i), hAcross );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/BeamSMPS.dat';
Fout = [ freqs; abs(u); real(u); imag(u) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e\n', Fout );
fclose( fl );

toc
