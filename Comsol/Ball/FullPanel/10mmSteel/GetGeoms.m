function [gStl,gSil] = GetGeoms(x,y,rStl,rSil)

gStl = sphere3( rStl, 'pos',[x,y,0], 'axis',{'0','0','1'}, 'rot','0' );
gTmp = sphere3( rSil, 'pos',[x,y,0], 'axis',{'0','0','1'}, 'rot','0' ); 
gSil = geomcomp( {gTmp,gStl}, 'ns',{'obj1','obj2'}, 'sf','obj1-obj2', 'face','none', 'edge','all' );
