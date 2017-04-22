function [s] = SymmetricGeom( rStl, rSil, rEpxX, rEpxY, rEpxZ )

% Geometry
g1 = sphere3( rStl, 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );
g2 = sphere3( rSil, 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );
g3 = block3( rEpxX,rEpxY,rEpxZ, 'base','center', 'pos',{'0','0','0'}, 'axis',{'0','0','1'}, 'rot','0' );
gStl = g1;
gSil = geomcomp( {g2,g1}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpx = geomcomp( {g3,g2}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = block3( rEpxX/2,rEpxY,rEpxZ, 'base','center', 'pos',[-rEpxX/4,0,0], 'axis',{'0','0','1'}, 'rot','0' );
gStl = geomcomp( {gStl,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gSil = geomcomp( {gSil,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

gTmp = block3( rEpxX,rEpxY/2,rEpxZ, 'base','center', 'pos',[0,-rEpxY/4,0], 'axis',{'0','0','1'}, 'rot','0' );
gStl = geomcomp( {gStl,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gSil = geomcomp( {gSil,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
gEpx = geomcomp( {gEpx,gTmp}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );

% Analyzed geometry
clear s
s.objs={gStl,gSil,gEpx};
s.name={'Stl','Sil','Epx'};
s.tags={'gStl','gSil','gEpx'};

