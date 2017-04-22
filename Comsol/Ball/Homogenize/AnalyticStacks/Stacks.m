function [f,w,tl,w0,tl0,ws,tls,L] = Stacks( nRes, h, eta )

rf = load('Rho_f.mat');
rho = rf.rho1(1:1500);
f = rf.f(1:1500);

m1 = 0.0041;
m2 = 0.0041;
M0 = 0.0139;
F = 1000*.023*.023;
w0 = 400;

%f = 1:0.1:2000;
omega = 2*pi*f;

k1 = 000*(1+eta*i*omega);
k2 = 0000*(1+eta*i*omega);
K2 = 1.175e5*.023^2/h*(1+eta*i*omega);

%Meff = M0 + 2*k1*m1./(2*k1-m1*omega.^2) + 2*k2*m2./(2*k2-m2*omega.^2);
Meff = 0.023^3 * rho;
Meff = 0.023^3 * 1180 * ones(size(f));

Msil = (nRes-1)*1300*.023^2*h;

for j = 1:length(f)
  m0 = 2*K2(j) - omega(j)*Meff(j);
  k0 = -K2(j);
  K = diag( m0*ones(nRes,1) ) + diag( k0*ones(nRes-1,1), 1 ) + diag( k0*ones(nRes-1,1), -1 );
  K(1,1) = m0 + k0;
  K(nRes,nRes) = m0 + k0;
  
  b = zeros(nRes,1);
  b(1)           =  F;

  w_temp = K\b;
  w(j) = w_temp(nRes);
end

w0 = - F ./ (nRes*(M0+m1+m2)) ./ omega.^2;
Mtot = Meff(1)*nRes + Msil+9*Meff(f);
w0 = -F ./ Mtot ./ omega.^2;
v0 = i*omega.*w0;
z0 = 1000./v0;
tl0 = 20 * log10( abs( 1 + .5/1.2/344 * z0 ) );


v = i*omega.*w;
z = 1000./v;
tl = 20 * log10( abs( 1 + .5/1.2/344 * z ) );

a = -omega.^2.*w;

Ms = 19000 * .023*.023* ( nRes*.023 + (nRes-1)*h )
ws = -F ./ Ms ./ omega.^2;
vs = i*omega.*ws;
zs = 1000./vs;
tls = 20 * log10( abs( 1 + .5/1.2/344 * zs ) );

L = nRes*.023 + (nRes-1)*h;
