function [w_bnds,w_ctrs] = FreqResp( freq, nRes )

bSolve = 1;
%freq = 400;
%nRes = 4;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r =   [ 0.005, 0.008, 0.023 ];
E =   [ 2.0696e11, 1.175e5, 4.35e9 ];
nu =  [ 0.3, 0.469, 0.368 ];
rho = [ 7780, 1300, 1180 ];
h =   [ .004, .0018, .004 ];


%========================================================
%  Load Geometry
%========================================================
clear s;
switch nRes
  case 2
    [s,subs,bnds,outBnds,outCtrs] = Geom2( r(1), r(2), r(3) );
  case 3
    [s,subs,bnds,outBnds,outCtrs] = Geom3( r(1), r(2), r(3) );
  case 4
    [s,subs,bnds,outBnds,outCtrs] = Geom4( r(1), r(2), r(3) );
  otherwise
    [s,subs,bnds,outBnds,outCtrs] = Geom1( r(1), r(2), r(3) );
end

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains
%========================================================
for i = 1:length(subs)
  hm(2*i-1) = i;
  hm(2*i) = h(subs(i));
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
bnd.constrcond = {'free','sym','free'};
bnd.Fz = {0,0,1000};
bnd.ind = bnds;
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
equ.rho = { rho(1), rho(2), rho(3) };
equ.nu = { nu(1), nu(2), nu(3) };
equ.E = { E(1), E(2), E(3) };
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
  xc = zeros(size(outCtrs));
  pb = [xb;xb;outBnds];
  pc = [xc;xc;outCtrs];
  w_bnds = postinterp( fem, 'w', pb );
  w_ctrs = postinterp( fem, 'w', pc );
end

