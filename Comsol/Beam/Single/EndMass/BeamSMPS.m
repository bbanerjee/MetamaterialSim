%function [u] = BeamSMPS( freq, hAcross, sType )

flclear fem;

bSolve = 0;
hAcross = 8;
freq = 1900;
sType = 2;

b = 5.e-4;
L = 4.e-2;
th = 1.e-3;
l = 5.e-3;
d = 1.e-3;
rho = 7850;
E = 2.0e11;
nu = 0.33;
blk = 6.e-3;
omega = 2*pi*freq;
F = -1000;

gBase = rect2( blk,blk, 'base','center','pos',[0,-blk/2], 'rot','0' );
gBeam = rect2( b,L, 'base','center', 'pos',[0,L/2], 'rot','0' );
gMass = rect2( l,d, 'base', 'center', 'pos',[0,L+d/2], 'rot','0');
SubBeam = [1,1,2];

clear s
s.objs={gBase,gBeam,gMass};
s.name={'Base','Beam','Mass'};
s.tags={'gBase','gBeam','gMass'};
fem.draw=struct('s',s);
fem.geom=geomcsg(fem);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
SubAll = ones( 1, size(st,1) );            

hscl = 1/hAcross;
hblk = 0:(b/blk*hscl):1;
hmx = 0:(b/l*hscl):1;
hmy = 0:(b/d*hscl):1;
hbx = 0:hscl:1;
hby = 0:(b/L*hscl):1;
fem.mesh=meshmap(fem, 'edgegroups',{{[2],[14],[11, 8, 3],[1]},{[5, 9, 12],[13],[6],[4]},{[8],[10],[9],[7]}}, ...
                 'edgelem',{ 1,hblk, 2,hblk, 4,hmy, 6,hmx, 7,hby, 8,hbx}, 'hauto',5);

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
bnd.loadtype = {'length','area','length'};
bnd.Hy = {0,0,1};
bnd.ind = [2,3,1,1,1,1,1,1,1,1,1,1,1,1];
appl.bnd = bnd;

clear equ
equ.dampingtype = 'nodamping';
equ.thickness = th;
equ.ind = [1,1,1];
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
  p = [blk/2;-blk/2];
  u = postinterp(fem, 'u', p);
end

