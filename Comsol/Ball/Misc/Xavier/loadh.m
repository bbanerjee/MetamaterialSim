function [h,x,f]=loadh(fnum)

x = [-256 -186 -136 136 186 256].' *1e-3;

dpath = 'Z:\xavierbremaud On My Mac\Stage NZ\mesure-tube\';

load([dpath 'trac' int2str(fnum(1)) '.mat']);
f = o2i1x;
h = o2i1;

for n=2:length(fnum)
	load([dpath 'trac' int2str(fnum(n)) '.mat']);
	h = [h,o2i1];
end