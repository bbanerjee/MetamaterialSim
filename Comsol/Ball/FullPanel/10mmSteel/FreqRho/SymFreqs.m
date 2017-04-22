function [w,wi] = SymFreqs( freq, rho0 )
bSolve = 1;
%rho0 = 1068;

flclear fem;

Vtot = 0.13^2 * 0.019;
Vres = 68 * ( 4/3 * pi * .007^3 );
Vbal = 68 * ( 4/3 * pi * .005^3 );
Vsil = Vres - Vbal;
Vepx = Vtot - Vres;

eEpx = ( 4.35e9 * Vepx + 2.0696e11 * Vbal + 1.175e5 * Vsil ) / Vtot;
nuEpx = ( 0.368 * Vepx + 0.3 * Vbal + 0.469 * Vsil ) / Vtot;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
E = [5.e5,eEpx];
nu = [0.4, nuEpx];
rho = [1200,rho0];
h = [0.003,0.015];
r = 0.1085/2;
ri = 0.1015/2;
rt = 0.0035;
l = 0.130;
th = 0.019;

tmpl = .130/2;
tmpth = th+2*rt;

%========================================================
%  Load Geometry
%========================================================
clear s;
gPlate = block3( l,l,th, 'base','center','pos',[0,0,th/2], 'axis',{'0','0','1'}, 'rot','0' );

gRing1 = cylinder3( r,rt, 'pos',[0,0,th],   'axis',{'0','0','1'}, 'rot','0' );
gRing2 = cylinder3( r,rt, 'pos',[0,0,-rt],  'axis',{'0','0','1'}, 'rot','0' );
gTemp1 = cylinder3( ri,rt, 'pos',[0,0,th],  'axis',{'0','0','1'}, 'rot','0' );
gTemp2 = cylinder3( ri,rt, 'pos',[0,0,-rt], 'axis',{'0','0','1'}, 'rot','0' );
gRing1 = geomcomp( {gRing1,gTemp1}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRing2 = geomcomp( {gRing2,gTemp2}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = block3( tmpl,tmpl,tmpth, 'base','center','pos',[tmpl/2,tmpl/2,th/2], 'axis',{'0','0','1'}, 'rot','0' );
gPlate = geomcomp( {gPlate,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gRing1 = geomcomp( {gRing1,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gRing2 = geomcomp( {gRing2,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );

% Analyzed geometry
clear s
s.objs={gPlate,gRing1,gRing2};
s.name={'Plate','Ring1','Ring2'};
s.tags={'gPlate','gRing1','gRing2'};

fem.draw=struct('s',s);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
fem.mesh=meshinit(fem, 'hauto',5, ...
                  'hmaxsub',[1,h(2),2,h(1),2,h(1)]);
%fem.mesh=meshinit(fem, 'hauto',5);

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
bnd.constrcond = {'free','free','sym','fixed'};
bnd.Fz = {0,1000,0,0};
bnd.ind = [3,3,1,2,3,1,4,1,3,1,1,4,1,1,1,1,1,3,3,1];
appl.bnd = bnd;

%========================================================
%  Set Up Solver
%========================================================
clear equ
%equ.dampingtype = {'Rayleigh','nodamping'};
%equ.betadK = {1.e-5,0};
%equ.alphadM = {0,0};
equ.dampingtype = {'nodamping'};
equ.rho = { rho(1), rho(2) };
equ.nu = { nu(1), nu(2) };
equ.E = { E(1), E(2) };
equ.ind = [2,1,1];
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
  p = [0;0;0;];
  w = postinterp(fem, 'w', p);
  wi = postint(fem,'w', 'unit','m^3', 'dl',[3], 'edim',2);
  p2 = [.04/sqrt(2);.04/sqrt(2);0];
  w2 = postinterp(fem, 'w', p2);
  c = (l-.001)/2;
  p3 = [c;c;0];
  w3 = abs( postinterp(fem, 'w', p3) ) + abs( postinterp(fem,'u', p3) ) + abs( postinterp(fem,'v',p3) );
end
