function [s,subs,bnds,outBnd,outCtr] = Geom3( rStl, rSil, rEpx )

d = rEpx;

% Geometry
g1a = sphere3( rStl, 'pos',[0,0,0], 'axis',{'0','0','1'}, 'rot','0' );
g2a = sphere3( rSil, 'pos',[0,0,0], 'axis',{'0','0','1'}, 'rot','0' );
g1b = sphere3( rStl, 'pos',[0,0,d], 'axis',{'0','0','1'}, 'rot','0' );
g2b = sphere3( rSil, 'pos',[0,0,d], 'axis',{'0','0','1'}, 'rot','0' );
g1c = sphere3( rStl, 'pos',[0,0,-d], 'axis',{'0','0','1'}, 'rot','0' );
g2c = sphere3( rSil, 'pos',[0,0,-d], 'axis',{'0','0','1'}, 'rot','0' );
g3 = block3( rEpx,rEpx,3*rEpx, 'base','center', 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );

gStla = g1a;
gSila = geomcomp( {g2a,g1a}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gStlb = g1b;
gSilb = geomcomp( {g2b,g1b}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gStlc = g1c;
gSilc = geomcomp( {g2c,g1c}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpx  = geomcomp( {g3,g2a,g2b,g2c}, 'ns',{'obj1','obj2','obj3','obj4'}, ...
		  'sf','obj1-obj2-obj3-obj4', 'face','none', 'edge','all' );

gTmp = block3( rEpx/2,rEpx/2,3*rEpx, 'base','center', 'pos',[rEpx/4,rEpx/4,0], 'axis',{'0','0','1'}, 'rot','0' );
gStla = geomcomp( {gStla,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSila = geomcomp( {gSila,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStlb = geomcomp( {gStlb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSilb = geomcomp( {gSilb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStlc = geomcomp( {gStlc,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSilc = geomcomp( {gSilc,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gEpx  = geomcomp( {gEpx, gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );

% Analyzed geometry
clear s;
s.objs={gStla,gSila,gStlb,gSilb,gStlc,gSilc,gEpx};
s.name={'Stla','Sila','Stlb','Silb','Stlc','Silc','Epx'};
s.tags={'gStla','gSila','gStlb','gSilb','gStlc','gSilc','gEpx'};

subs = [1,2,1,2,1,2,3];
bnds = [2,2,1,2,2,1,2,2,1,1,1,2,2,1,2,2,1,1,1,2,2,1,2,2,1,1,1,3,2,2];
outCtr = [-d,0,d];
outBnd = outCtr - d/2;
