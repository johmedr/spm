function [f]= spm_fx_adem_reach(x,v,a,P)
% returns the flow for a two-joint arm (with action)
% FORMAT [f]= spm_fx_adem_reach(x,v,a,P)
%
% x    - hidden states
% v    - causal states
% a    - action
% P    - parameters
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_fx_adem_reach.m 3058 2009-04-09 18:17:53Z karl $

% evaluate positions
%--------------------------------------------------------------------------
m    = [2  1]*2;                                 % mass
k    = [2  1]*4;                                 % viscosity

% flow
%==========================================================================
f    = [x(3);
        x(4);
      (-k(1)*x(3) + a(1) - (x(1) - pi/2)/4)/m(1);
      (-k(2)*x(4) + a(2) - (x(2) - pi/2)/4)/m(2)];
