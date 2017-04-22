function [s,subs,bnds,outBnd] = Geom( df, dm, n )

d = df + dm;;
dd = d/8;
cnr = -dd/2;

gFiber{1} = block3( dd,dd,df, 'base','corner', 'pos',[cnr,cnr,0], 'axis',{'0','0','1'}, 'rot','0' );
gFiberName{1} = 'Fiber1';

% Geometry
for i = 1:n  
  gMatrix{i} = block3( dd,dd,dm, 'base','corner', 'pos',[cnr,cnr,(i-1)*d+df], 'axis',{'0','0','1'}, 'rot','0' );
  gMatrixName{i} = strcat( 'Matrix', num2str(i) );
  
  gFiber{i+1} = block3( dd,dd,df, 'base','corner', 'pos',[cnr,cnr,i*d], 'axis',{'0','0','1'}, 'rot','0' );
  gFiberName{i+1} = strcat( 'Fiber', num2str(i) );
end

s.objs = { gFiber{:}, gMatrix{:} };
s.name = { gFiberName{:}, gMatrixName{:} };
s.tags = { gFiberName{:}, gMatrixName{:} };

subs = [ ones(1,n+1), 2*ones(1,n) ];

m = n + 1;
nbnds = 5*(2*m-1)+1;
for i = 1:(2*m-1)
  bnd2(i) = 3*i;
end
bnd3  = 3*(2*m-1)+1;

bnds = ones(1,nbnds);
bnds(bnd2) = 2;
bnds(bnd3) = 3;
outBnd = [0];


