function [ p,Cp,Ce] = spm_nlsi_GN(M,U,Y)
% Bayesian Parameter estimation using the Gauss-Newton method/EM algorithm
% FORMAT [Ep,Cp,Ce] = spm_nlsi_GN(M,U,Y)
%
% Dynamical MIMO models
%___________________________________________________________________________
% M.f  - f(x,u,P)
% M.g  - g(x,u,P)
%	x - states variables
%	u - inputs or causes
%	P - free parameters
% M.pE - prior expectation  - E{P}
% M.pC - prior covariance   - Cov{P}
%
%
% U.u  - inputs
% U.dt - sampline interval
%
% Y.y  - outputs
% Y.X0 - Confounds or null space
% Y.dt - sampling interval for outputs
% Y.Ce - error covariance contraints
%
%
% Parameter estimates
%---------------------------------------------------------------------------
% Ep  - (p x 1)        	conditional expectation  E{P|y}
% Cp  - (p x p)        	conditional covariance   Cov{P|y}
% Ce  - (v x v)        	[Re]ML estimate of       Cov{e}
%
%___________________________________________________________________________
% Returns the moments of the posterior p.d.f. of the parameters of a 
% dynamical MIMO input-state-ouput model under Gaussian assumptions
%
%  		 	dx/dt = f(x,u,P)
%   		 	y     = g(x,u,P) + e
%
% A static nonlinear observation model with fixed input or causes u
% obtains x = []. i.e.
%
%   		 	y     = g(u,P) + e
%
% Priors on the free parameters P are specified in terms of expectation pE
% and covariance pC. The estimation uses a Gauss-Newton method with MAP
% point estimators at each iteration.  The covariance of e is a maximum
% likelihood estimator based on the residuals (ReML estimators).
% This corresponds to a Gauss-Newton ascent on the conditional probabilty
% p{P|y}
%
% SEE NOTES AT THE END OF THIS SCRIPT FOT EXAMPLES
%
%---------------------------------------------------------------------------
% %W% Karl Friston %E%

% Covariance constraints on observation error (if not specified)
%---------------------------------------------------------------------------
y      = Y.y;
[v m]  = size(y);
if isfield(Y,'Ce')
	Ce = Y.Ce;
else
	Ce = spm_Ce(v*ones(1,m));
end

% Covariance constraints on priors
%---------------------------------------------------------------------------
pE     = M.pE;
pC     = M.pC;
if iscell(pC)
	pC = pC{:};
	EB = 1;
else
	EB = 0;
end

% confounds (if specified)
%---------------------------------------------------------------------------
if isfield(Y,'X0')
	Ju = kron(speye(m,m),Y.X0);
else
	Ju = [];
end

% treat confounds Ju as fixed effects
%---------------------------------------------------------------------------
u      = size(Ju,2);
uE     = sparse(u,1);
uC     = speye(u,u)*1e+8;

% SVD of prior covariances
%---------------------------------------------------------------------------
Vp     = spm_svd(pC,1e-16);
ip     = [1:size(Vp,2)];


% If EB: i.e. prior covariance hyperparameter estimation
%---------------------------------------------------------------------------
pC     = Vp'*pC*Vp;
if EB
	P{1}.C = Ce;
	P{2}.C = {blkdiag(0*pC, uC), blkdiag(pC, 0*uC)};
	P{3}.C = 1e-8;
	P{3}.X = 1;
else
	P{1}.C = Ce;
	P{2}.C = blkdiag(pC, uC);
end

