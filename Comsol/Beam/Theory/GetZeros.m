function [x0,idx] = GetZeros(x,y)

x0 = 0;
idx = 0;
n = length(y);
nz = 1;
for i=1:(n-1)
  if( y(i+1)*y(i) <= 0 )
    x0(nz) = x(i);
    idx(nz) = i;
    nz = nz+1;
  end
end
