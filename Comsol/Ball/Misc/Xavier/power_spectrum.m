clc, clear all, close all
load trac627
AA=20*log10(c2);
load trac628
BB=20*log10(c2);
load trac637
CC=20*log10(c2);
load trac638
DD=20*log10(c2);
plot(c2x,AA,'b'),hold on,plot(c2x,BB,'r'),hold on,plot(c2x,CC,'g'),hold on,plot(c2x,DD,'c'),grid on