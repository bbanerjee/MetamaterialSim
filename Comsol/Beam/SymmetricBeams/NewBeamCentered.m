function [u] = NewBeamCentered( freq )
%  freq:  Input Frequency,  hAcross:  Number of Elements Across Beam
%  sType = 1:  Plane Stress
%          2:  Plane Strain  

flclear fem;
bSolve = 1;
hAcross = 12;
%freq = 460;
sType = 2;

bx = 1.6e-3;
by = 14.0e-3;
cx = 5.0e-3;
cy = 16.0e-3;
mx = 15.e-3;
my = 15.e-3;
z = 19.0e-3;

omega = 2*pi*freq;
F = -1000 * z;

rho1 = 7700;
rho2 = ( cx*cy*z*rho1+260.e-3 ) / (cx*cy*z);
E = 2.0e11;
nu = 0.33;

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
gBase = rect2( cx,cy, 'base','center', 'pos',[0,0],             'rot','0' );
gbTop = rect2( bx,by, 'base','center', 'pos',[0, (by+cy)/2],    'rot','0' );
gbBot = rect2( bx,by, 'base','center', 'pos',[0,-(by+cy)/2],    'rot','0' );
gmTop = rect2( mx,my, 'base','center', 'pos',[0, by+(my+cy)/2], 'rot','0' );
gmBot = rect2( mx,my, 'base','center', 'pos',[0,-by-(my+cy)/2], 'rot','0' );

SubBeam = [2,1,1,1,1];

clear s
s.objs={gBase,gbTop,gbBot,gmTop,gmBot};
s.name={'Base','bTop','bBot','mTop','mBot'};
s.tags={'gBase','gbTop','gbBot','gmTop','gmBot'};
fem.draw=struct('s',s);
fem.geom=geomcsg(fem);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
SubAll = ones( 1, size(st,1) );            


%  Create Mapped Mesh
hscl = 1/hAcross;
hcx = 0:(bx/((cx-bx)/2)*hscl):1;
hcy = 0:(bx/cy*hscl):1;
hmx = 0:(bx/mx*hscl):1;
hmy = 0:(bx/my*hscl):1;
hbx = 0:hscl:1;
hby = 0:(bx/by*hscl):1;
fem.mesh=meshmap(fem, 'edgelem',{1,hmy,2,hmx,4,hmy,6,hmx,7,hcy,8,hcx,10,hby,11,hbx,13,hby,14,hbx,18,hcx}, 'hauto',5 );


%  Weak PDE Application Mode 
clear appl
appl.mode.class = 'FlPDEW';
appl.dim = {'u','v','u_t','v_t'};
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_w';


%  Boundary Settings
clear bnd
bnd.weak = {0,'F*u_test'};
bnd.constr = {0,0};
bnd.ind = [1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
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
equ.expr = { 'rho',{rho1,rho2}, 'K1',K1, 'K2',K2, 'K3',K3 };
fem.const = { 'th',z, 'omega',omega, 'F', F };
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

  p = [0;0];
  u = postinterp(fem, 'u', p);
end


