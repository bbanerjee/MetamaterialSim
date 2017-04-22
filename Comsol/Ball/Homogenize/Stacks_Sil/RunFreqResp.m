function [f,w_bnds,w_ctrs] = RunFreqResp( nRes )

tic

f = [100,200:10:240,350:2:404,405:415,416:2:464,465:475,476:2:500,510:10:700,750:50:900];
f = 100:1000;
for i = 1:length(f)
  [ w_bnds(i,:), w_ctrs(i,:)] = FreqResp( f(i), nRes );
end

flname = strcat('Data/FR_',num2str(nRes),'.mat');
save(flname,'f','w_bnds','w_ctrs','-mat');

toc

