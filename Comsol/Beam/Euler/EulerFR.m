function [u,v] = EulerFR( freqs )

tic

flclear fem

b = 1.e-3;
L = 4.e-2;
th = 1.e-3;
rho = 7850;
E = 2.0e11;
nu = 0.33;
blk = 1.e-2;

F = -1000 * th * blk;
M0 = blk*blk*th*rho;
I = b^3*th/12;
A = b*th;

% Geometry
gBeam=curve2([0,0],[0,L]);

% Analyzed geometry
clear c
c.objs={gBeam};
c.name={'Beam'};
c.tags={'gBeam'};

fem.draw=struct('c',c);
fem.geom=geomcsg(fem);

% Initialize mesh
fem.mesh=meshinit(fem, 'hauto',5);

% (Default values are not included)

% Application mode 1
clear appl
appl.mode.class = 'SmeInPlaneEulerBeam';
appl.module = 'SME';
appl.gporder = 6;
appl.cporder = 1;
appl.assignsuffix = '_smeulip';
clear prop
prop.analysis='freq';
appl.prop = prop;

clear pnt
pnt.Fx = {0,F};
pnt.Fy = {0,F};
pnt.constrcond = {'free','norot'};
pnt.m = {0,M0};
pnt.ind = [2,1];
appl.pnt = pnt;

clear bnd
bnd.heightz = th;
bnd.Iyy = I;
bnd.A = A;
bnd.dampingtype = 'nodamping';
bnd.ind = [1];
appl.bnd = bnd;

fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;
fem=multiphysics(fem);
fem.xmesh=meshextend(fem);

% Solve problem
fem.sol=femstatic(fem, 'solcomp',{'u','th','v'}, 'outcomp',{'u','th','v'}, ...
                  'pname','freq_smeulip', 'plist',freqs, ...
                  'oldcomp',{}, 'nonlin','off');

% Save current fem structure for restart purposes
fem0=fem;

solnums = 1:length(freqs);
u = postint(fem,'u', 'unit','m', 'dl',[1], 'edim',0, 'solnum',solnums);
v = postint(fem,'v', 'unit','m', 'dl',[1], 'edim',0, 'solnum',solnums);
toc
