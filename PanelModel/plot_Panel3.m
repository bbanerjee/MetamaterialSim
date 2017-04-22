function plot_Panel3

  %
  % Panel with balls + silicone
  %
  mass = 0.10896;
  nnode = 415;
  rad = 0.5*8.5e-2;
  fnode = 1.0e-2;
  F = nnode*fnode;
  %A = 0.25*pi*rad^2;
  panel_len = 12.7e-2;
  A = 0.25*(panel_len^2);
  %
  load ModalPanel3_qtr.uz72085
  freq = ModalPanel3_qtr(:,1);
  uz_cen = ModalPanel3_qtr(:,2);
  load ModalPanel3_qtr.uz72535
  uz_mid = ModalPanel3_qtr(:,2);
  load ModalPanel3_qtr.uz72543
  uz_cor = ModalPanel3_qtr(:,2);
  %
  figure
  mode = 1;
  plotAcc(freq, uz_cen, uz_mid, uz_cor, mode);
  plotMassLawAccl(freq, mass, F, mode);
  title('Balls + Silicone');
  figure
  plotTL(freq, uz_cen, uz_mid, uz_cor, F, A);
  plotMassLawTL(freq, mass, A);
  title('6 mm Balls + Silicone');
  clear freq
  clear uz_cen
  clear uz_mid
  clear uz_cor

  %
  % Panel with balls + silicone + damping
  %
  load ModalPanel3_qtr_damp.uz72085
  freq = ModalPanel3_qtr_damp(:,1);
  uz_cen = ModalPanel3_qtr_damp(:,2);
  load ModalPanel3_qtr_damp.uz72535
  uz_mid = ModalPanel3_qtr_damp(:,2);
  load ModalPanel3_qtr_damp.uz72543
  uz_cor = ModalPanel3_qtr_damp(:,2);
  %
  figure
  plot(freq, uz_cen)
  figure
  plotAcc(freq, uz_cen, uz_mid, uz_cor, mode);
  plotMassLawAccl(freq, mass, F, mode);
  title('Balls + Silicone + Damping');
  figure
  plotTL(freq, uz_cen, uz_mid, uz_cor, F, A);
  plotMassLawTL(freq, mass, A);
  title('6 mm Balls + Silicone + Damping');
  clear freq
  clear uz_cen
  clear uz_mid
  clear uz_cor

  %
  % Panel with steel balls + no silicone
  %
  mass = 0.10559;
  nnode = 415;
  rad = 0.5*8.5e-2;
  fnode = 1.0e-2;
  F = nnode*fnode;
  A = 0.25*pi*rad^2;
  %
  load ModalPanel4_qtr.uz72085
  freq = ModalPanel4_qtr(:,1);
  uz_cen = ModalPanel4_qtr(:,2);
  load ModalPanel4_qtr.uz72535
  uz_mid = ModalPanel4_qtr(:,2);
  load ModalPanel4_qtr.uz72543
  uz_cor = ModalPanel4_qtr(:,2);
  %
  % figure
  % plotAcc(freq, uz_cen, uz_mid, uz_cor, mode);
  % title('Steel Balls + No Silicone');
  % figure
  % plotTL(freq, uz_cen, uz_mid, uz_cor, F, A);
  % plotMassLawTL(freq, mass, A);
  % title('6 mm Steel Balls + No Silicone');

  %
  % Panel with lead balls + no silicone
  %
  mass = 0.11244;
  nnode = 415;
  rad = 0.5*8.5e-2;
  fnode = 1.0e-2;
  F = nnode*fnode;
  A = 0.25*pi*rad^2;
  %
  load ModalPanel5_qtr.uz72085
  freq = ModalPanel5_qtr(:,1);
  uz_cen = ModalPanel5_qtr(:,2);
  load ModalPanel5_qtr.uz72535
  uz_mid = ModalPanel5_qtr(:,2);
  load ModalPanel5_qtr.uz72543
  uz_cor = ModalPanel5_qtr(:,2);
  %
  % figure
  % plotAcc(freq, uz_cen, uz_mid, uz_cor, mode);
  % title('6 mm Lead Balls + No Silicone');
  % figure
  % plotTL(freq, uz_cen, uz_mid, uz_cor, F, A);
  % plotMassLawTL(freq, mass, A);
  % title('Lead Balls + No Silicone');

