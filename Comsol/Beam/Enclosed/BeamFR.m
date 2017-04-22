function [u,v] = BeamFR( freq, hAcross, sType, Fphi )
%  freq:  Input Frequency,  hAcross:  Number of Elements Across Beam
%  sType = 1:  Plane Stress
%          2:  Plane Strain  

flclear fem;
bSolve = 1;
%Fphi = 0;
%hAcross = 4;
%freq = 65;
%sType = 2;

F = -1000;
dScale = 1.e-1;                           %  Size Scaling - 1.0 is a meter resonator

%  Dimensions
mx = dScale * 1.0;                        %  Matrix Unit Side
mt = dScale * 2.e-1;                      %  Matrix Unit Wall Thickness
bx = dScale * 2.e-2;                      %  Beam Width
by = dScale * 5.5e-1;                     %  Beam Height
hz = dScale * 1.0;                        %  Depth

%  Material Parameters
rhob = 7850;
rhom = rhob;
Eb = 2.0e11;
Em = Eb;
nub = 0.33;
num = nub;

%  Stiffness Parameters
if( sType == 1 )
  Db = Eb/(1-nub^2);
  Dm = Em/(1-num^2);
  Kb = [Db, Db*nub, Db*(1-nub)/2];
  Km = [Dm, Dm*num, Dm*(1-num)/2];
else
  Db = Eb/(1+nub)/(1-2*nub);
  Dm = Em/(1+num)/(1-2*num);
  Kb = [Db*(1-nub), Db*nub, Db*(1-2*nub)/2];
  Km = [Dm*(1-num), Dm*num, Dm*(1-2*num)/2];
end

omega = 2*pi*freq;
Fx = -F * cos( Fphi ) * hz;
Fy = -F * sin( Fphi ) * hz;

% Geometry
mi = mx - 2*mt;
gMat1 = rect2( mt,mt, 'base','corner', 'pos',[ 0, 0 ], 'rot','0' );
gMat2 = rect2( mt,mi, 'base','corner', 'pos',[ 0, mt], 'rot','0' );
gMat3 = rect2( mt,mt, 'base','corner', 'pos',[ 0, mi+mt], 'rot','0' );
gMat4 = rect2( (mi-bx)/2,mt, 'base','corner', 'pos',[mt,0], 'rot','0' );
gMat5 = rect2( bx,mt, 'base','corner', 'pos',[(mx-bx)/2,0], 'rot','0' );
gMat6 = rect2( (mi-bx)/2,mt, 'base','corner', 'pos',[(mx+bx)/2,0], 'rot','0' );
gMat7 = rect2( mt,mt, 'base','corner', 'pos',[mx-mt,0], 'rot','0' );
gMat8 = rect2( mt,mi, 'base','corner', 'pos',[mx-mt,mt], 'rot','0' );
gMat9 = rect2( mi,mt, 'base','corner', 'pos',[mt,mx-mt], 'rot','0' );
gMat10 = rect2( mt,mt, 'base','corner', 'pos',[mx-mt,mx-mt], 'rot','0' );
gBeam = rect2( bx,by, 'base','corner', 'pos',[(mx-bx)/2,mt], 'rot','0' );
SubBeam = [2,2,2,2,2,2,2,2,2,2,1];

clear s
s.objs={gMat1,gMat2,gMat3,gMat4,gMat5,gMat6,gMat7,gMat8,gMat9,gMat10,gBeam};
fem.draw=struct('s',s);
fem.geom=geomcsg(fem);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
SubAll = ones( 1, size(st,1) );            


%  Create Mapped Mesh
hs0 = 1/hAcross;
bs = bx*2;
hs1 = hs0 * 1/ceil(mt/bs);                   %  Corner
hs2 = hs0 * 1/ceil(mi/bs);                   %  Sides
hs3 = hs0 * 1/ceil((mi-bx)/2/bs);            %  Bottom            
hs4 = hs0 * 1/ceil(by/bs);                   %  Beam
h0 = 0:hs0:1;
h1 = 0:hs1:1;
h2 = 0:hs2:1;
h3 = 0:hs3:1;
h4 = 0:hs4:1;
fem.mesh=meshmap(fem, 'edgelem',{ 1,h1, 2,h1, 3,h2, 5,h1, 9,h3, 13,h2, 16,h0, ...
				  17,h4, 21,h3, 25,h1, 26,h2}, 'hauto',5);


%  Weak PDE Application Mode 
clear appl
appl.mode.class = 'FlPDEW';
appl.dim = {'u','v','u_t','v_t'};
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_w';


%  Boundary Settings
clear bnd
bnd.weak = {0,'Fx*u_test',{0;'Fy*v_test'}};
bnd.constr = 0;
bnd.ind = [2,3,2,1,2,1,1,1,3,1,1,1,1,1,1,3,1,1,1,1,3,1,1,1,3,1,1,1,1,1,1,1,1];
appl.bnd = bnd;


% Subdomain settings
pdeStart = 'th*(';
pde1 = '-ux_test*(K1*ux+K2*vy)';
pde2 = '-vy_test*(K2*ux+K1*vy)';
pde3 = '-(uy_test+vx_test)/2*K3*(uy+vx)/2';
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
equ.expr = { 'rho',{rhob,rhom}, 'K1',{Kb(1),Km(1)}, 'K2',{Kb(2),Km(2)}, 'K3',{Kb(3),Km(3)} };
fem.const = { 'th',hz, 'omega',omega, 'Fx', Fx, 'Fy',Fy };
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

  p = [mx;mx/2];
  u = postinterp( fem, 'u', p );
  v = postinterp( fem, 'v', p );
end
