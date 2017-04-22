function Springs4

  ii=4;
  for ii=2:4:20
    Springs4Plot(ii);
  end
%
% n = number of masses
%
function Springs4Plot(n)

  K0 = 10^16;
  %K = 10^5*(1+0.01*i);
  K = 10^5;
  %K_plus = 1.10*K;
  %K_minus = 0.90*K;
  %K_plus = 10*K;
  %K_minus = 0.1*K;
  %k = K_minus + (K_plus - K_minus).*rand(n+1,1);
  k = K*ones(n+1,1);
  
  G = 10;
  M0 = 1;
  %m0 = 1;
  m0 = 0;
  M = 1;
  %M_plus = 1.10*M;
  %M_minus = 0.90*M;
  %M_plus = 10*M;
  %M_minus = 0.1*M;
  %m1 = M_minus + (M_plus - M_minus).*rand(n,1);
  m1 = M*ones(n,1);

  u = 1.0e-4;
  f_inp = 1;

  omega = 1:10:2000;
  [TL] = calcTL(K0, M0, G, m0, m1, k, n, omega, u, f_inp);
  [TL_direct] = calcTLDirect(K0, M0, G, m0, m1, k, n, omega, u, f_inp);
  [TL_mass] = calcMassTL(M0, m0, m1, n, omega);

  figure
  plot(omega, TL); hold on;
  plot(omega, TL_mass, 'r-');
  plot(omega, TL_direct, 'm-');
  %figure
  %semilogy(omega, u_sol);
  %figure
  %plot(omega, m_u);
  %plot(omega, log(abs(m_u)));

function [R_tl] = calcTL(K0, M0, G, m0, m1, k, n, omega, u, f_inp)

  for jj=1:n
    omega0 = sqrt(2*G/m1(jj));
    m(jj) = m0 + m1(jj);
  end

  K = zeros(n+1,n+1);
  M = zeros(n+1,n+1);
  K(1,1) = k(1) + K0;
  K(1,2) = -k(1);
  K(1,n+1) = -K0;
  M(1,1) = M0;
  %M(1,1) = 0;
  for ii=1:n-1
    alpha = k(ii)+k(ii+1);
    beta =  m(ii);
    K(ii+1,ii) = -k(ii);
    K(ii+1,ii+1) = alpha;
    K(ii+1,ii+2) = -k(ii+1);
    M(ii+1,ii+1) = beta;
  end
  K(n+1,n) = -k(n);
  K(n+1,n+1) = k(n) + K0;
  K(n+1,1) = -K0;
  M(n+1,n+1) = m(n);
  %M(n+1,n+1) = 0;
  
  K
  M
  [usol, omegasq] = eig(K,M);
  sum(diag(M))
  
  f = zeros(n+1,1);
  f(1) = f_inp;
  for jj=1:length(omega)
    uvec = zeros(n+1,1);
    for ii=1:length(omegasq)
      y = usol(:,ii)'*f/(omegasq(ii,ii)-omega(jj)^2);
      uvec = uvec + usol(:,ii)*y;
    end
  
    u_1 = uvec(1,1);
    u_sol = uvec(n+1,1);
    v_sol = i*omega(jj)*u_sol;
    %z = u_1/u_sol;
    z = f_inp/v_sol;
  
    rho = 1.2;
    c = 344;
    R_tl(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
  end
  
function [R_tl] = calcTLDirect(K0, M0, G, m0, m1, k, n, omega, u, f_inp)

  for jj=1:n
    omega0 = sqrt(2*G/m1(jj));
    m(jj) = m0 + m1(jj);
  end

  K = zeros(n+1,n+1);
  M = zeros(n+1,n+1);
  K(1,1) = k(1) + K0;
  K(1,2) = -k(1);
  K(1,n+1) = -K0;
  M(1,1) = M0;
  for ii=1:n-1
    alpha = k(ii)+k(ii+1);
    beta =  m(ii);
    K(ii+1,ii) = -k(ii);
    K(ii+1,ii+1) = alpha;
    K(ii+1,ii+2) = -k(ii+1);
    M(ii+1,ii+1) = beta;
  end
  K(n+1,n) = -k(n);
  K(n+1,n+1) = k(n) + K0;
  K(n+1,1) = -K0;
  M(n+1,n+1) = m(n);
  
  K
  M
  [usol, omegasq] = eig(K,M);
  sum(diag(M))
  
  f = zeros(n+1,1);
  f(1) = f_inp;
  for jj=1:length(omega)
    mat = K - omega(jj)^2*M;
    matinv = inv(mat);
    uvec = matinv*f;
  
    u_1 = uvec(1,1);
    u_sol = uvec(n+1,1);
    v_sol = i*omega(jj)*u_sol;
    %z = u_1/u_sol;
    z = f_inp/v_sol;
  
    rho = 1.2;
    c = 344;
    R_tl(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
  end
  
function [R_mass] = calcMassTL(M0, m0, m1, n, omega)

  mass = M0;
  for ii=1:n
    mass = mass + m0 + m1(ii);
  end
  mass
  for jj=1:length(omega)
    z = i*omega(jj)*mass;

    rho = 1.2;
    c = 344;
    R_mass(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
  end
