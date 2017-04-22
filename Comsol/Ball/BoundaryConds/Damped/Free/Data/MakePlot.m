d0 = load('FRUP-0.dat');
d1 = load('FRUP-1.dat');
d2 = load('FRUP-2.dat');
d3 = load('FRUP-3.dat');
d4 = load('FRUP-4.dat');
d5 = load('FRUP-5.dat');

f = d0(:,1);
a = (2*pi*f).^2;

r0 = a .* abs( d0(:,2) );
r1 = a .* abs( d1(:,2) + j*d1(:,3) );
r2 = a .* abs( d2(:,2) + j*d2(:,3) );
r3 = a .* abs( d3(:,2) + j*d3(:,3) );
r4 = a .* abs( d4(:,2) + j*d4(:,3) );
r5 = a .* abs( d5(:,2) + j*d5(:,3) );


semilogy(f,r1,f,r2,f,r3,f,r4,f,r5);





