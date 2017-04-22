function [u,ml,ms,A] = BMTheory( f )
%  m = Mass on beam
%  J = Moment of inertia of m

omega = 2 * pi * f;
Fin = 1000;

%  Dimensions
%  Thickness
th = 19.0e-3;

%  Base (Center)
cx = 5.e-3;
cy = 16.e-3;
Ac = cy*th;
Vc = Ac*cx;

%  Beam
bx = 1.6e-3;
by = 14.0e-3;
Ab = by*th;
Vb = Ab*bx;
Ib = bx^3*th/12;

%  Mass
mx = 15.0e-3;
my = 15.0e-3;
Am = my*th;
Vm = Am*mx;

%  Material Properties
E = 2.0e11;
rho0 = 7700;
rhoc = ( Vc*rho0+260.e-3 ) / Vc;
rhob = rho0;
rhom = rho0;

%  Mass Properties
m = rhom * Vm;
J = m/12 * ( mx^2 + my^2 );
M0 = rhoc * Vc;
F = Fin * Ac;

%  Constants
lambda = ( rhob * Ab / E / Ib * 4 * pi^2 .* f.^2 ) .^ (1/4);
a = lambda * by;
b = m / rhob / Ab / by;
k = sqrt(J./m);
l = my/2;
if( m == 0 )
    k = 0;
end

R1 = b .* a.^3 .* ( ( k^2 + l^2 ) / by^2 );
R2 = b .* a.^2 .* ( l / by );
s = sin(a);
sh = sinh(a);
c = cos(a);
ch = cosh(a);

F1 = 1 + c.*ch - s.*sh - 2*b.*a.*s.*ch - 2*R1.*c.*sh + (R1.*b.*a-R2.^2).*(1-c.*ch+s.*sh);
F2 = 1 + c.*ch + s.*sh + 2*b.*a.*c.*sh - 2*R1.*s.*ch + (R1.*b.*a-R2.^2).*(1-c.*ch-s.*sh);
F3 = (s.*ch+c.*sh).*(1-R1.*b.*a+R2.^2) + 2*( c.*ch.*b.*a - R1.*s.*sh - R2.*(s.*ch-c.*sh) );
D = 1 + c.*ch - b.*a.*(s.*ch-c.*sh) - R1.*( s.*ch + c.*sh - b.*a.*(1-c.*ch) ) - 2*R2.*s.*sh - R2.^2.*(1-c.*ch);

uL = 1./(2*D) .* ( F1.*c + F2.*ch + F3.*(s-sh) );
uyL = 1./(2*D) .* lambda .* ( -F1.*s + F2.*sh + F3.*(c-ch) );
uyyL = 1./(2*D) .* lambda.^2 .* ( -F1.*c + F2.*ch - F3.*(s+sh) );
uyyyL = 1./(2*D) .* lambda.^3 .* ( F1.*s + F2.*sh - F3.*(c+ch) );

M1 = rhob*Ab./(2*D.*lambda) .* ( F1.*s + F2.*sh - F3.*(c+ch-2) );
M = M0 + 2 * ( M1 + m*uL + m*(my/2)*uyL ); 

M1(length(M1));
uL(length(uL));
uyL(length(uyL));

u = F ./ M ./ omega.^2;
ml = Vc*rhoc + Vb*rhob + Vm*rhom;
ms = Vc*rhoc;
A = Ac;

