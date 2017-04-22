function [s,Subs] = SymGeom

rStl = 5.e-3;
rSil = 7.e-3;
rEpx = 12.7e-2;
rFor = 4.45e-2;
tEpx = 1.9e-2;

rOut = 0.1085/2;
rIn = 0.1015/2;
rTh = 0.0035;

[x,y,xb,yb] = GetCenters( rEpx, 2*rSil );
rEpx = 0.13;

gEpx = block3( rEpx,rEpx,tEpx, 'base','center', 'pos',[0,0,0], 'axis',{'0','0','1'}, 'rot','0' );

gRng1 = cylinder3( rOut,rTh, 'pos',[0,0,tEpx/2],   'axis',{'0','0','1'}, 'rot','0' );
gRng2 = cylinder3( rOut,rTh, 'pos',[0,0,-rTh-tEpx/2],  'axis',{'0','0','1'}, 'rot','0' );
gTmp1 = cylinder3( rIn, rTh, 'pos',[0,0,tEpx/2],  'axis',{'0','0','1'}, 'rot','0' );
gTmp2 = cylinder3( rIn, rTh, 'pos',[0,0,-rTh-tEpx/2], 'axis',{'0','0','1'}, 'rot','0' );
gRng1 = geomcomp( {gRng1,gTmp1}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gRng2 = geomcomp( {gRng2,gTmp2}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

[gStl1, gSil1] =  GetGeoms( x(1),  y(1),  rStl, rSil );
[gStl2, gSil2] =  GetGeoms( x(2),  y(2),  rStl, rSil );
[gStl3, gSil3] =  GetGeoms( x(3),  y(3),  rStl, rSil );
[gStl4, gSil4] =  GetGeoms( x(4),  y(4),  rStl, rSil );
[gStl5, gSil5] =  GetGeoms( x(5),  y(5),  rStl, rSil );
[gStl6, gSil6] =  GetGeoms( x(6),  y(6),  rStl, rSil );
[gStl7, gSil7] =  GetGeoms( x(7),  y(7),  rStl, rSil );
[gStl8, gSil8] =  GetGeoms( x(8),  y(8),  rStl, rSil );
[gStl9, gSil9] =  GetGeoms( x(9),  y(9),  rStl, rSil );
[gStl10,gSil10] = GetGeoms( x(10), y(10), rStl, rSil );
[gStl11,gSil11] = GetGeoms( x(11), y(11), rStl, rSil );
[gStl12,gSil12] = GetGeoms( x(12), y(12), rStl, rSil );
[gStl13,gSil13] = GetGeoms( x(13), y(13), rStl, rSil );
[gStl14,gSil14] = GetGeoms( x(14), y(14), rStl, rSil );
[gStl15,gSil15] = GetGeoms( xb(1), yb(1), rStl, rSil );
[gStl16,gSil16] = GetGeoms( xb(2), yb(2), rStl, rSil );
[gStl17,gSil17] = GetGeoms( xb(3), yb(3), rStl, rSil );
[gStl18,gSil18] = GetGeoms( xb(4), yb(4), rStl, rSil );
[gStl19,gSil19] = GetGeoms( xb(5), yb(5), rStl, rSil );
[gStl20,gSil20] = GetGeoms( xb(6), yb(6), rStl, rSil );

gTmp = block3( rEpx/2,rEpx/2,tEpx+2*rTh, 'base','center', 'pos',[rEpx/4,rEpx/4,0], 'axis',{'0','0','1'}, 'rot','0' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gRng1 = geomcomp( {gRng1,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gRng2 = geomcomp( {gRng2,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );

gStl15 = geomcomp( {gStl15,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStl16 = geomcomp( {gStl16,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStl17 = geomcomp( {gStl17,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStl18 = geomcomp( {gStl18,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStl19 = geomcomp( {gStl19,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStl20 = geomcomp( {gStl20,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil15 = geomcomp( {gSil15,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil16 = geomcomp( {gSil16,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil17 = geomcomp( {gSil17,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil18 = geomcomp( {gSil18,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil19 = geomcomp( {gSil19,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSil20 = geomcomp( {gSil20,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );


gTmp = geomcomp( {gSil1,gStl1,gSil2,gStl2}, 'ns',{'obj1','obj2','obj3','obj4'}, 'sf','obj1+obj2+obj3+obj4', 'face','none', 'edge','all' );
gTmp = geomcomp( {gTmp,gSil3,gStl3,gSil4,gStl4}, 'ns',{'obj1','obj2','obj3','obj4','obj5'}, ...
		  'sf','obj1+obj2+obj3+obj4+obj5', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = geomcomp( {gSil5,gStl5,gSil6,gStl6}, 'ns',{'obj1','obj2','obj3','obj4'}, 'sf','obj1+obj2+obj3+obj4', 'face','none', 'edge','all' );
gTmp = geomcomp( {gTmp,gSil7,gStl7,gSil8,gStl8}, 'ns',{'obj1','obj2','obj3','obj4','obj5'}, ...
		  'sf','obj1+obj2+obj3+obj4+obj5', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = geomcomp( {gSil9,gStl9,gSil10,gStl10}, 'ns',{'obj1','obj2','obj3','obj4'}, 'sf','obj1+obj2+obj3+obj4', 'face','none', 'edge','all' );
gTmp = geomcomp( {gTmp,gSil11,gStl11,gSil12,gStl12}, 'ns',{'obj1','obj2','obj3','obj4','obj5'}, ...
		  'sf','obj1+obj2+obj3+obj4+obj5', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = geomcomp( {gSil13,gStl13,gSil14,gStl14}, 'ns',{'obj1','obj2','obj3','obj4'}, 'sf','obj1+obj2+obj3+obj4', 'face','none', 'edge','all' );
gTmp = geomcomp( {gTmp,gSil15,gStl15,gSil16,gStl16}, 'ns',{'obj1','obj2','obj3','obj4','obj5'}, ...
		  'sf','obj1+obj2+obj3+obj4+obj5', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = geomcomp( {gSil17,gStl17,gSil18,gStl18}, 'ns',{'obj1','obj2','obj3','obj4'}, 'sf','obj1+obj2+obj3+obj4', 'face','none', 'edge','all' );
gTmp = geomcomp( {gTmp,gSil19,gStl19,gSil20,gStl20}, 'ns',{'obj1','obj2','obj3','obj4','obj5'}, ...
		  'sf','obj1+obj2+obj3+obj4+obj5', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );


% Analyzed geometry
clear s
s.objs={gEpx,gRng1,gRng2,...
	gStl1,gStl2,gStl3,gStl4,gStl5,gStl6,gStl7,gStl8,gStl9,gStl10,...
	gStl11,gStl12,gStl13,gStl14,gStl15,gStl16,gStl17,gStl18,gStl19,gStl20,...
	gSil1,gSil2,gSil3,gSil4,gSil5,gSil6,gSil7,gSil8,gSil9,gSil10,...
	gSil11,gSil12,gSil13,gSil14,gSil15,gSil16,gSil17,gSil18,gSil19,gSil20};

sEpx = 1;
sRng = [4,4];
sStl = 3*ones(1,20);
sSil = 2*ones(1,20);
Subs = [sEpx,sRng,sStl,sSil];




%=========================================================
%  Temporary

%fem.draw=struct('s',s);
%[g,st] = geomcsg(fem);
%[SubInd,s0] = find(st);   
%fem.geom = geomcsg(fem);
%size(SubInd)


% (Default values are not included)
% Application mode 1
%clear appl
%appl.mode.class = 'SmeSolid3';
%appl.module = 'SME';
%appl.gporder = 4;
%appl.cporder = 2;
%appl.assignsuffix = '_smsld';

%fem.appl{1} = appl;
%fem.frame = {'ref'};
%fem.border = 1;
%clear units;
%units.basesystem = 'SI';
%fem.units = units;

% Multiphysics
%fem=multiphysics(fem);
