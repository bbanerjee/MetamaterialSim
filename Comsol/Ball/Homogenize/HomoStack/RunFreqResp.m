function [f,w] = RunFreqResp( nRes )

tic

input = load('Rho_f.mat');
f = 1:1500;
rho = input.rho;

for i = 1:length(f)
  w(i) = FreqResp( f(i), rho(i), nRes );
end

flname = strcat('Data/FR_',num2str(nRes),'.mat');
save(flname,'f','w','-mat');

toc

