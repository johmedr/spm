function [F,S,Q,L,H] = spm_NESS_gen(P,M,U)
% generates flow (f) at locations (U.X)
% FORMAT [F,S,Q,L,H] = spm_NESS_gen(P,M,U)
% FORMAT [F,S,Q,L,H] = spm_NESS_gen(P,M)
%--------------------------------------------------------------------------
% P.Qp    - polynomial coefficients for solenoidal operator
% P.Sp    - polynomial coefficients for potential
%
% F       - polynomial approximation to flow
% S       - negative potential (log NESS density)
% Q       - flow operator (R + G) with solenoidal and symmetric parts
% L       - correction term for derivatives of solenoidal flow
% H       - Hessian
%
% U = spm_ness_U(M)
%--------------------------------------------------------------------------
% M   - model specification structure
% Required fields:
%    M.X  - sample points
%    M.W  - (n x n) - precision matrix of random fluctuations
%    M.K  - order of polynomial expansion
%
% U       - domain (of state space) structure
% U.x     - domain
% U.X     - sample points
% U.f     - expected flow at sample points
% U.J     - Jacobian at sample points
% U.b     - orthonormal polynomial basis
% U.D     - derivative operator
% U.G     - amplitude of random fluctuations
% U.v     - orthonormal operator
% U.u     - orthonormal operator (Kroneckor form)
% U.bG    - projection of flow operator (symmetric part: G)
% U.dQdp  - gradients of flow operator Q  w.r.t. flow parameters
% U.dbQdp - gradients of bQ w.r.t. flow parameters
% U.dLdp  - gradients of L w.r.t. flow parameters
%
% if U is not specified the parameters are rotated using U.v (and U.u). In
% other words, it is assumed that the parameters are polynomial
% coefficients , as opposed to coefficients of an orthonormal polynomial
% basis.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_ness_hd.m 8000 2020-11-03 19:04:17QDb karl $


%% use M.fs if specified
%--------------------------------------------------------------------------
if nargout < 3 && isfield(M,'fs')
    w     = {M.W(1)};
    Sp    = num2cell(P.Sp);
    Qp    = num2cell(P.Qp);
    for i = 1:size(M.X,1)
        
        % flow
        %------------------------------------------------------------------
        x      = num2cell(M.X(i,:));
        F(i,:) = M.fs(Qp{:},Sp{2:end},w{:},x{:});
        
        % negative potential
        %------------------------------------------------------------------
        if nargout == 2
            S(i)   = M.ss(Sp{:},x{:});
        end
    end
    
    return
end


%% get basis or expansion from M.X (or M.x)
%--------------------------------------------------------------------------
if nargin < 3
    
    U    = spm_ness_U(M);
    
    % project parameters for this orthonormal basis
    %----------------------------------------------------------------------
    P.Sp = U.v\P.Sp;
    P.Qp = U.u\P.Qp;
    
end

% dimensions and correction terms to flow operator
%==========================================================================
n  = numel(U.D);
nX = size(U.b,1);

% sparse diagonal operator
%--------------------------------------------------------------------------
if nX > 1
    spd = @(x)sparse(1:numel(x),1:numel(x),x(:),numel(x),numel(x));
else
    spd = @(x)diag(x(:));
end

% flow operator (bQ)
%--------------------------------------------------------------------------
bQ    = 0;
for i = 1:numel(U.dbQdp)
    bQ = bQ + U.dbQdp{i}*P.Qp(i);
end

% correction term for solenoidal flow (L) and Kroneckor form of Q
%--------------------------------------------------------------------------
Q     = cell(n,n);
L     = zeros(nX,n,'like',U.b(1));
F     = zeros(nX,n,'like',U.b(1));
for i = 1:n
    for j = 1:n
        bQij   = squeeze(bQ(i,j,:) + U.bG(i,j,:));
        L(:,i) = L(:,i) - U.D{j}*bQij;
        Q{i,j} = spd(U.b*bQij);
    end
end

% predicted flow: F   = Q*D*S - L
%--------------------------------------------------------------------------
for i = 1:n
    for j = 1:n
        DS     = U.D{j}*P.Sp;
        F(:,i) = F(:,i) + Q{i,j}*DS;
    end
    F(:,i) = F(:,i) - L(:,i);
end

if nargout == 1, return, end

% inverse (scalar) potential:  S = log(p(x))there
%--------------------------------------------------------------------------
S     = U.b*P.Sp;

% Hessian D*D*S
%--------------------------------------------------------------------------
HH    = cell(n,n);
for i = 1:n
    for j = 1:n
       HH{i,j} = U.H{i,j}*U.v*P.Sp;    
    end
end
H     = zeros(n,n,nX,'like',U.b(1));
for i = 1:n
    for j = 1:n
        for k = 1:nX
            H(i,j,k) = HH{i,j}(k);
        end
    end
end


return










