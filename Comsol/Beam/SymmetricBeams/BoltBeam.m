function [w] = BoltBeam( freq )

tic
flclear fem

%freq = 500;

xStrip = 0.0292;
xStrip = 0.037;
yStrip = 0.019;
zStrip = 0.00155;
dsx = xStrip/2;
pF = 1/yStrip/zStrip;

xHex = 0.0159;
zHex = 0.00695;
dhx = 0.02125;
dhz = xStrip - zHex/2;
sc = sqrt(3)/3;

rho = 7700;
E = 2.1e11;
nu = 0.33;

gHex11=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,dhz],'axis',{'0','0','1'},'rot','0' );
gHex21=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,dhz],'axis',{'0','0','1'},'rot','60' );
gHex31=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,dhz],'axis',{'0','0','1'},'rot','120' );
gHex1=geomcomp( {gHex11,gHex21,gHex31},'ns',{'g1','g2','g3'},'sf','g1+g2+g3','face','none','edge','all' );
gHex12=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,-dhz],'axis',{'0','0','1'},'rot','0' );
gHex22=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,-dhz],'axis',{'0','0','1'},'rot','60' );
gHex32=block3( xHex,sc*xHex,zHex,'base','center','pos',[dhx,0,-dhz],'axis',{'0','0','1'},'rot','120' );
gHex2=geomcomp( {gHex12,gHex22,gHex32},'ns',{'g1','g2','g3'},'sf','g1+g2+g3','face','none','edge','all' );
gStrip=block3( xStrip,yStrip,zStrip,'base','center','pos',[dsx,0,0],'axis',{'0','0','1'},'rot','0' );

% Geometry objects
clear s
s.objs={gStrip,gHex1,gHex2};
s.name={'Strip','Hex1','Hex2'};
s.tags={'gStrip','gHex1','gHex2'};

fem.draw=struct('s',s);
fem.geom=geomcsg(fem);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
SubAll = ones( 1, size(st,1) );
BndAll = ones( 1, size(ft,1) );            

hh = zeros(1,54);
hh(1:2:53) = 1:27;
hh(2) = zStrip;
hh(4:2:54) = 0.02;

% Initialize mesh
fem.mesh=meshinit(fem, 'hauto',6, 'hmaxsub',hh, 'point',[], 'edge',[], 'face',[], 'subdomain',[1:27]) ;
fem.border = 1;

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

clear equ
equ.dampingtype = 'nodamping';
equ.rho = rho;
equ.nu = nu;
equ.E = E;
appl.equ = equ;

clear bnd
bnd.constrcond = {'free','sym'};
bnd.Fz = {0,pF};
bnd.ind = [BndAll];
bnd.ind(1) = 2;
appl.bnd = bnd;

fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;
fem=multiphysics(fem);

% Solve problem
fem.xmesh=meshextend(fem);
fem.sol = femstatic( fem, 'solcomp',{'w','u','v'}, 'outcomp',{'w','u','v'}, 'pname','freq_smsld', ...
		     'plist',[freq], 'oldcomp',{}, 'linsolver','spooles' );
fem0=fem;

p = [0;0;0];
w = postinterp(fem, 'w', p);

toc
