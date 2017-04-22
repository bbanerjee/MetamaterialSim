%function [w] = ResFreq( lDepth, lRatio, lNum, propRatio )


bSolve = 1;
Omega = 1;
lRatio = 0.8;
lNum = 1;
E_r = 12;
Rho_r = 3;

d = 1;
df = d*lRatio;
n = lNum;

flclear fem;


%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================

E0 = 2.0e11;
nu0 = 0.3;
rho0 = 2000;

E   = [ E0, E0 / E_r ];
nu  = [ nu0, nu0 ];
rho = [ rho0, rho0/Rho_r ];
h0   = [ d/100 ];

freq = Omega * sqrt( E(2)/rho(2) ) / d / 2 / pi;


%========================================================
%  Load Geometry
%========================================================
clear s;
[s,subs,bnds,outBnds] = Geom( d, df, n );

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
for i = 1:length(subs)
  hm(2*i-1) = i;
  hm(2*i) = h0;
end
fem.mesh=meshinit( fem, 'hauto',5, 'hmaxsub',hm );


%========================================================
%  Frequency Mode
%========================================================
clear appl
appl.mode.class = 'SmeSolid3';
appl.module = 'SME';
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_smsld';
clear prop
prop.analysis='eigen';
appl.prop = prop;


%========================================================
%  Boundary Conditions
%========================================================
clear bnd
bnd.constrcond = {'sym','free','free'};
bnd.ind = bnds;
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
equ.rho = { rho(1), rho(2) };
equ.nu = { nu(1), nu(2) };
equ.E = { E(1), E(2) };
equ.ind( SubInd ) = subs;
appl.equ = equ;
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;
fem=multiphysics(fem);


%========================================================
%  Solve
%========================================================
if( bSolve )
  fem.xmesh=meshextend(fem);
  fem.sol=femeig( fem, 'solcomp',{'w','u','v'}, 'outcomp',{'w','u','v'}, 'linsolver','spooles' );
  fem0=fem;

  freq = fem.sol.lambda(1)/(-2*j*pi);
end

