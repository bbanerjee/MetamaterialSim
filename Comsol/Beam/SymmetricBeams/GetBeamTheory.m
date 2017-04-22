function [u,ut] = GetBeamTheory( f, u );

P0 = 1000;
[ut,ml,ms,A] = BMTheory(f);

Atube = pi/4 * (8.9e-2)^2;
F = P0*A;
P = F/Atube;

omega = 2 * pi * f;
vt = i * omega .* ut;
v  = i * omega .* u;

zt   = P./vt;
z   = P./v;
zm1 = i * omega * ml / Atube;
zm2 = i * omega * ms / Atube;

rho = 1.2;
c = 344;

tl   = 20 * log10( abs( 1 + 1/2 * z   / rho / c ) );
tlt  = 20 * log10( abs( 1 + 1/2 * zt  / rho / c ) );
tlm1 = 20 * log10( abs( 1 + 1/2 * zm1 / rho / c ) );
tlm2 = 20 * log10( abs( 1 + 1/2 * zm2 / rho / c ) );


figure(1)
plot(f,tl,f,tlt,f,tlm1,f,tlm2);
legend('FEM','Beam Theory','Total Mass','Container Mass')
xlabel('Frequency (Hz)')
ylabel('Transmission Loss (dB)')
grid on;

%figure(2)
%plot(f,tl,f,tlm1,f,tlm2);
%legend('FEM','Total Mass','Container Mass')
%xlabel('Frequency (Hz)')
%ylabel('Transmission Loss (dB)')

%figure(3)
%plot(f,tlt,f,tlm1,f,tlm2);
%legend('Beam Theory','Total Mass','Container Mass')
%xlabel('Frequency (Hz)')
%ylabel('Transmission Loss (dB)')
