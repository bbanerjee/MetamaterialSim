%function [w,wi,w2] = SymFreqs( freq )

bSolve = 0;
freq = 1000;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
rStl = 3.e-3;
rSil = 7e-3;
rEpx = 12.7e-2;
rFor = 4.45e-2;
tEpx = 1.9e-2;

rOut = 0.1085/2;
rIn = 0.1015/2;
rTh = 0.0035;
E = [ 4.35e9, 1.175e5, 2.0696e11, 2.5e5 ];
nu = [ 0.368, 0.469, 0.3, 0.45 ];
rho = [ 1180, 1300, 7780, 1200 ];
h = [ .07, .0037, .1, 0.003 ];

%========================================================
%  Load Geometry
%========================================================
clear s;
[s,Subs] = SymGeom;

fem.draw=struct('s',s);
[g,st,ft,pt] = geomcsg(fem);
[SubInd,s0] = find(st);
fem.geom = geomcsg(fem);


%========================================================
%  Mesh Subdomains (Coarse)
%========================================================
for i = 1:length(Subs)
  dh(2*i-1) = SubInd(i);
  dh(2*i)   = h( Subs(i) );
end

fem.mesh=meshinit(fem, 'hmaxsub',dh );
%fem.mesh=meshinit(fem, 'hauto',6);


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
bnd.constrcond = {'free','fixed','sym','free'};
bnd.Fz = {0,0,0,1000};
bnd.ind = [3,3,1,4,3,1,1,3,1,1,1,1,1,1,3,1,1,3,1,1,1,1,1,1,3,1,2,1,3,1, ...
  1,2,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
appl.bnd = bnd;


%========================================================
%  Set Up Solver
%========================================================
clear equ
equ.dampingtype = 'nodamping';
equ.rho = { rho(1), rho(2), rho(3), rho(4) };
equ.nu = { nu(1), nu(2), nu(3), nu(4) };
equ.E = { E(1), E(2), E(3), E(4) };
equ.ind( SubInd ) = Subs;
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
  p = [0;0;-(1.9e-2)/2];
  w = postinterp(fem, 'w', p);
  p2 = [.13/2;.13/2;-.019/2];
  w2 = postinterp(fem, 'w', p);
  A = pi*rIn^2/4;
  wi = 1/A * postint(fem,'w', 'unit','m^3', 'dl',[3], 'edim',2);

  rEpx = 12.7e-2;
  rSil = 7.0e-3;
  rStl = 3.0e-3;
  [x,y,xb,yb] = GetCenters( rEpx, 2*rSil );
  x = [x,xb];
  y = [y,yb];
  z = zeros(size(x));
  p1 = [x;y;z];
  w0 = postinterp(fem, 'w', p1);
  p1 = [x;y+rStl;z];
  u1 = postinterp(fem, 'u', p1);
  v1 = postinterp(fem, 'v', p1);
  w1 = postinterp(fem, 'w', p1);
  Fout = [ x; y; w0; u1; v1; w1 ];
  flname = strcat( 'Data/Balls/Balls-', num2str(freq), '.dat' );
  fl = fopen( flname, 'wt' );
  fprintf( fl, '%e %e %e %e %e %e\n', Fout );
  fclose( fl );
end
