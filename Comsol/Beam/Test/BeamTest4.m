function [u] = BeamTest4( freq )

flclear fem

% Geometry
g1=rect2('1.e-3','2.e-2','base','center','pos',{'0','1.e-2'},'rot','0');
g2=rect2('1.e-2','1.e-2','base','center','pos',{'0','-5.e-3'},'rot','0');
g3=rect2('0.01','5.e-3','base','center','pos',{'0','-0.0025'},'rot','0');
g4=rect2('0.01','0.010','base','center','pos',{'0','-0.005'},'rot','0');

% Analyzed geometry
clear s
s.objs={g1,g4};
s.name={'R1','R2'};
s.tags={'g1','g4'};

fem.draw=struct('s',s);
fem.geom=geomcsg(fem);


% Create mapped quad mesh
fem.mesh=meshmap(fem, 'edgegroups',{{[2],[9],[8, 5, 3],[1]},{}}, ...
                 'edgelem',{1,[0:.0125:1],2,[0:.0125:1],4,[0:.00625:1],5,[0:.125:1]}, 'hauto',5);

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
bnd.constrcond = {'free','displacement','displacement'};
bnd.Rx = {0,0,0.01};
bnd.Hy = {0,1,0};
bnd.Hx = {0,0,1};
bnd.ind = [3,2,1,1,1,1,1,1,1];
appl.bnd = bnd;
clear equ
equ.dampingtype = 'nodamping';
equ.thickness = 1.e-3;
equ.E = {2.0e15,2.0e11};
equ.ind = [1,2];
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
fem.sol=femstatic(fem, ...
                  'solcomp',{'u','v'}, ...
                  'outcomp',{'u','v'}, ...
                  'pname','freq_smps', ...
                  'plist',[freq], ...
                  'oldcomp',{}, ...
                  'nonlin','off');

% Save current fem structure for restart purposes
fem0=fem;

p1 = [0;0];
p2 = [0;2.e-2];
u(1) = postinterp(fem, 'u', p1);
u(2) = postinterp(fem, 'u', p2);

end
