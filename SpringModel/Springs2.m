function Springs

  seed = rand('twister');
  ii = 1;
  nval = [2 5 7 10 20 100];
%  for ii=1:length(nval)
%    figure
%    Springs2Plot(seed, ii, nval(ii), 10, 1, [0.6 0.2 0.2], 0, 0, 1);
%    Springs2Plot(seed, ii, nval(ii), 1, 1, [0 0 1], 0, 0, 1);
%    Springs2Plot(seed, ii, nval(ii), 0.1, 1, [.25 .75 .25], 0, 0, 1);
%  end
%  for ii=1:length(nval)
%    figure
%    Springs2Plot(seed, ii, nval(ii), 1, 10, [0.6 0.2 0.2], 0, 0, 1);
%    Springs2Plot(seed, ii, nval(ii), 1, 1, [0 0 1], 0, 0, 1);
%    Springs2Plot(seed, ii, nval(ii), 1, 0.1, [.25 .75 .25], 0, 0, 1);
%  end
%  for ii=1:length(nval)
%    figure
%    %Springs2Plot(seed, ii, nval(ii), 1, 1, [0.0 0.0 1.0], 1, 0, 1);
%    %Springs2Plot(seed, ii, nval(ii), 1, 1, [0.25 0.75 0.25], 0, 0, 1);
%    Springs2Plot(seed, ii, nval(ii), 1, 1, [0.0 0.0 1.0], 0, 1, 1);
%    Springs2Plot(seed, ii, nval(ii), 1, 1, [0.25 0.75 0.25], 0, 0, 1);
%  end
  for ii=1:length(nval)
    figure
    Springs2Plot(seed, ii, nval(ii), 1, 1, [0.0 0.0 1.0], 0, 0, 0);
  end
%
% n = number of masses
%
function Springs2Plot(seed, plotnum, n, Kfac, Mfac, color, varyK, varyM, scale)

  %K = 10^5*(1-0.5*i)*Kfac;
  %K = 10^5*(1-0.3*i)*Kfac;
  K = 10^5*Kfac;
  if (varyK == 1) 
    K_plus = 2.00*K;
    K_minus = 0.1*K;
    %K_plus = 10*K;
    %K_minus = 0.1*K;
    rand('twister', seed);
    k = K_minus + (K_plus - K_minus).*rand(n+1,1);
  else
    k = K*ones(n+1,1);
  end

  % Scale
  if (scale ==1)
    k = (n+1)/2*k;
  end
  
  G = 0.1*K;
  M0 = 2*Mfac;
  m0 = 1*Mfac;
  M = 1*Mfac;
  if (varyM == 1)
    %M_plus = 1.10*M;
    %M_minus = 0.90*M;
    M_plus = 3*M;
    M_minus = 0.01*M;
    rand('twister', seed);
    m1 = M_minus + (M_plus - M_minus).*rand(n,1);
  else
    m1 = M*ones(n,1);
  end

  % Scale
  if (scale ==1)
    m0 = m0/n;
    m1 = 1/n*m1;
  end

  u = 1.0;
  f_inp = 1;
  %omega = 1:0.01:100;
  omega = 1:10:2000;
  %omega = 1:10:3000;
  %omega = 1:10:5000;
  %omega = [1 100];

  for ii=1:length(omega)
    [TL(ii), u_sol(ii), m_u(ii)] = calcTL(M0, G, m0, m1, k, n, omega(ii), u, f_inp);
    [TL_mass(ii)] = calcMassTL(M0, m0, m1, n, omega(ii));
  end 
  figure(plotnum)
  p1 = plot(omega, TL); hold on;
  p2 = plot(omega, TL_mass, 'r--');
  set(p1, 'LineWidth', 3, 'Color', color);
  set(p2, 'LineWidth', 3);
  %set(p2, 'LineWidth', 3, 'Color', color);
  xlabel('Frequency', 'FontSize', 16);
  ylabel('Transmission loss (db)', 'FontSize', 16);
  set(gca, 'LineWidth', 2, 'FontSize', 16);
  %set(gca, 'YLim', [0 20]);
  grid on
  axis square
  filenum = num2str(n);
  filename = strcat('TLSpringMassNoScale',filenum,'.eps');
  print(gcf, '-depsc', filename);
  %print -depsc TLSpringMass.eps
  %figure
  %semilogy(omega, u_sol);
  %figure
  %p3 = plot(omega, m_u/M0);
  %set(p3, 'LineWidth', 3, 'Color', color); hold on;
  %xlabel('Frequency', 'FontSize', 16);
  %ylabel('Effective mass (M_{eff}/M_0)', 'FontSize', 16);
  %set(gca, 'LineWidth', 2, 'FontSize', 16);
  %set(gca, 'YLim', [-5 5]);
  %axis square
  %grid on
  %filenum = num2str(n);
  %filename = strcat('EffMassStiff',filenum,'.eps');
  %print(gcf, '-depsc', filename);
  %print -depsc EffMass.eps
  %plot(omega, log(abs(m_u)));

function [R_tl, u_sol, m_u] = calcTL(M0, G, m0, m1, k, n, omega, u, f_inp)

  for jj=1:n
    omega0 = sqrt(2*G/m1(jj));
    %m(jj) = m0 + (omega0^2/(omega0^2-omega^2))*m1(jj);
    m(jj) = m0 + m1(jj);
  end

  K = zeros(n,n);
  f = zeros(n,1);

  alpha = k(1)+k(2) - m(1)*omega^2;
  if (n == 1)
    K(1,1) = alpha;
    f(1) = (k(1)+k(n+1))*u;
  else
    K(1,1) = alpha;
    K(1,2) = -k(2);
    for ii=2:n-1
      alpha = k(ii)+k(ii+1) - m(ii)*omega^2;
      K(ii,ii-1) = -k(ii);
      K(ii,ii) = alpha;
      K(ii,ii+1) = -k(ii+1);
    end
    %k(n+1) = k(n+1)/2;
    alpha = k(n)+k(n+1) - m(n)*omega^2;
    K(n,n-1) = -k(n);
    K(n,n) = alpha;
    f(1) = k(1)*u;
    f(n) = k(n+1)*u;
    %f(n) = k(n+1)*(-u);
    %f(n) = 0;
  end
  
  Kinv = inv(K);
  
  uvec = Kinv*f;
  
  m_u = M0;
  for ii=1:n
    m_u = m_u + m(ii)*uvec(ii)/u;
  end
  
  u_sol = -f_inp/(m_u*omega^2);
  
  v_sol = -i*omega*u_sol;
  
  z = f_inp/v_sol;
  
  rho = 1.2;
  c = 344;
  R_tl = 20*log10(abs(1 + 0.5*z/(rho*c)));
  
function [R_mass] = calcMassTL(M0, m0, m1, n, omega)

  mass = M0;
  for ii=1:n
    mass = mass + m0 + m1(ii);
  end
  z = i*omega*mass;

  rho = 1.2;
  c = 344;
  R_mass = 20*log10(abs(1 + 0.5*z/(rho*c)));
