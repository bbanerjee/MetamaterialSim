function [t12]=transcoeff10(fnum,d)

[h1,x,f]=loadh(fnum)
% NB x are the microphone locations with no sample

% [A1,B1,C1,D1,A2,B2,C2,D2]=transcoeff5(h1,h2,x,d,f)

% [t12,t21,r11,r22]=transcoeff5(h1,h2,x,d,f)

% h1,h2 are the same size and each contain 5 column vectors of transfer
% functions measured at 5 microphone locations for each of two different tube
% terminations. Vector x contains the 6 microphone locations and the sample
% is assumed to lie between x=0 and x=d;




tc = 18;									% ambient temperature (degrees Celsius)
pa = 101.4;								% barometric pressure (kPa)
[c0,rho]=rhoc(tc,pa);

idx = find(f==0.);
f(idx) = ones(size(idx))*NaN;

x([4 5 6]) = x([4 5 6])+d;			% adjust mic locations for thickness of sample

% Acoustic wavenumber with estimated attenuation in air
diam = 0.083;
k = 2*pi*f/c0 - i*1.94e-2*sqrt(f)/(c0*diam);


% -------------------------------------------------------------------------
% Wave amplitudes at x=0, 'anechoic' termination

h1 = [ones(size(h1,1),1) h1];
%h2 = [ones(size(h2,1),1) h2];

[A1,B1] = waveamp3(h1(:,[1 2 3]),x([1 2 3].'),k);		% source side of sample
[C1,D1] = waveamp3(h1(:,[4 5 6]),x([4 5 6].'),k);		% receiver side of sample

% Wave amplitudes at x=0, 'rigid' termination
%[A2,B2] = waveamp3(h2(:,[1 2 3]),x([1 2 3].'),k);		% source side of sample
%[C2,D2] = waveamp3(h2(:,[4 5 6]),x([4 5 6].'),k);		% receiver side of sample

% C1=A1;D1=B1;
% C2=A2;D2=B2;
% eps = .1;
% C1 = A1.*(1+randc(size(A1))*eps);  D1 = B1.*(1+randc(size(B1))*eps); 
% C2 = A2.*(1+randc(size(A2))*eps);  D2 = B2.*(1+randc(size(B2))*eps); 



% -------------------------------------------------------------------------
% Transmission coefficients

% Cd,Dd amplitudes on receiver side of sample at x=d
Cd1 = C1.*exp(-i*k*d);
Dd1 = D1.*exp(i*k*d);

%Cd2 = C2.*exp(-i*k*d);
%Dd2 = D2.*exp(i*k*d);

% t = zeros(length(f),1);
t12 = zeros(length(f),1);
% t21 = zeros(length(f),1);
% r11 = zeros(length(f),1);
% r22 = zeros(length(f),1);

z=zeros(size(f));
for nf=1:length(f)
%	BB = [B1(nf) B2(nf); Cd1(nf) Cd2(nf)];
%	AA = [A1(nf) A2(nf); Dd1(nf) Dd2(nf)];
% 	T = lsq_symmetric(AA,BB);
%	T = BB / AA;
T = B1(nf) / A1(nf);

% 	r11(nf) = T(1,1);
	t12(nf) = T(1,1);
% 	t21(nf) = T(2,1);
% 	r22(nf) = T(2,2);
end













% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [A,B]=waveamp3(p,x,k)
% Estimate 2 least squares best fit wave amplitudes from pressure
% measurements taken at 3 locations

% p is a n X 3 matrix of pressure spectra at 3 locations, x is a 3 X 1
% vector of locations and k is the wavenumber

amp = zeros(2,size(p,1));
for n=1:size(p,1)
	amp(:,n) = [exp(-i*k(n)*x), exp(i*k(n)*x)] \ p(n,:).';
end
A = amp(1,:).';
B = amp(2,:).';



% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [c,rho]=rhoc(tc,pa)
% Estimate speed of sound and air density at given temperature tc in degC
% and atmospheric pressure pa (kPa)

t0 = 293;								% standard temperature ( ~ 20 degC)
tk = 273.15 + tc;						% temperature in degrees Kelvin

c = 343.2  * sqrt(tk/t0);

rho0 = 1.186;							% kg/m^3
p0 = 101.325;							% kPa
rho = rho0 * pa*t0/(p0*tk);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% function X=lsq_symmetric(A,B)
% % Least squares best fit symmetric X that satisfies B = XA
% 
% % Initial estimate of X
% X = B/A;
% X = (X+X.')/2;
% 
% S = B - X*A;
% R = S*A.' + A*S.';
% P = R;
% 
% n = 0;
% 
% while ((norm(B-X*A,'fro') > eps) & (n < 1000))
% 	n = n+1;
% 	alfa = trace(R*P) / trace(A.'*P*P*A)/2;
% 	X = X + alfa*P;
% 
% 	R = R - alfa*(P*A*A.' + A*A.'*P);
% 	beta = trace(A.'*P*R*A) / trace(A.'*P*P*A)/2;
% 	P = R - beta*P;
% end

