%function [freq] = ResFreq( bScale, sScale )

bSolve = 0;
bScale = 1;
sScale = 1;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r =   [ bScale * 0.005, sScale * 0.008, sScale * 0.023 ];
E =   [ 2.0696e11, 1.175e5, 4.35e9 ];
nu =  [ 0.3, 0.469, 0.368 ];
rho = [ 7780, 1300, 1180 ];
h =   [ sScale * .0018, sScale * .0018, sScale * .004 ];
P =   1000;

%========================================================
%  Load Geometry
%========================================================
clear s;
[s,subs,bnds,outBnds] = Geom1( r(1), r(2), r(3) );

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
for i = 1:length(subs)
  hm(2*i-1) = i;
  hm(2*i) = h(subs(i));
end
clear i;
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
bnd.constrcond = {'free','sym','fixed'};
bnd.ind = bnds;
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
equ.rho = { rho(1), rho(2), rho(3) };
equ.nu = { nu(1), nu(2), nu(3) };
equ.E = { E(1), E(2), E(3) };
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

