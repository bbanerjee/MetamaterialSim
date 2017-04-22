function [f,u2,u1,u0] = RunAll( hAcross )

f = [1:700];
d = load('Data/BeamSMPS.dat');
u2 = d(:,3);
%u2 = RunBeamSMPS( f, hAcross );
u1 = RunBeam1SMPS( f, hAcross );
u0 = RunBlockSMPS( f, hAcross );
