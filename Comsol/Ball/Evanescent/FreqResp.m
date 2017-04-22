function [w] = FreqResp( freq )

bSolve = 1;
%freq = 400;

flclear fem;

%========================================================
%  Simulation Properties [ Steel, Silicon, Epoxy ]
%========================================================
r =   [ 0.005, 0.008, 0.023 ];
E =   [ 2.0696e11, 1.175e5, 4.35e9 ];
nu =  [ 0.3, 0.469, 0.368 ];
rho = [ 7780, 1300, 1180 ];
h = [.005, .0025, .005 ];
P =   1000;

%========================================================
%  Load Geometry
%========================================================
clear s;
[s,subs] = Geom1( r(1), r(2), r(3) );

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
clear i;
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
bnd.Fz = {0,1000};
bnd.ind = [1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
appl.bnd = bnd;

% Coupling variable elements
clear elemcpl
% Extrusion coupling variables
clear elem
elem.elem = 'elcplextr';
elem.g = {'1'};
src = cell(1,1);
clear bnd
bnd.expr = {{{},{},'u'},{{},{},'v'},{{},{},'w'},{'u',{},{}},{'v',{},{}},{'w', ...
  {},{}}};
bnd.map = {{'1','1','1'},{'1','1','1'},{'1','1','1'},{'1','1','1'},{'1','1', ...
  '1'},{'1','1','1'}};
bnd.ind = {{'1'},{'2','3','4','6','7','8','9','10','11','12','13','14', ...
  '15','16','17','18','19','20','21','22'},{'5'}};
src{1} = {{},{},bnd,{}};
elem.src = src;
geomdim = cell(1,1);
clear bnd
bnd.map = {{{},'2',{}},{{},'2',{}},{{},'2',{}},{{},{},'3'},{{},{},'3'}, ...
  {{},{},'3'}};
bnd.ind = {{'1','3','4','5','6','7','8','9','10','11','12','13','14', ...
  '15','16','17','18','19','20','21'},{'2'},{'22'}};
geomdim{1} = {{},{},bnd,{}};
elem.geomdim = geomdim;
elem.var = {'pconstr1','pconstr2','pconstr3','pconstr4','pconstr5', ...
  'pconstr6'};
map = cell(1,3);
clear submap
submap.type = 'unit';
map{1} = submap;
clear submap
submap.type = 'linear';
submap.sg = '1';
submap.sv = {'2','18','17','1'};
submap.dg = '1';
submap.dv = {'4','20','19','3'};
map{2} = submap;
clear submap
submap.type = 'linear';
submap.sg = '1';
submap.sv = {'20','19','17','18'};
submap.dg = '1';
submap.dv = {'4','3','1','2'};
map{3} = submap;
elem.map = map;
elemcpl{1} = elem;
% Point constraint variables (used for periodic conditions)
clear elem
elem.elem = 'elpconstr';
elem.g = {'1'};
clear bnd
bnd.constr = {{'pconstr1-(u)','pconstr2-(v)','pconstr3-(w)','0','0','0'},{'0', ...
  '0','0','pconstr4-(u)','pconstr5-(v)','pconstr6-(w)'}};
bnd.cpoints = {{'2','2','2','2','2','2'},{'2','2','2','2','2','2'}};
bnd.ind = {{'2'},{'22'}};
elem.geomdim = {{{},{},bnd,{}}};
elemcpl{2} = elem;
fem.elemcpl = elemcpl;


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

  rEpx = r(3);
  dx = rEpx/200;
  [x,y] = meshgrid(-rEpx/2:dx:rEpx/2,-rEpx/2:dx:rEpx/2);
  z = -rEpx/2 * ones(size(x));
  p = [x(:)'; y(:)';z(:)'];  %'
  w = postinterp(fem, 'w', p);
  w = reshape(w, size(x));
end
