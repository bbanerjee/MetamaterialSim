function [m] = GetMass

l = 0.13;
th = 0.019;
rStl = 0.003;
rSil = 0.007;

nRes = 68;

pStl = 7780;
pSil = 1300;
pEpx = 1180;

vBlank = l^2 * th
v1Res = 4/3 * pi * rSil^3;
v1Stl = 4/3 * pi * rStl^3;
v1Sil = v1Res - v1Stl;

vEpx = vBlank - nRes * v1Res
vSil = nRes * v1Sil;
vStl = nRes * v1Stl;

mEpx = vEpx * pEpx / 4;
mSil = vSil * pSil / 4;
mStl = vStl * pStl / 4;

m = mEpx + mSil + mStl;
