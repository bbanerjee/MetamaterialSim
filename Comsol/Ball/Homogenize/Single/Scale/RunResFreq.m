function [fl,fc] = RunResFreq

tic

bScale = 0.1:0.1:1;
sScale = bScale.^(1/3);
flname = 'Data/Scale.mat';

for i = 1:length(bScale)
  fl(i) = ResFreq( bScale(i), bScale(i) );
  fc(i)  = ResFreq( bScale(i), sScale(i) );
  save( flname, 'fl','fc','bScale','sScale','-mat' );
end

toc

