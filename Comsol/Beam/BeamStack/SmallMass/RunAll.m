function [f,u2,u1,u0] = RunAll( hAcross )

[f,u2] = RunBeamSMPS( hAcross );
[f,u1] = RunBeam1SMPS( hAcross );
[f,u0] = RunBlockSMPS( hAcross );
