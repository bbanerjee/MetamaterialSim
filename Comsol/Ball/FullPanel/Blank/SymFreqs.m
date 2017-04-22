%function [w,wi] = SymFreqs( freq, rho0 )
bSolve = 0;
%freq = 1000;
%bSolve = 0;
rho0 = 1068;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
E = [1.e6,4.35e9];
nu = [0.45, 0.368];
rho = [1200,rho0];
h = [0.003,0.015];
r = 0.1085/2;
ri = 0.1015/2;
rt = 0.0035;
l = 0.127;
th = 0.019;

tmpl = .127;
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

gTmp = block3( tmpl,tmpl,tmpth, 'base','center','pos',[0,-tmpl/2,th/2], 'axis',{'0','0','1'}, 'rot','0' );
gPlate = geomcomp( {gPlate,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRing1 = geomcomp( {gRing1,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRing2 = geomcomp( {gRing2,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = block3( tmpl,tmpl,tmpth, 'base','center','pos',[-tmpl/2,0,th/2], 'axis',{'0','0','1'}, 'rot','0' );
gPlate = geomcomp( {gPlate,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRing1 = geomcomp( {gRing1,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRing2 = geomcomp( {gRing2,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

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
                  'hmaxsub',[1,h(2),2,h(1),3,h(1)]);

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
bnd.constrcond = {'free','fixed','free','sym'};
bnd.Fz = {0,0,1000,0};
bnd.ind = [4,4,1,3,4,1,2,1,4,1,1,2,1,1,1,1,1,4,4,1];
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
end
