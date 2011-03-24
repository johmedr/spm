function [F,sE,sC] = spm_log_evidence(varargin)
% Return the log-evidence of a reduced model (under Laplace approximation)
% FORMAT [F,sE,sC] = spm_log_evidence(qE,qC,pE,pC,rE,rC)
% FORMAT [F,sE,sC] = spm_log_evidence(qE,qC,pE,pC,priorfun,varargin)
% FORMAT [F,sE,sC] = spm_log_evidence(qE,qC,pE,pC)
%
% qE,qC    - posterior expectation and covariance of full model
% pE,pC    - prior expectation and covariance of full model
% rE,rC    - prior expectation and covariance of reduced model
% or 
% priorfun - inline function that returns prior moments
%            {rE rC} = priorfun(varargin{:})
%
% or (if omitted) rE = 0 and rC = 0;
%
% F        - reduced log-evidence: ln p(y|reduced model) - ln p(y|full model)
% [sE,sC]  - posterior expectation and covariance of reduced model
%
%--------------------------------------------------------------------------
% This routine assumed the reduced model is nested within a full model and
% that the posteriors (and priors) are Gaussian. Nested here means that the
% prior precision of the reduced model, minus the prior precision of the
% full model is positive definite. We additionally assume that the prior
% means are unchanged. The two input argument formats are for use with
% spm_argmax.
%__________________________________________________________________________
% Copyright (C) 2005 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_log_evidence.m 4261 2011-03-24 16:39:42Z karl $
 
% Compute reduced log-evidence
%==========================================================================
 
% check to see if priors are specified by a function
%--------------------------------------------------------------------------
qE = varargin{1};
qC = varargin{2};
pE = varargin{3};
pC = varargin{4};
try
    priors = varargin{5}(varargin{6:end});
    rE     = priors{1};
    rC     = priors{2};
catch
    try
        rE = varargin{5};
        rC = varargin{6};
    catch
        n  = size(qC,1);
        rE = sparse(n,1);
        rC = sparse(n,n);
    end
end
 
% reduced subspace 
%--------------------------------------------------------------------------
qE  = spm_vec(qE);
pE  = spm_vec(pE);
rE  = spm_vec(rE);
 
if nargout < 2
    dE  = pE - rE;
    dC  = pC - rC;
    k   = find(dE | any(dC,2));
    if ~isempty(k)
        qE  = qE(k);
        pE  = pE(k);
        rE  = rE(k);
        qC  = qC(k,k);
        pC  = pC(k,k);
        rC  = rC(k,k);
    end
end

% remove redundant dimensions
%--------------------------------------------------------------------------
i     = find(diag(pC));
qC    = qC(i,i);
pC    = pC(i,i);
rC    = rC(i,i);

% preliminaries 
%--------------------------------------------------------------------------
qP    = spm_inv(qC);
pP    = spm_inv(pC);
rP    = spm_inv(rC);
sP    = qP + rP - pP;
sC    = spm_inv(sP);
sE    = pE;
sE(i) = qP*qE(i) + rP*rE(i) - pP*pE(i); 

% log-evidence
%--------------------------------------------------------------------------
F     = spm_logdet(rP*qP*sC*pC) ...
      - (qE(i)'*qP*qE(i) + rE(i)'*rP*rE(i) - pE(i)'*pP*pE(i) - sE(i)'*sC*sE(i));
F     = F/2;
 
% restore full conditional density
%--------------------------------------------------------------------------
if nargout > 1
    pE(i)   = sC*sE(i);
    pC(i,i) = sC;
    sE      = spm_unvec(pE,varargin{1});
    sC      = pC;
end
