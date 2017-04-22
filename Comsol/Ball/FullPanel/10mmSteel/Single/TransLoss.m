function [tl] = TransLoss( f, a, P )
% f - frequency vector
% a - acceleration 
% P - applied pressure

rho = 1.2;
c = 344;

omega = 2*pi * f;
v = a ./ (j * omega);

z = P ./ v;

tl = 20 * log10( abs( 1 + z / 2 / rho / c ) );
