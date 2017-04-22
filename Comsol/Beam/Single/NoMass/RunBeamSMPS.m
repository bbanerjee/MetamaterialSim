function [freqs,u] = RunBeam3( freqs )

tic
%freqs = [100:50:450,455:5:600,600:100:3000,3000:10:3100,3100:5:3300,3350:10:3500,3550:50:4000];
freqs = [100:2:500];
n = length(freqs);
for i = 1:n
  u(i) = BeamSMPS( freqs(i) );
  if( mod(i,floor(n/10)) == 0 )
    strcat( num2str(round(100*i/n)),'% Complete')
  end
end

toc
