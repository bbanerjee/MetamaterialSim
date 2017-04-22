function [f,w] = RunFreqResp

tic

f = 100:2:1500;

for i = 1:length(f)
  w = FreqResp( f(i) );
  flname = strcat('Data/FR_',num2str(i),'.mat');
  save(flname,'f','w','-mat');
end

toc

