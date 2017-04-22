function [s,subs,bnds,outBnd] = Geom( rRes, rSpr, nRes )

d = rRes+rSpr;

% Geometry
for i = 1:nRes
  gRes{i} = block3( rRes/2,rRes/2,rRes, 'base','center', 'pos',[0,0,(i-1)*d], 'axis',{'0','0','1'}, 'rot','0' );
  gResName{i} = strcat( 'Res', num2str(i) );
  if( i < nRes )
    gSpr{i} = block3( rRes/2,rRes/2,rSpr, 'base','center', 'pos',[0,0,(i-1/2)*d], 'axis',{'0','0','1'}, 'rot','0' );
    gSprName{i} = strcat( 'Spr', num2str(i) );
  end
end

s.objs = { gRes{:}, gSpr{:} };
s.name = { gResName{:}, gSprName{:} };
s.tags = { gResName{:}, gSprName{:} };

subs = [ ones(1,nRes), 2*ones(1,nRes-1) ];

nbnds = 5*(2*nRes-1)+1;
for i = 1:(2*nRes-1)
  bnd2(i) = 3*i;
end
bnd3  = 3*(2*nRes-1)+1;

bnds = ones(1,nbnds);
bnds(bnd2) = 2;
bnds(bnd3) = 3;
outBnd = [-rRes/2];


