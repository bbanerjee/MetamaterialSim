function [f,wSt1,wSt2,wAl] = RunFreqResp

tic

f = 10:10:1500;
flname = 'Data/FR_.mat';

beta = [1.e-3; 1.e-2];
eAl = 70.e9;
eSt = 200.e9;
rAl = 2700;
rSt = 7850;

for i = 1:length(f)
  k = 2*i-1;
  wAl(k,:)  = FreqResp( f(i), 3, 0.01,   0.005, eAl, rAl, beta(1) );
  wSt1(k,:) = FreqResp( f(i), 3, 0.01,   0.005, eSt, rSt, beta(1) );
  wSt2(k,:) = FreqResp( f(i), 3, 0.0035, 0.005, eSt, rSt, beta(1) );

  k = 2*i;
  wAl(k,:)  = FreqResp( f(i), 3, 0.01,   0.005, eAl, rAl, beta(2) );
  wSt1(k,:) = FreqResp( f(i), 3, 0.01,   0.005, eSt, rSt, beta(2) );
  wSt2(k,:) = FreqResp( f(i), 3, 0.0035, 0.005, eSt, rSt, beta(2) );
  save(flname,'f','wAl','wSt1','wSt2','-mat');
end

toc

