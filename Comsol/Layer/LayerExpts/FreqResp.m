function [w] = FreqResp( freq, n, d_f, d_m, E_f, rho_f, beta )

bSolve = 1;
nargin = 1;

if nargin < 1
  freq = 500;
  n = 3;
  d_f = 0.01;
  d_m = 0.005;
  E_f = 2.e11;
  rho_f = 7850;
  beta = 1.e-3;
end

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
E_m = 1.175e5;
nu_m = 0.469;
rho_m = 1300;

nu_f = 0.3;

E   = [ E_f, E_m ];
nu  = [ nu_f, nu_m ];
rho = [ rho_f, rho_m ];
h0   = [ 0.001 ];
P = 1000;


%========================================================
%  Load Geometry
%========================================================
clear s;
[s,subs,bnds,outBnds] = Geom( d_f, d_m, n );

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
for i = 1:length(subs)
  hm(2*i-1) = i;
  hm(2*i) = h0;
end
fem.mesh=meshinit( fem, 'hauto',5, 'hmaxsub',hm );


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


%========================================================
%  Boundary Conditions
%========================================================
clear bnd
bnd.constrcond = {'sym','free','free'};
bnd.Fz = {0,0,P};
bnd.ind = bnds;
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'Rayleigh';
equ.betadK = { beta };
equ.alphadM = { 0 };

equ.rho = { rho(1), rho(2) };
equ.nu = { nu(1), nu(2) };
equ.E = { E(1), E(2) };

equ.ind( SubInd ) = subs;
appl.equ = equ;
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;
fem=multiphysics(fem);


%========================================================
%  Solve
%========================================================
if( bSolve )
  fem.xmesh=meshextend(fem);
  fem.sol=femstatic(fem, 'solcomp',{'w','u','v'}, 'outcomp',{'w','u','v'}, ...
                  'pname','freq_smsld', 'plist',[freq], 'oldcomp',{}, ...
                  'linsolver','spooles');
  fem0=fem;
  xb = zeros(size(outBnds));
  pb = [xb;xb;outBnds];
  w = postinterp( fem, 'w', pb );
end

