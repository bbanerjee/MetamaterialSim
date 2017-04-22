function [f,w,tl,w0,tl0,ws,tls,D,M0] = Layers( n, h, d, eta, omega0 )

P = 1;
rc = 1.2 * 344 / 2;

L = 1.0;
A = L^2;
F = P * A;
D = n*d + (n-1)*h;

f = 1:10:15000;
omega = 2*pi*f;

rho1 = 2700;
rho2 = 1300;
rhos = 7850;
m1 = d*A * rho1;
m2 = h*A * rho2;

omega0 = 2*pi*ones(size(f)) * omega0;

k = 1.175e5 * A/h * ( 1 + eta*i*omega0 );

for j = 1:length(f)
  m0 = 2 * k(j) - omega(j).^2 * m1;
  k0 = -k(j);
  K = diag( m0*ones(n,1) ) + diag( k0*ones(n-1,1), 1 ) + diag( k0*ones(n-1,1), -1 );
  K(1,1) = m0 + k0;
  K(n,n) = m0 + k0;
  
  b = zeros(n,1);
  b(1) =  F;

  w_temp = K\b;
  w(j) = w_temp(n);
end

M0 = n * m1 + (n-1) * m2;
w0 = -F ./ M0 ./ omega.^2;
v0 = i*omega.*w0;
z0 = P./v0;
tl0 = 20 * log10( abs( 1 + z0/rc ) );

v = i*omega.*w;
z = P./v;
tl = 20 * log10( abs( 1 + z/rc ) );

Ms = rhos * A * ( n*d + (n-1)*h );
ws = -F / Ms ./ omega.^2;
vs = i*omega.*ws;
zs = P./vs;
tls = 20 * log10( abs( 1 + zs/rc ) );
