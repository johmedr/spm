function [dx] = spm_dx(dfdx,f,t)
% returns dx(t) = (expm(dfdx*t) - I)*inv(dfdx)*f
% FORMAT [dx] = spm_dx(dfdx,f,[t])
% dfdx   = df/dx
% f      = dx/dt
% t      = integration time: (default t = Inf);
%          if t is a cell (i.e., {t}) then t is set to t{1}/norm(dfdx)
%
% dx     = x(t) - x(0)
%--------------------------------------------------------------------------
% Integration of a dynamic system using local linearization.  This scheme
% accommodates nonlinearities in the state equation by using a functional of
% f(x) = dx/dt.  This uses the equality
%
%             expm([0    0]*t) = expm(dfdx*t) - I)*inv(dfdx)*f
%                  [f dfdx]
%
% When t -> Inf this reduces to
%
%              dx(t) = -inv(dfdx)*f
%
% When f = dF/dx (and dfdx = dF/dxdx), dx represents the update from a
% Gauss-Newton ascent on F.  This can be regularised by specifying a finite
% t, A heavy regularization corresponds to t = 1/norm(dfdx) and a light
% regularization would be t = 32/norm(dfdx).  norm(dfdx) represents an upper
% bound on the rate of convergence (c.f., a Lyapunov exponent of the
% ascent)
%__________________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% Karl Friston
% $Id: spm_int_J.m 253 2005-10-13 15:31:34Z karl $

% defaults
%--------------------------------------------------------------------------
if nargin < 3, t = 1e16;               end
if iscell(t),  t = t{1}/normest(dfdx); end

% use a [pseudo]inverse if t > 1e8
%==========================================================================
if t > 1e8
    if condest(dfdx) < 1e8
        dx = -inv(dfdx)*f;
    else
        dx = -pinv(full(dfdx))*f;
    end
    return
end

% augment Jacobian and take matrix exponential
%==========================================================================
Jx    = spm_cat({0 []; f dfdx});
dx    = spm_expm(Jx*t);
dx    = dx(2:end,1);

% if system is unstable
%==========================================================================
if norm(dx,1) > 1e6

    % find the eigen-system and remove unstable modes
    %----------------------------------------------------------------------
    [v d] = eig(full(dfdx));
    v     = v(find(real(diag(d))) > 0,:);
    f     = f - v*pinv(v)*f;
    dx    = spm_dx(dfdx,f,t);

end

return

% report system is non-dissipative
%--------------------------------------------------------------------------
LE     = max(real(d));
if LE > 0
    warndlg(sprintf('Lyapunov exponent = %.2e',LE))
end

