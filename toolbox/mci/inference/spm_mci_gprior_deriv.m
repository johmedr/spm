function [j] = spm_mci_gprior_deriv (Pr,M)
% Gradient of Log Gaussian prior
% FORMAT [j] = spm_mci_gprior_deriv (Pr,M)
%
% Pr        parameters (vectorised and in M.V subspace)
% M         model structure
%
% j         gradient of log Gaussian prior
%__________________________________________________________________________
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging

% Will Penny and Biswa Sengupta
% $Id: spm_mci_gprior_deriv.m 6275 2014-12-01 08:41:18Z will $

Pr=Pr(:);

% Parameters errors in subspace
e = Pr;

% Gradient
j = - e'*M.ipC;
