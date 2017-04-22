function [y,v] = BeamMassV( f )
%  m = Mass on beam
%  J = Moment of inertia of m
%  d = distance from tip to cog of m

omega = 2 * pi * f;
Fin = 1000;

%  Material Properties
rho = 7850;
rho2 = 100*7850;
E = 2.0e11;

%  Dimensions
b = 1.e-3;
L = 4.e-2;
h = 1.e-3;
A = b*h;
I = b^3*h/12;
blk = 1.e-2;
y = 0:(L/100):L;

d = 5.e-4;
l = 2.e-3;
d0 = 0*d/2;
m = rho*d*l*h;
J = m*(d^2+l^2)/12;

M0 = rho * blk^2 * h;
F = Fin * blk * h;
lambda = ( rho * A / E / I * 4 * pi^2 .* f.^2 ) .^ (1/4);

%  Constants
a = lambda*L;
b = m/rho/A/L;
k = J./m;
if( m == 0 )
    k = 0;
end
R1 = b .* a.^3 .* ( (k+d0.^2) / L^2 );
R2 = b .* a.^2 .* ( d0 / L );

s = sin(a);
sh = sinh(a);
c = cos(a);
ch = cosh(a);

F1 = 1 + c.*ch - s.*sh - 2*b.*a.*s.*ch - 2*R1.*c.*sh + (R1.*b.*a-R2.^2).*(1-c.*ch+s.*sh);
F2 = 1 + c.*ch + s.*sh + 2*b.*a.*c.*sh - 2*R1.*s.*ch + (R1.*b.*a-R2.^2).*(1-c.*ch-s.*sh);
F3 = (s.*ch+c.*sh).*(1-R1.*b.*a+R2.^2) + 2*( c.*ch.*b.*a - R1.*s.*sh - R2.*(s.*ch-c.*sh) );
D = 1 + c.*ch - b.*a.*(s.*ch-c.*sh) - R1.*( s.*ch + c.*sh - b.*a.*(1-c.*ch) ) - 2*R2.*s.*sh - R2.^2.*(1-c.*ch);

v = 1./(2*D) * ( F1*cos(lambda*y) + F2*cosh(lambda*y) + F3*(sin(lambda*y)-sinh(lambda*y)) );

