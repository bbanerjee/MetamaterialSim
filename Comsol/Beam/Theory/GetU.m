function [u0,u1,M] = GetU( f )

Fin = -1000;
b = 5.e-4;
L = 4.e-2;
h = 1.e-3;
rho = 7850;
E = 2.0e11;
blk = 5.e-3;
omega = 2 * pi * f;


M0 = rho * blk^2 * h;
F = Fin * blk * h;

lambda = ( 48*pi^2 * rho / E / b^2 .* f.^2 ) .^ (1/4);
a = lambda*L;

s = sin(a);
sh = sinh(a);
c = cos(a);
ch = cosh(a);

M = M0 + rho*b*h ./ lambda .* (s.*ch+c.*sh)./(c.*ch+1);
u0 = F ./ M ./ omega.^2;
u1 = u0 / 2. / (c.*ch+1) .* ( (s.*ch+c.*sh).*s + (c.*ch+1-s.*sh).*c - (s.*ch+c.*sh).*sh + (c.*ch+1+s.*sh).*ch );

F1 = c.*ch+1-s.*sh;
F2 = c.*ch+1+s.*sh;
F3 = s.*ch+c.*sh;

uyL   = lambda .* ( -F1.*s + F2.*sh + F3.*(c-ch) );
uyyL  = lambda.^2 .* ( -F1.*c + F2.*ch + F3.*(-s-sh) );
uyyyL = lambda.^3 .* ( F1.*s + F2.*sh + F3.*(-c-ch) );

yc = s.*sh ./ lambda ./ F3;
u1 = yc;
