function R = GetR( F, f, u )

rho = 1.2;
cs = 344;

z = F ./ ( 2*pi*j*f.*u ); 
R = 20 * log10( abs( 1 + 1 / 2 * z / rho / cs ) );
