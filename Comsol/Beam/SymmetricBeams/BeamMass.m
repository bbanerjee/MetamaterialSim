%function [u,v] = BeamMass( freq )
%  freq:  Input Frequency,  hAcross:  Number of Elements Across Beam
%  sType = 1:  Plane Stress
%          2:  Plane Strain  

flclear fem;
bSolve = 0;
hAcross = 8;
freq = 1900;
sType = 1;

b = 1.55e-3;
L = 13.3e-3;
th = 19.0e-3;
l = 11.6e-3;
d = 15.9e-3;
rho = 7700;
E = 2.0e11;
nu = 0.33;
blk = 12.e-3;
omega = 2*pi*freq;
F = -1000 * th;

m = l*d*th*rho;

if( sType == 1 )
  D = E/(1-nu^2);
  K1 = D;
  K2 = D*nu;
  K3 = D*(1-nu)/2;
else
  D = E/(1+nu)/(1-2*nu);
  K1 = D*(1-nu);
  K2 = D*nu;
  K3 = D*(1-2*nu)/2;
end

% Geometry
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


%  Create Mapped Mesh
hscl = 1/hAcross;
hblk = 0:(b/blk*hscl):1;
hmx = 0:(b/l*hscl):1;
hmy = 0:(b/d*hscl):1;
hbx = 0:hscl:1;
hby = 0:(b/L*hscl):1;
fem.mesh=meshmap(fem, 'edgegroups',{{[2],[14],[11, 8, 3],[1]},{[5, 9, 12],[13],[6],[4]},{[8],[10],[9],[7]}}, ...
                 'edgelem',{ 1,hblk, 2,hblk, 4,hmy, 6,hmx, 7,hby, 8,hbx}, 'hauto',5);

%  Weak PDE Application Mode 
clear appl
appl.mode.class = 'FlPDEW';
appl.dim = {'u','v','u_t','v_t'};
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_w';


%  Boundary Settings
clear bnd
bnd.weak = {0,'F*u_test',0};
bnd.constr = {0,0,{0;'v'}};
bnd.ind = [2,3,1,1,1,1,1,1,1,1,1,1,1,1];
appl.bnd = bnd;

% Subdomain settings
pdeStart = 'th*(';
pde1 = '-ux_test*(K1*ux+K2*vy)';
pde2 = '-vy_test*(K2*ux+K1*vy)';
pde3 = '-(uy_test+vx_test)*K3*(uy+vx)';
pde4 = '+rho*omega^2*(u_test*u+v_test*v)';
pdeEnd = ')';
pde = strcat(pdeStart,pde1,pde2,pde3,pde4,pdeEnd);

clear equ
equ.weak = pde;
equ.dweak = 0;
equ.ind = SubAll;
equ.dim = {'u','v'};
appl.equ = equ;

clear equ
equ.ind( SubInd ) = SubBeam;
equ.expr = { 'rho',{rho,rho}, 'K1',{K1,K1}, 'K2',{K2,K2}, 'K3',{K3,K3} };
fem.const = { 'th',th, 'omega',omega, 'F', F };
fem.equ = equ;


clear units;
units.basesystem = 'SI';
fem.units = units;
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
fem=multiphysics(fem);

if( bSolve )
  fem.xmesh=meshextend(fem);
  fem.sol=femstatic(fem, 'solcomp',{'u','v'},'outcomp',{'u','v'},'linsolver','spooles');
  fem0=fem;

  p = [blk/2;-blk/2];
  y = 0:(L/100):L;
  x = zeros(size(y));
  pv = [x;y];
  u = postinterp(fem, 'u', p);
  v = postinterp(fem, 'u', pv);
end


