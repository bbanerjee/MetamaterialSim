function RunFreqs

tic

f = [200:5:1200];

n = length(f);
strcat( num2str(n), ' iterations' )

for i = 1:n
  w0(i) = FrSingle( f(i), 7780, 0.005, 1.5e5, 7.e-5 );
  w1(i) = FrSingle( f(i), 11340, 0.005, 1.5e5, 7.e-5 );
  w2(i) = FrSingle( f(i), 7780, 0.003, 1.5e5, 7.e-5 );
  w3(i) = FrSingle( f(i), 11340, 0.0053, 1.5e5, 7.e-5 );

  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = strcat( 'Data/ESil7.dat' );
Fout = [ f; real(w0); imag(w0); real(w1); imag(w1); real(w2); imag(w2); real(w3); imag(w3) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e %e %e %e %e %e\n', Fout );
fclose( fl );

clear

f = [200:5:1200];

n = length(f);
strcat( num2str(n), ' iterations' )

for i = 1:n
  w0(i) = FrSingle( f(i), 7780, 0.005, 1.4e5, 8.e-5 );
  w1(i) = FrSingle( f(i), 11340, 0.005, 1.4e5, 8.e-5 );
  w2(i) = FrSingle( f(i), 7780, 0.003, 1.4e5, 8.e-5 );
  w3(i) = FrSingle( f(i), 11340, 0.0053, 1.4e5, 8.e-5 );

  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = strcat( 'Data/ESil8.dat' );
Fout = [ f; real(w0); imag(w0); real(w1); imag(w1); real(w2); imag(w2); real(w3); imag(w3) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e %e %e %e %e %e\n', Fout );
fclose( fl );

clear

f = [200:5:1200];

n = length(f);
strcat( num2str(n), ' iterations' )

for i = 1:n
  w0(i) = FrSingle( f(i), 7780, 0.005, 1.5e5, 10.e-5 );
  w1(i) = FrSingle( f(i), 11340, 0.005, 1.5e5, 10.e-5 );
  w2(i) = FrSingle( f(i), 7780, 0.003, 1.5e5, 10.e-5 );
  w3(i) = FrSingle( f(i), 11340, 0.0053, 1.5e5, 10.e-5 );

  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

flname = strcat( 'Data/ESil10.dat' );
Fout = [ f; real(w0); imag(w0); real(w1); imag(w1); real(w2); imag(w2); real(w3); imag(w3) ];
fl = fopen( flname, 'wt' );
fprintf( fl, '%e %e %e %e %e %e %e %e %e\n', Fout );
fclose( fl );



toc
