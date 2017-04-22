function [f,w,v] = DampTest

beta = [0:30];
n = length(beta);

for k = 1:n
  [f0,w0,v0] = RunFreqsUP( beta(k) ); 
  f(k,:) = f0;
  w(k,:) = w0;
  v(k,:) = v0;
end

