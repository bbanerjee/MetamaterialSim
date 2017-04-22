function [w] = FreqResp( freq, rho_in, nRes )

bSolve = 1;
%freq = 1;
%rho_in = 1000;
%nRes = 2;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r0  = [ 0.005, 0.008, 0.023 ];
E0  = [ 2.0696e11, 1.175e5, 4.35e9 ];
nu0 = [ 0.3, 0.469, 0.368 ];
v   = [ 4/3*pi*r0(1)^3, 4/3*pi*(r0(2)^3-r0(1)^3), r0(3)^3-4/3*pi*r0(2)^3 ] / r0(3)^3;

r   = [ 0.023, 0.005 ];
E   = [ v(1)*E0(1)+v(2)*E0(2)+v(3)*E0(3), 1.175e5 ];
nu  = [ v(1)*nu0(1)+v(2)*nu0(2)+v(3)*nu0(3), 0.469 ];
rho = [ rho_in, 1300 ];
h   = [ .01, 0.005 ];


%========================================================
%  Load Geometry
%========================================================
clear s;
[s,subs,bnds,outBnds] = Geom( r(1), r(2), nRes );

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
for i = 1:length(subs)
  hm(2*i-1) = i;
  hm(2*i) = h( subs( find(SubInd==i) ) );
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
bnd.Fz = {0,0,1000};
bnd.ind = bnds;
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
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

