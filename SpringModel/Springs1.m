function Springs1
  %k = 10^5*(1-0.001*i);
  k = 10^5*1;
  m = 2;
  m0 = 1;
  m1 = 1;
  G = 10;
  omega0 = sqrt(2*G/m1);
  n = 100;
  u = 1.0e-4;
  f_inp = 1;
  omega = 1:1:10000

  for ii=1:length(omega)
    m = m0 + m1*omega0^2/(omega0^2-omega(ii)^2);
    [TL(ii), u_sol(ii), m_u(ii)] = calcTL(k, m, n, omega(ii), u, f_inp);
    [TL_mass(ii)] = calcMassTL(m, n, omega(ii));
  end 
  figure
  semilogy(omega, TL); hold on;
  semilogy(omega, TL_mass, 'r-');
  figure
  semilogy(omega, u_sol);
  figure
  plot(omega, m_u);
  %plot(omega, log(abs(m_u)));

function [R_tl, u_sol, m_u] = calcTL(k, m, n, omega, u, f_inp)

  alpha = 2*k - m*omega^2;

  K = zeros(n,n);
  K(1,1) = alpha;
  K(1,2) = -k;
  for ii=2:n-1
    K(ii,ii-1) = -k;
    K(ii,ii) = alpha;
    K(ii,ii+1) = -k;
  end
  K(n,n-1) = -k;
  K(n,n) = alpha;
  
  K;
  Kinv = inv(K);
  f = zeros(n,1);
  f(1) = k*u;
  f(n) = k*u;
  
  uvec = Kinv*f;
  
  m_u = m*sum(uvec)/u + 1;
  
  u_sol = -f_inp/(m_u*omega^2);
  
  v_sol = -i*omega*u_sol;
  
  z = f_inp/v_sol;
  
  rho = 1.2;
  c = 344;
  R_tl = 20*log10(abs(1 + 0.5*z/(rho*c)));
  
function [R_mass] = calcMassTL(m, n, omega)

  mass = n*m + 1;
  z = i*omega*mass;

  rho = 1.2;
  c = 344;
  R_mass = 20*log10(abs(1 + 0.5*z/(rho*c)));