%
% Plot acceleration
%
function [accl] = plotAcc(freq, u_center, u_middle, u_corner, mode)

  omega = 2*pi*freq;
  %
  uz = u_center;
  accl = abs(omega.^2.*uz);
  if (mode == 1)
    p1 = semilogy(freq, accl, 'r-', 'LineWidth', 3); hold on;
  else
    p1 = plot(freq, accl, 'r-', 'LineWidth', 3); hold on;
  end
  %
  uz = u_middle;
  accl = abs(omega.^2.*uz);
  if (mode == 1)
    p2 = semilogy(freq, accl, 'g-', 'LineWidth', 3); hold on;
  else
    p2 = plot(freq, accl, 'g-', 'LineWidth', 3); hold on;
  end
  %
  uz = u_corner;
  accl = abs(omega.^2.*uz);
  if (mode == 1)
    p3 = semilogy(freq, accl, 'b-', 'LineWidth', 3); hold on;
  else
    p3 = plot(freq, accl, 'b-', 'LineWidth', 3); hold on;
  end
  %
  xlabel('Frequency (cycles/s)');
  ylabel('Acceleration (m/s^2)');
  %
  legend([p3 p2 p1], 'Center', 'Middle', 'Corner');
  set(gca, 'LineWidth', 3, 'FontSize', 18, 'FontName', 'times');
  grid on;

%
% Plot mass law acceleration
%
function plotMassLawAccl(freq, mass, F, mode)

  accl = MassLawAccl(mass, F);
  for ii=1:length(freq)
    aa(ii) = accl;
  end
  if (mode == 1)
    p = semilogy(freq, aa, 'k--', 'LineWidth', 3); hold on;
  else
    p = plot(freq, aa, 'k--', 'LineWidth', 3); hold on;
  end
  xlabel('Frequency (cycles/s)');
  ylabel('Accleration (m/s)');
  set(gca, 'LineWidth', 3, 'FontSize', 18, 'FontName', 'times');

%
% Plot transmission loss
%
function plotTL(freq, u_center, u_middle, u_corner, F, A)

  omega = 2*pi*freq;
  %
  uz = u_center;
  tl = TransLoss(omega, uz, F, A);
  p1 = plot(freq, tl, 'r-', 'LineWidth', 3); hold on;
  %
  uz = u_middle;
  tl = TransLoss(omega, uz, F, A);
  p2 = plot(freq, tl, 'g-', 'LineWidth', 3); hold on;
  %
  uz = u_corner;
  tl = TransLoss(omega, uz, F, A);
  p3 = plot(freq, tl, 'b-', 'LineWidth', 3); hold on;
  %
  xlabel('Frequency (cycles/s)');
  ylabel('TL (dB)');
  %
  legend([p3 p2 p1], 'Center', 'Middle', 'Corner');
  set(gca, 'LineWidth', 3, 'FontSize', 18, 'FontName', 'times');
  grid on;

%
% Plot mass law transmission loss
%
function plotMassLawTL(freq, mass, A)

  omega = 2*pi*freq;
  tl_m = MassLawTL(omega, mass, A);
  p = plot(freq, tl_m, 'k--', 'LineWidth', 3); hold on;
  xlabel('Frequency (cycles/s)');
  ylabel('TL (dB)');
  set(gca, 'LineWidth', 3, 'FontSize', 18, 'FontName', 'times');

%
% Calculate transmission loss
%   omega - frequency vector (radians/sec)
%   a - acceleration 
%   P - applied pressure
%
function [tl] = TransLoss(omega, uz, F, A )

  P = F/A;
  rho = 1.2;
  c = 344;

  v = -j*omega.*uz;

  z = P./v;

  tl = 20*log10(abs(1+z/(2*rho*c)));

%
% Calculate mass law transmission loss
%
function [tl_m] = MassLawTL(omega, mass, A)

  rho = 1.2;
  c = 344;
  z = j*omega*mass/A;
  tl_m = 20*log10(abs(1+z/(2*rho*c)) );

%
% Calculate mass law acceleration
%
function [accl] = MassLawAccl(mass, F)

  accl = F/mass;

