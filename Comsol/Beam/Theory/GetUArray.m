function [u0,M] = GetUArray( f, L, b )

Fin = -1000;
h = 1.e-3;
rho = 7850;
E = 2.0e11;
blk = 1.e-2;
omega = 2 * pi * f;
F = Fin * blk * h * length(b);

M = rho * blk^2 * h * length(b);
for i = 1:length(L)
  lambda = ( 48*pi^2 * rho / E / b(i)^2 .* f.^2 ) .^ (1/4);
  a = lambda*L(i);
  s = sin(a);
  sh = sinh(a);
  c = cos(a);
  ch = cosh(a);
M = M + rho*b(i)*h ./ lambda .* (s.*ch+c.*sh)./(c.*ch+1);
end

u0 = F ./ M ./ omega.^2;

