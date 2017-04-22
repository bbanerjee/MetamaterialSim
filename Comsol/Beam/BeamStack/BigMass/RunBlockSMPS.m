function [u] = RunBlockSMPS( freqs, hAcross )

tic
strcat(num2str(length(freqs)),' iterations')
n = length(freqs);
for i = 1:n
  u(i) = BlockSMPS( freqs(i), hAcross );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = 'Data/BlockSMPS.dat';
Fout = [ freqs; abs(u); real(u); imag(u) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e\n', Fout );
fclose( fl );

toc
