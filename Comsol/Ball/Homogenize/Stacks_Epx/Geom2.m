function [s,subs,bnds,outBnd,outCtr] = Geom2( rStl, rSil, rEpx )

d = rEpx;

% Geometry
g1a = sphere3( rStl, 'pos',[0,0,d/2], 'axis',{'0','0','1'}, 'rot','0' );
g2a = sphere3( rSil, 'pos',[0,0,d/2], 'axis',{'0','0','1'}, 'rot','0' );
g1b = sphere3( rStl, 'pos',[0,0,-d/2], 'axis',{'0','0','1'}, 'rot','0' );
g2b = sphere3( rSil, 'pos',[0,0,-d/2], 'axis',{'0','0','1'}, 'rot','0' );
g3 = block3( rEpx,rEpx,2*rEpx, 'base','center', 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );

gStla = g1a;
gSila = geomcomp( {g2a,g1a}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gStlb = g1b;
gSilb = geomcomp( {g2b,g1b}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpx = geomcomp( {g3,g2a,g2b}, 'ns',{'obj1','obj2','obj3'}, 'sf','obj1-obj2-obj3', 'face','none', 'edge','all' );

gTmp = block3( rEpx/2,rEpx/2,2*rEpx, 'base','center', 'pos',[rEpx/4,rEpx/4,0], 'axis',{'0','0','1'}, 'rot','0' );
gStla = geomcomp( {gStla,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSila = geomcomp( {gSila,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStlb = geomcomp( {gStlb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSilb = geomcomp( {gSilb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gEpx  = geomcomp( {gEpx, gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );

% Analyzed geometry
clear s;
s.objs={gStla,gSila,gStlb,gSilb,gEpx};
s.name={'Stla','Sila','Stlb','Silb','Epx'};
s.tags={'gStla','gSila','gStlb','gSilb','gEpx'};

subs = [1,2,1,2,3];
bnds = [2,2,1,2,2,1,2,2,1,1,1,2,2,1,2,2,1,1,1,3,2,2];
outBnd = [-d,0];
outCtr = outBnd + d/2;
