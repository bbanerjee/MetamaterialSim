function [freqs,u] = RunBeam4( freqs )

tic

for i = 1:length(freqs)
  u(i,:) = BeamTest4(freqs(i) );
end

toc
