function [f,w] = RunFreqResp( nRes )

tic

input = load('Rho_f.mat');
f = 1:1500;
rho = input.rho10;
flname = strcat('Data/FR_',num2str(nRes),'.mat');

for i = 1:length(f)
  w(i) = FreqResp( f(i), rho(i), nRes, 1.e-4 );
  if( mod(i,10) == 0 )
    save(flname,'f','w','-mat');
  end
end

save(flname,'f','w','-mat');

toc

