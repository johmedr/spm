function F = spm_Ncdf_jdw(x,u,v)
% CD) for univariate Normal distributions: J.D.  Willians aproximation
% FORMAT F = spm_Ncdf_jdw(x,u,v)
%
% x - ordinates
% u - mean              [Defaults to 0]
% v - variance  (v>0)   [Defaults to 1]
% F - pdf of N(u,v) at x (Lower tail probability)
%__________________________________________________________________________
%
% spm_Ncdf implements the Cumulative Distribution Function (CDF) for
% the Normal (Gaussian) family of distributions.
%
% References:
%--------------------------------------------------------------------------
% An Approximation to the Probability Integral
% J. D. Williams 
% The Annals of Mathematical Statistics, Vol. 17, No. 3. (Sep., 1946), pp.
% 363-365. 
%
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_Ncdf_jdw.m 1183 2008-03-03 18:26:05Z karl $


%-Format arguments
%--------------------------------------------------------------------------
if nargin < 3, v = 1; end
if nargin < 2, u = 0; end

%-Approximate integral
%--------------------------------------------------------------------------
x   = (x - u)/sqrt(v);
s   = sign(x);
x   = abs(x);
F   = sqrt(1 - exp(-(2/pi)*x.^2))/2;
F   = 1/2 + F.*s;