% Gauss-Newton search 
%===========================================================================
p      = pE;
pi     = pE;
dp     = pE;
dv     = 1e-6;
for  j = 1:32

	% y = f(p) - for new expansion point (p) in parameter space 
	%-------------------------------------------------------------------
	fp     = spm_int(p,M,U,v);

	% compute partial derivatives [Jp] dy(t)/dp*Vp {p = parameters}
	%-------------------------------------------------------------------
	for  i = 1:size(Vp,2)

		pi(:)   = p(:) + Vp(:,i)*dv;
		dfp     = spm_int(pi,M,U,v) - fp;
		Jp(:,i) = dfp(:)/dv;
	end

	% Bayesian [conditional] estimator of new expansion point E{p|y}
	%-------------------------------------------------------------------
	P{1}.X = [Jp Ju];
	P{2}.X = [Vp'*( pE(:) - p(:));uE];
	[C P]  = spm_PEB(y(:) - fp(:),P );


	% update - project conditional esitmates onto parameter space
	%-------------------------------------------------------------------
	dp(:)  = Vp*C{2}.E(ip);

	% update - ensuring the system is dissipative
	%-------------------------------------------------------------------
	for  i = 1:8
		A    = spm_bi_reduce(M,p + dp);
		s    = max(real(eig(full(A))));
		if s > 0
			dp = dp/2;
		else
			break
		end
	end
	p      = p + dp;


	% convergence
	%-------------------------------------------------------------------
	w      = dp(:)'*dp(:);
	fprintf('%-30s: %i %20s%e\n','GNS Iteration',j,'...',full(w));
	if w < 1e-6, break, end

	% graphics
	%-------------------------------------------------------------------
	if length(dbstack) < 3
		bar(p)
		xlabel('parameter')
		ylabel('conditional expectation')
		title(sprintf('%s: %i','GNS Iteration',j))
		grid on
		drawnow
	end

end

% outputs
%---------------------------------------------------------------------------
Ep     = p;
Cp     = Vp*C{2}.C(ip,ip)*Vp';
Ce     = C{1}.M;










return

% NOTES ON USE - DYNAMIC SYSTEMS
%===========================================================================
% Consider the dynamic system (c.f. spm_nlsi)
%
%              dx/dt  = 1./(1 + exp(-P*x)) + u
%                y    = x + e
%
% Specify a model structure:
%---------------------------------------------------------------------------
M.f  = inline('1./(1 + exp(-P*x)) + [u; 0]','x','u','P');
M.g  = inline('x','x','u','P');
M.pE = [-1 .3;.5 -1];			% Prior expectation of parameters
M.pC = speye(4,4);			% Prior covariance for parameters
M.x  = zeros(2,1)			% intial state x(0)
M.m  = 1;				% number of inputs
M.n  = 2;				% number of states
M.l  = 2;				% number of outputs

% create inputs
%---------------------------------------------------------------------------
U.name = 'input'
U.u    = randn(128,M.m);
U.dt   = 1;

% and outputs
%---------------------------------------------------------------------------
Y.name = 'response';
y      = spm_int(M.pE,M,U,64);
Y.y    = y + randn(size(y))/32;
Y.dt   = U.dt*length(U.u)/length(Y.y);

% estimate
%---------------------------------------------------------------------------
[Ep,Cp,Ce] = spm_nlsi_GN(M,U,Y);


% STATIC SYSTEMS
%===========================================================================
% Consider the nonlinear static system where we want to estimate P
%
%                y    = 1./(1 + exp(-P*u)) + e
%
% Note that the inputs are explanatory variables (c.f. regressors
% in a design matrix)
clear % dynamic model and specify a model structure
%---------------------------------------------------------------------------

M.g  = inline('1./(1 + exp(-P*u(:)))','x','u','P');
M.pE = [-1 .3;.5 -1];			% Prior expectation of parameters
M.pC = speye(4,4);			% Prior covariance for parameters
M.m  = 2;				% number of inputs
M.l  = 2;				% number of outputs

% create inputs
%---------------------------------------------------------------------------
u    = randn(128,M.m);

% and outputs with observation error
%---------------------------------------------------------------------------
y    = spm_int(M.pE,M,u);
Y.y  = y + randn(size(y))/32;

% estimate
%---------------------------------------------------------------------------
[Ep,Cp,Ce] = spm_nlsi_GN(M,u,Y);
