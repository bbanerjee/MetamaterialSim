function [u,v] = BeamAngleFR( freq, hAcross, sType )
%  freq:  Input Frequency,  hAcross:  Number of Elements Across Beam
%  sType = 1:  Plane Stress
%          2:  Plane Strain  

flclear fem;
bSolve = 1;

%hAcross = 8;
%freq = 1000;
%sType = 2;

b = 1.e-3;
L = 4.e-2;
th = 1.e-3;
rho = 7850;
E = 2.0e11;
nu = 0.33;
blk = 1.e-2;
omega = 2*pi*freq;
F = -1000 * th;

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
gBeam=rect2( b,L, 'base','center', 'pos',[0,L/2], 'rot','0' );
gMass=rect2( blk,blk, 'base','center','pos',[0,-blk/2], 'rot','0' );

% Analyzed geometry
clear s
s.objs={gBeam,gMass};
s.name={'Beam','Mass'};
s.tags={'gBeam','gMass'};

fem.draw=struct('s',s);
fem.geom=geomcsg(fem);

%  Create Mapped Mesh
hscl = 1/hAcross;
h1 = 0:(hscl/10):1;
h4 = 0:(hscl/40):1;
h5 = 0:hscl:1;
% Create mapped quad mesh
fem.mesh=meshmap(fem, 'edgegroups',{{[2],[9],[8, 5, 3],[1]},{}}, ...
                 'edgelem',{1,h1,2,h1,4,h4,5,h5}, 'hauto',5);

%  Weak PDE Application Mode 
clear appl
appl.mode.class = 'FlPDEW';
appl.dim = {'u','v','u_t','v_t'};
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_w';

%  Boundary Settings
clear bnd
bnd.weak = {0,0,{'F*u_test';'F*v_test'}};
bnd.constr = {0,{0;'v'},0};
bnd.ind = [3,2,1,1,1,1,1,1,1];
appl.bnd = bnd;

pdeStart = 'th*(';
pde1 = '-ux_test*(K1*ux+K2*vy)';
pde2 = '-vy_test*(K2*ux+K1*vy)';
pde3 = '-(uy_test+vx_test)/2*K3*(uy+vx)/2';
pde4 = '+rho*omega^2*(u_test*u+v_test*v)';
pdeEnd = ')';
pde = strcat(pdeStart,pde1,pde2,pde3,pde4,pdeEnd);

% Subdomain settings
clear equ
equ.weak = pde;
equ.dweak = 0;
equ.ind = [1,1];
equ.dim = {'u','v'};
appl.equ = equ;

fem.const = { 'th',th, 'K1',K1, 'K2',K2, 'K3',K3, 'rho',rho, 'omega',omega, 'F', F };

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
  u = postinterp(fem, 'u', p);
  v = postinterp(fem, 'v', p);
end
