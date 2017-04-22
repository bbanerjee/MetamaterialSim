function Springs6

  nval = 10;
  %Kfac = [1.0e-4 1.0e-2 1.0];
  %for jj = 1:length(Kfac)
  %  Springs6Plot(jj, 2*nval, 2, Kfac(jj), 1.0, [0 0 1], 1);
  %  Springs6Plot(jj, 2*nval, 3, Kfac(jj), 1.0, [0.25 0.75 0.25], 1);
  %  Springs6Plot(jj, 2*nval, 4, Kfac(jj), 1.0, [0.75 0.25 0.1], 1);
  %  Springs6Plot(jj, 2*nval, 5, Kfac(jj), 1.0, [0.1 0.1 0.5], 1);
  %  Springs6Plot(jj, 2*nval, 8, Kfac(jj), 1.0, [0.9 0.1 0.3], 1);
  %end
  rhofac = [0.5 1 3];
  for jj = 1:length(rhofac)
    Springs6Plot(jj, 2*nval, 2, 1.0, rhofac(jj), [0 0 1], 1);
    Springs6Plot(jj, 2*nval, 3, 1.0, rhofac(jj), [0.25 0.75 0.25], 1);
    Springs6Plot(jj, 2*nval, 4, 1.0, rhofac(jj), [0.75 0.25 0.1], 1);
    Springs6Plot(jj, 2*nval, 5, 1.0, rhofac(jj), [0.1 0.1 0.5], 1);
    Springs6Plot(jj, 2*nval, 8, 1.0, rhofac(jj), [0.9 0.1 0.3], 1);
  end

%
% n = number of masses
%
function Springs6Plot(plotnum, n, period, Kfac, rhofac, color, damp)

  L = 0.05;
  R = 0.05;
  A = pi*R^2;
  l = L/(n+1);
  E_stiff = 70e9*Kfac;
  E_soft = 1e5;
  rho_stiff = 3000*rhofac;
  rho_soft = 1200;
  K_stiff = E_stiff*A/l
  K_soft = E_soft*A/l
  if (damp == 1)
    K_stiff = K_stiff*(1+0.1*i);
    K_soft = K_soft*(1+0.1*i);
  else
    K_stiff = K_stiff;
    K_soft = K_soft;
  end
  M_stiff = rho_stiff*(A*l);
  M_soft = rho_soft*(A*l);

  n_mass = n;
  n_spring = n_mass + 1;

  k = ones(n+1,1);
  m = ones(n,1);
  stiff = true;
  count = 1;
  for ii=1:n_spring-1
    if (mod(count, period) == 0) 
      if (stiff == true)
        stiff = false;
        count = 1;
      else
        stiff = true;
        count = 1;
      end
    end
    count = count + 1;
    if (stiff == true)
      k(ii) = K_stiff;
      m(ii) = M_stiff;
    else
      k(ii) = K_soft;
      m(ii) = M_soft;
    end
  end
  k(n_spring) = K_stiff;

  % Harmonic mean k
  H_k = 0;
  for ii=1:length(k)
    H_k = H_k + 1/k(ii);
  end
  K0 = 1/H_k

  M0 = M_stiff;

  % k = ones(n+1,1);
  % count = 0;
  % for ii=1:n+1
  %   count = count + 1;
  %   if (count < 2)
  %     k(ii) = K_stiff;
  %   else
  %     k(ii) = K_soft;
  %   end
  %   if (count > 10)
  %     count = 0;
  %   end
  % end

  % m = ones(n,1);
  % count = 0;
  % for ii=1:n
  %   count = count + 1;
  %   if (count < 2)
  %     m(ii) = M_stiff;
  %   else
  %     m(ii) = M_soft;
  %   end
  %   if (count > 10)
  %     count = 0;
  %   end
  % end

  f_inp = 1;

  omega = 1:20:8000;
  [TL_direct, M_eff_dir] = calcTLDirect(K0, M0, m, k, n, omega, f_inp);
  [TL_mass] = calcMassTL(M0, m, n, omega);

  figure(plotnum);
  p0 = plot(omega, TL_mass, 'r--'); hold on;
  p2 = plot(omega, TL_direct, 'm-');
  set(p0, 'LineWidth', 3, 'Color', color); 
  set(p2, 'LineWidth', 3, 'Color', color);
  xlabel('Frequency', 'FontSize', 16);
  ylabel('Transmission loss (db)', 'FontSize', 16);
  set(gca, 'LineWidth', 2, 'FontSize', 16);
  axis square
  grid on

  filenum = num2str(n);
  if (damp == 1)
    filename = strcat('TLLayerElasBarDampRho',filenum,'-',num2str(plotnum), '.eps');
  else
    filename = strcat('TLLayerElasBarRho',filenum,'-',num2str(plotnum),'.eps');
  end
  print(gcf, '-depsc', filename);

  %figure(2*plotnum);
  %p4 = plot(omega, M_eff_dir/(2*M0)); hold on;
  %set(p4, 'LineWidth', 3, 'Color', color); 
  %xlabel('Frequency', 'FontSize', 16);
  %ylabel('Effective mass (M_{eff}/M_0)', 'FontSize', 16);
  %set(gca, 'LineWidth', 2, 'FontSize', 16);
  %set(gca, 'YLim', [-5 5]);
  %axis square
  %grid on
%
  %if (damp == 1)
  %  filename = strcat('EffMLayerElasBarDamp',filenum,'.eps');
  %else
  %  filename = strcat('EffMLayerElasBar',filenum,'.eps');
  %end
  %print(gcf, '-depsc', filename);

  
function [R_tl, M_eff] = calcTLDirect(K0, M0, m, k, n, omega, f_inp)

  for jj=1:length(omega)

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
    z = f_inp/v_sol;
  
    rho = 1.2;
    c = 344;
    R_tl(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
    M_eff(jj) = -i*f_inp/(v_sol*omega(jj));
  end
  
function [R_mass] = calcMassTL(M0, m, n, omega)

  mass = 2*M0;
  for ii=1:n
    mass = mass + m(ii);
  end
  mass
  for jj=1:length(omega)
    z = i*omega(jj)*mass;

    rho = 1.2;
    c = 344;
    R_mass(jj) = 20*log10(abs(1 + 0.5*z/(rho*c)));
  end
