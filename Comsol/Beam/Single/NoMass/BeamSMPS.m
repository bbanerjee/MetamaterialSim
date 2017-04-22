function [u] = BeamSMPS( freq )

flclear fem

b = 5.e-4;
L = 4.e-2;
h = 1.e-3;
rho = 7850;
blk = 5.e-3;

% Geometry
g1=rect2( b,L, 'base','center', 'pos',[0,L/2], 'rot','0' );
g2=rect2( blk,blk, 'base','center','pos',[0,-blk/2], 'rot','0' );

% Analyzed geometry
clear s
s.objs={g1,g2};
s.name={'Beam','Base'};
s.tags={'g1','g2'};

fem.draw=struct('s',s);
fem.geom=geomcsg(fem);

% Create mapped quad mesh
fem.mesh=meshmap(fem, 'edgegroups',{{[2],[9],[8, 5, 3],[1]},{}}, ...
                 'edgelem',{1,[0:.0125:1],2,[0:.0125:1],4,[0:(.003125/2):1],5,[0:.125:1]}, 'hauto',5);

% (Default values are not included)

% Application mode 1
clear appl
appl.mode.class = 'SmePlaneStress';
appl.module = 'SME';
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_smps';
clear prop
prop.analysis='freq';
appl.prop = prop;
clear bnd
bnd.Fx = {0,-1000,0};
bnd.constrcond = {'free','free','displacement'};
bnd.loadtype = {'length','area','length'};
bnd.Hy = {0,0,1};
bnd.ind = [2,3,1,1,1,1,1,1,1];
appl.bnd = bnd;
clear equ
equ.dampingtype = 'nodamping';
equ.thickness = h;
equ.ind = [1,1];
appl.equ = equ;
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;

% Multiphysics
fem=multiphysics(fem);

if( 3 > 2 )

% Extend mesh
fem.xmesh=meshextend(fem);

% Solve problem
fem.sol=femstatic(fem,'solcomp',{'u','v'}, 'outcomp',{'u','v'}, ...
                  'pname','freq_smps','plist',[freq], ...
                  'oldcomp',{}, 'nonlin','off');

% Save current fem structure for restart purposes
fem0=fem;

p = [blk/2;-blk/2];
u = postinterp(fem, 'u', p);

end

