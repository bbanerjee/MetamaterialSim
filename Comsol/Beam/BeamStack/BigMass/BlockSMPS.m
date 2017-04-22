function [u] = BlockSMPS( freq, hAcross )

flclear fem;
bSolve = 1;
%hAcross = 8;
%freq = 1900;


th = 1.e-3;
rho = 7850;
E = 2.0e11;
nu = 0.33;
blk = 2.1e-2;
omega = 2*pi*freq;
F = -1000;

gMass = rect2( blk,blk, 'base','center', 'pos',[0,0], 'rot','0');

clear s
s.objs={gMass};
s.name={'Mass'};
s.tags={'gMass'};
fem.draw=struct('s',s);
fem.geom=geomcsg(fem);
[g,st,ft,pt] = geomcsg(fem);

hs1 = 2*blk/hAcross;
fem.mesh=meshinit( fem, 'hauto',5, 'hmax',hs1 );

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
bnd.Fx = {0,F,0};
bnd.constrcond = {'free','free','displacement'};
bnd.Hy = {0,0,1};
bnd.loadtype = {'length','area','length'};
bnd.ind = [2,3,1,1];
appl.bnd = bnd;

clear equ
equ.dampingtype = 'nodamping';
equ.thickness = th;
equ.ind = [1];
appl.equ = equ;
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;

clear units;
units.basesystem = 'SI';
fem.units = units;
fem=multiphysics(fem);

if( bSolve )
  fem.xmesh=meshextend(fem);
  fem.sol=femstatic(fem,'solcomp',{'u','v'}, 'outcomp',{'u','v'}, ...
                  'pname','freq_smps','plist',[freq], ...
                  'oldcomp',{}, 'nonlin','off', 'linsolver','spooles');
  fem0 = fem;
  p = [blk/2;0];
  u = postinterp(fem, 'u', p);
end
