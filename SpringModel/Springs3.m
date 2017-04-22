function Springs3

  %nval = 1;
  nval = [2 5 7 10 20 100];
  for ii=1:length(nval)
    Springs3Plot(0, ii, nval(ii), [0 0 1], 1, 1);
    Springs3Plot(1.0e-6, ii, nval(ii), [0.25 0.75 0.25], 1, 1);
    Springs3Plot(1.0e-4, ii, nval(ii), [0.75 0.2 0.5], 1, 1);
    Springs3Plot(1.0e-3, ii, nval(ii), [0.75 0.25 0.1], 1, 1);
    Springs3Plot(1.0, ii, nval(ii), [0.1 0.1 0.5], 1, 1);
  end
%
% n = number of masses
%
function Springs3Plot(K0fac, plotnum, n, color, damp, scale)

  K0 = 10^9*K0fac;
  if (damp == 1)
    %K = 10^5*(1+0.5*i);
    K = 10^5*(1-0.3*i);
  else
    K = 10^5;
  end
  %K_plus = 1.10*K;
  %K_minus = 0.90*K;
  %K_plus = 10*K;
  %K_minus = 0.1*K;
  %k = K_minus + (K_plus - K_minus).*rand(n+1,1);
  k = K*ones(n+1,1);
  
  G = 10^4;
  M0 = 1;
  m0 = 1;
  M = 1;
  %M_plus = 1.10*M;
  %M_minus = 0.90*M;
  %M_plus = 10*M;
  %M_minus = 0.1*M;
  %m1 = M_minus + (M_plus - M_minus).*rand(n,1);
  m1 = M*ones(n,1);

  if (scale ==1)
    k = (n+1)/2*k;
    m0 = m0/n;
    m1 = 1/n*m1;
  end

  u = 1.0e-4;
  f_inp = 1;

  omega = 1:1:2000;
  %[TL_eig, M_eff_eig] = calcTLEig(K0, M0, G, m0, m1, k, n, omega, u, f_inp);
  [TL_direct, M_eff_dir] = calcTLDirect(K0, M0, G, m0, m1, k, n, omega, u, f_inp);
  [TL_mass] = calcMassTL(M0, m0, m1, n, omega);

  figure(2*plotnum-1);
  p0 = plot(omega, TL_mass, 'r--'); hold on;
  %p1 = plot(omega, TL_eig); 
  p2 = plot(omega, TL_direct, 'm-');
  set(p0, 'LineWidth', 3, 'Color', [1 0 0]); 
  %set(p1, 'LineWidth', 3, 'Color', [0.75 0.25 0.25]);
  set(p2, 'LineWidth', 3, 'Color', color);
  xlabel('Frequency', 'FontSize', 16);
  ylabel('Transmission loss (db)', 'FontSize', 16);
  set(gca, 'LineWidth', 2, 'FontSize', 16);
  axis square
  grid on

  filenum = num2str(n);
  if (damp == 1)
    filename = strcat('TLElasBarDamp',filenum,'.eps');
  else
    filename = strcat('TLElasBar',filenum,'.eps');
  end
  print(gcf, '-depsc', filename);

  figure(2*plotnum);
  %p3 = plot(omega, M_eff_eig/(2*M0)); hold on;
  p4 = plot(omega, M_eff_dir/(2*M0)); hold on;
  %set(p3, 'LineWidth', 3, 'Color', [0.75 0.25 0.25]);
  set(p4, 'LineWidth', 3, 'Color', color); 
  xlabel('Frequency', 'FontSize', 16);
  ylabel('Effective mass (M_{eff}/M_0)', 'FontSize', 16);
  set(gca, 'LineWidth', 2, 'FontSize', 16);
  set(gca, 'YLim', [-5 5]);
  axis square
  grid on

  if (damp == 1)
    filename = strcat('EffMElasBarDamp',filenum,'.eps');
  else
    filename = strcat('EffMElasBar',filenum,'.eps');
  end
  print(gcf, '-depsc', filename);

function [R_tl, M_eff] = calcTLEig(K0, M0, G, m0, m1, k, n, omega, u, f_inp)

  for jj=1:n
    omega0 = sqrt(2*G/m1(jj));
    %m(jj) = m0 + (omega0^2/(omega0^2-omega^2))*m1(jj);
    m(jj) = m0 + m1(jj);
  end

  K = zeros(n+2,n+2);
  M = zeros(n+2,n+2);
  K(1,1) = (k(1) + K0);
  K(1,2) = -k(1);
  K(1,n+2) = -K0;
  M(1,1) = M0;
  for ii=1:n
    alpha = k(ii)+k(ii+1);
    beta =  m(ii);
    K(ii+1,ii) = -k(ii);
    K(ii+1,ii+1) = alpha;
    K(ii+1,ii+2) = -k(ii+1);
    M(ii+1,ii+1) = beta;
  end
  K(n+2,n+1) = -k(n+1);
  K(n+2,n+2) = k(n+1) + K0;
  K(n+2,1) = -K0;
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
    u_sol = uvec(n+2,1);
    v_sol = i*omega(jj)*u_sol;
    %z = u_1/u_sol;
    z = f_inp/v_sol;
  
    rho = 1.2;
    c = 344;
    R_tl(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
    M_eff(jj) = -i*f_inp/(v_sol*omega(jj));
  end
  
function [R_tl, M_eff] = calcTLDirect(K0, M0, G, m0, m1, k, n, omega, u, f_inp)

  for jj=1:length(omega)
    for kk=1:n
      omega0 = sqrt(2*G/m1(kk));
      %m(kk) = m0 + (omega0^2/(omega0^2-omega(jj)^2))*m1(kk);
      m(kk) = m0 + m1(kk);
    end

    K = zeros(n+2,n+2);
    M = zeros(n+2,n+2);
    K(1,1) = (k(1) + K0);
    K(1,2) = -k(1);
    K(1,n+2) = -K0;
    M(1,1) = M0;
    for ii=1:n
      alpha = k(ii)+k(ii+1);
      beta =  m(ii);
      K(ii+1,ii) = -k(ii);
      K(ii+1,ii+1) = alpha;
      K(ii+1,ii+2) = -k(ii+1);
      M(ii+1,ii+1) = beta;
    end
    K(n+2,n+1) = -k(n+1);
    K(n+2,n+2) = k(n+1) + K0;
    K(n+2,1) = -K0;
    M(n+2,n+2) = M0;
  
    %K
    %M
    [usol, omegasq] = eig(K,M);
    sum(diag(M))
  
    f = zeros(n+2,1);
    f(1) = f_inp;
    mat = K - omega(jj)^2*M;
    matinv = inv(mat);
    uvec = matinv*f;
  
    u_1 = uvec(1,1);
    u_sol = uvec(n+2,1);
    v_sol = i*omega(jj)*u_sol;
    %z = u_1/u_sol;
    z = f_inp/v_sol;
  
    rho = 1.2;
    c = 344;
    R_tl(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
    M_eff(jj) = -i*f_inp/(v_sol*omega(jj));
  end
  
function [R_mass] = calcMassTL(M0, m0, m1, n, omega)

  mass = 2*M0;
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
