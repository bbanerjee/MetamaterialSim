function [s,subs,bnds,outBnd,outCtr] = Geom2( rStl, rSil, rEpx, rSpr )

d = rEpx+rSpr;

% Geometry
g1a = sphere3( rStl, 'pos',[0,0,d/2], 'axis',{'0','0','1'}, 'rot','0' );
g2a = sphere3( rSil, 'pos',[0,0,d/2], 'axis',{'0','0','1'}, 'rot','0' );
g1b = sphere3( rStl, 'pos',[0,0,-d/2], 'axis',{'0','0','1'}, 'rot','0' );
g2b = sphere3( rSil, 'pos',[0,0,-d/2], 'axis',{'0','0','1'}, 'rot','0' );
g3a = block3( rEpx,rEpx,rEpx, 'base','center', 'pos',[0,0,d/2], 'axis',{'0','0','1'}, 'rot','0' );
g3b = block3( rEpx,rEpx,rEpx, 'base','center', 'pos',[0,0,-d/2], 'axis',{'0','0','1'}, 'rot','0' );
g4 = block3( rEpx,rEpx,rSpr, 'base','center', 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );

gStla = g1a;
gSila = geomcomp( {g2a,g1a}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpxa = g3a;
gStlb = g1b;
gSilb = geomcomp( {g2b,g1b}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpxa = g3b;
gEpxa = geomcomp( {g3a,g2a}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpxb = geomcomp( {g3b,g2b}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = block3( rEpx/2,rEpx/2,2*rEpx+rSpr, 'base','center', 'pos',[rEpx/4,rEpx/4,0], 'axis',{'0','0','1'}, 'rot','0' );
gStla = geomcomp( {gStla,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSila = geomcomp( {gSila,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gStlb = geomcomp( {gStlb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSilb = geomcomp( {gSilb,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gEpxa  = geomcomp( {gEpxa, gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gEpxb  = geomcomp( {gEpxb, gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );
gSpr = geomcomp( {g4, gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1*obj2', 'face','none', 'edge','all' );

% Analyzed geometry
clear s;
s.objs={gStla,gSila,gStlb,gSilb,gEpxa,gEpxb,gSpr};
s.name={'Stla','Sila','Stlb','Silb','Epxa','Epxb','Spr'};
s.tags={'gStla','gSila','gStlb','gSilb','gEpxa','gEpxb','Spr'};

subs = [1,2,1,2,3,3,2];
bnds = [2,2,1,2,2,1,2,2,1,1,1,2,2,1,2,2,1,2,2,1,2,2,1,1,1,3,2,2,2,2,2,2];
outBnd = [-rEpx-rSpr/2,0];
outCtr = [-d/2,d/2];
