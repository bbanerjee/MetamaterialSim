function [f,w,rho] = RunFreqResp

tic

f = 1:1500;

for i = 1:length(f)
  [ w1(i),  rho1(i)  ] = FreqResp( f(i), 1, 1.e-5 );
  [ w10(i), rho10(i) ] = FreqResp( f(i), 1, 1.e-4 );
end

w = [w1;w10];
rho = [rho1;rho10];

flname = 'Data/Damped.mat';
save(flname,'f','w1','rho1','w10','rho10','-mat');

toc

