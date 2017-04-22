function [w] = SymFreqs( freq )

bSolve = 1;
%freq = 2000;

flclear fem;

wv = sqrt(1.175e5/1300) / freq / 4;

hs = min( 0.0015, wv );

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r = [ 0.005, 0.007, 0.015, .015, .019 ];
E = [ 2.0696e11, 1.175e5, 4.35e9 ];
nu = [ 0.3, 0.469, 0.368 ];
rho = [ 7780, 1300, 1180 ];
h = [ .004, hs, .004 ];


%========================================================
%  Load Geometry
%========================================================
clear s;
[s] = SymGeom( r(1), r(2), r(3), r(4), r(5) );

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
fem.mesh=meshinit(fem, 'hauto',5, ...
                  'hmaxsub',[1,h(3),2,h(2),3,h(1)]);


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
prop.analysis='freq';
appl.prop = prop;


%========================================================
%  Boundary Conditions
%========================================================
clear bnd
bnd.constrcond = {'free','sym','free'};
bnd.Fz = {0,0,1000};
bnd.ind = [2,2,1,2,2,1,2,2,1,1,1,3,1,1];
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
equ.rho = { rho(1), rho(2), rho(3) };
equ.nu = { nu(1), nu(2), nu(3) };
equ.E = { E(1), E(2), E(3) };
equ.ind( SubInd ) = [1,2,3];
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

  fem.sol=femstatic(fem, 'solcomp',{'w','u','v'}, 'outcomp',{'w','u','v'}, ...
                  'pname','freq_smsld', 'plist',[freq], 'oldcomp',{}, ...
                  'linsolver','spooles');
  fem0=fem;
  p = [0;0;-r(3)/2];
  w = postinterp(fem, 'w', p);
end

