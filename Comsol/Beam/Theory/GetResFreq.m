function [f] = GetResFreq( alpha, L, E, b, rho )

f = sqrt( (alpha/L)^4 * E * b^2 / 48 / pi^2 / rho );
