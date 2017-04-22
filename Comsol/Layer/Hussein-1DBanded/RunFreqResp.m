function [f,w] = RunFreqResp( n )

tic

f = 0:0.1:50;
flname = strcat('Data/FR_',num2str(n),'.mat');

for i = 1:length(f)
  w(i,:) = FreqResp( f(i), 0.8, n, 12, 3 );
  save(flname,'f','w','-mat');
end

toc

