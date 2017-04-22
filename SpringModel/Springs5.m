function Springs5

  ii=10;
  %for ii=2:4:20
    Springs5Plot(ii);
  %end
%
% n = number of masses
%
function Springs5Plot(n)

  L = 0.05;
  R = 0.05;
  A = pi*R^2;
  A = 1;
  l = L/n;
  E_stiff = 70e5;
  E_soft = 1e5;
  rho_stiff = 3000;
  rho_soft = 1200;
  K_stiff = E_stiff*A/l
  K_soft = E_soft*A/l
  K_stiff = K_stiff*(1+0.1*i);
  K_soft = K_soft*(1+0.1*i);
  M_stiff = rho_stiff*(A*l)
  M_soft = rho_soft*(A*l)

  k = ones(n+1,1);
  count = 0;
  for ii=1:n+1
    count = count + 1;
    if (count < 2)
      k(ii) = K_stiff;
    else
      k(ii) = K_soft;
    end
    if (count > 10)
      count = 0;
    end
  end
  % Harmonic mean k
  H_k = 0;
  for ii=1:length(k)
    H_k = H_k + 1/k(ii);
  end
  K0 = 1/H_k
  
  M0 = M_stiff;
  m1 = ones(n,1);
  count = 0;
  for ii=1:n
    count = count + 1;
    if (count < 5)
      m1(ii) = M_stiff;
    else
      m1(ii) = M_soft;
    end
    if (count > 10)
      count = 0;
    end
  end

  f_inp = 1;

  omega = 1:10:2000;
  [TL] = calcTL(K0, M0, m1, k, n, omega, f_inp);
  [TL_direct] = calcTLDirect(K0, M0, m1, k, n, omega, f_inp);
  [TL_mass] = calcMassTL(M0, m1, n, omega);

  figure
  plot(omega, TL); hold on;
  plot(omega, TL_mass, 'r-');
  plot(omega, TL_direct, 'm-');
  %figure
  %semilogy(omega, u_sol);
  %figure
  %plot(omega, m_u);
  %plot(omega, log(abs(m_u)));

function [R_tl] = calcTL(K0, M0, m, k, n, omega, f_inp)

  K = zeros(n+2,n+2);
  M = zeros(n+2,n+2);
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
  K(n+1,n+1) = k(n) + 2*K0;
  K(n+1,1) = -K0;
  M(n+1,n+1) = m(n);
  %M(n+1,n+1) = 0;

  % Add another spring-mass
  K(n+1,n+2) = -K0;
  K(n+2,n+1) = -K0;
  K(n+2,n+2) = K0;
  M(n+2,n+2) = M0;
  
  K
  M
  [usol, omegasq] = eig(K,M);
  sum(diag(M))
  
  f = zeros(n+2,1);
  f(1) = f_inp;
  for jj=1:length(omega)
    uvec = zeros(n+2,1);
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
  
function [R_tl] = calcTLDirect(K0, M0, m, k, n, omega, f_inp)

  K = zeros(n+2,n+2);
  M = zeros(n+2,n+2);
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
  K(n+1,n+1) = k(n) + 2*K0;
  K(n+1,1) = -K0;
  M(n+1,n+1) = m(n);
  
  % Add another spring-mass
  K(n+1,n+2) = -K0;
  K(n+2,n+1) = -K0;
  K(n+2,n+2) = K0;
  M(n+2,n+2) = M0;

  K;
  M;
  [usol, omegasq] = eig(K,M);
  sum(diag(M))
  
  f = zeros(n+2,1);
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
  
function [R_mass] = calcMassTL(M0, m1, n, omega)

  mass = M0 + M0;
  for ii=1:n
    mass = mass + m1(ii);
  end
  mass
  for jj=1:length(omega)
    z = i*omega(jj)*mass;

    rho = 1.2;
    c = 344;
    R_mass(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
  end
