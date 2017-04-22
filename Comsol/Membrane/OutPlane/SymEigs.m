%function [freq] = SymEigs( ESil, ERes )

bSolve = 0;
ESil = 1.175e5;
ERes = 4.35e9;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r = [ 0.005, 0.00775, 0.023, 0.001 ];
E = [ 2.0696e11, ESil, ERes ];
nu = [ 0.3, 0.469, 0.368 ];
rho = [ 7780, 1300, 1180 ];
h = [ .0025, .0015, .0008 ];


%========================================================
%  Load Geometry
%========================================================
clear s;
[s] = SymGeom( r(1), r(2), r(3), r(4) );
fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
fem.mesh=meshinit(fem, 'hauto',5, ...
                  'hmaxsub',[1,h(2),2,h(1),3,h(3)]);


%========================================================
%  Eigenvalue Mode
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
bnd.constrcond = {'free','sym'};
bnd.ind = [2,2,1,2,2,1,1,1,2,1,1,1,1,1,2,1];
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
  fem.xmesh = meshextend(fem);
  fem.sol = femeig( fem, 'solcomp',{'w','u','v'}, 'outcomp',{'w','u','v'}, ...
	   'rowscale','off', 'linsolver','spooles', 'neigs',2 );
  fem0=fem;
  freq = fem.sol.lambda(2)/(-2*j*pi);
end

