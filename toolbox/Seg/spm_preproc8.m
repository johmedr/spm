function results = spm_preproc8(obj)
% Combined Segmentation and Spatial Normalisation
%
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% John Ashburner
% $Id: spm_preproc8.m 1301 2008-04-03 13:21:44Z john $

Affine    = obj.Affine;
tpm       = obj.tpm;
V         = obj.image;
M         = tpm.M\Affine*V(1).mat;
d0        = V(1).dim(1:3);
vx        = sqrt(sum(V(1).mat(1:3,1:3).^2));
sk        = max([1 1 1],round(obj.samp*[1 1 1]./vx));
[x0,y0,o] = ndgrid(1:sk(1):d0(1),1:sk(2):d0(2),1);
z0        = 1:sk(3):d0(3);
tiny      = eps;
MT        = [sk(1) 0 0 (1-sk(1));0 sk(2) 0 (1-sk(2)); 0 0 sk(3) (1-sk(3));0 0 0 1];

lkp       = obj.lkp;
K         = numel(lkp);
Kb        = max(lkp);

kron = inline('spm_krutil(a,b)','a','b');

% Fudge Factor - to (approximately) account for
% non-independence of voxels
ff     = obj.fudge;
ff     = max(1,ff^3/prod(sk)/abs(det(V(1).mat(1:3,1:3))));

% Initialise Deformation
param  = [2 sk.*vx ff*obj.reg*[1 1e-4 0]];
lam    = [0 0 0 0 0 0.01 1e-4];
scal   = sk;
d      = [size(x0) length(z0)];
if isfield(obj,'Twarp'),
    Twarp = obj.Twarp;
    llr   = -0.5*sum(sum(sum(sum(Twarp.*optimNn('vel2mom',Twarp,param,scal)))));
else
    Twarp = zeros([d,3],'single');
    llr   = 0;
end


% GAUSSIAN REGULARISATION for bias correction
%-----------------------------------------------------------------------
N      = numel(V);
for n=1:N,
    fwhm    = obj.biasfwhm(n);
    biasreg = obj.biasreg(n);
    vx      = sqrt(sum(V(n).mat(1:3,1:3).^2));
    d0      = V(n).dim;
    sd      = vx(1)*d0(1)/fwhm; d3(1) = ceil(sd*2); krn_x   = exp(-(0:(d3(1)-1)).^2/sd.^2)/sqrt(vx(1));
    sd      = vx(2)*d0(2)/fwhm; d3(2) = ceil(sd*2); krn_y   = exp(-(0:(d3(2)-1)).^2/sd.^2)/sqrt(vx(2));
    sd      = vx(3)*d0(3)/fwhm; d3(3) = ceil(sd*2); krn_z   = exp(-(0:(d3(3)-1)).^2/sd.^2)/sqrt(vx(3));
    Cbias   = kron(krn_z,kron(krn_y,krn_x)).^(-2)*biasreg*ff;
    bias(n).C   = sparse(1:length(Cbias),1:length(Cbias),Cbias,length(Cbias),length(Cbias));
    bias(n).B3  = spm_dctmtx(d0(3),d3(3),z0);
    bias(n).B2  = spm_dctmtx(d0(2),d3(2),y0(1,:)');
    bias(n).B1  = spm_dctmtx(d0(1),d3(1),x0(:,1));
    if isfield(obj,'Tbias') & ~isempty(obj.Tbias{n}),
        bias(n).T = obj.Tbias{n};
    else
        bias(n).T   = zeros(d3);
    end
end


ll     = -Inf;
llr    = 0;
llrb   = 0;
tol1   = 1e-4; % Stopping criterion.  For more accuracy, use a smaller value


% Initial parameterisation of Gaussians
rand('state',0); % give same results each time
if isfield(obj,'mg'), mg = obj.mg; else mg = ones(K,1)/K;  end
if isfield(obj,'mn'), mn = obj.mn; else mn = ones(N,K);    end
if isfield(obj,'vr'), vr = obj.vr; else vr = zeros(N,N,K); end
vr0 = zeros(N,N);
for n=1:N,
   %mnv =  Inf; % Note dodgy variable name
    mxv = -Inf;
    for z=1:length(z0),
        tmp = spm_sample_vol(V(n),x0,y0,o*z0(z),0);
        tmp = tmp(isfinite(tmp) & tmp~=0);
       %mnv = min(min(tmp),mnv);
        mxv = max(max(tmp),mxv);
    end;
    for k1=1:Kb,
        kk = sum(lkp==k1);
        if ~isfield(obj,'mn'), mn(n,lkp==k1) = rand(1,kk)*mxv; end
        if ~isfield(obj,'mg'), mg(lkp==k1)   = 1/kk;          end
    end;
    if ~isfield(obj,'vr'),
        for k=1:K,
            vr(n,n,k) = (mxv/2)^2;
        end
    end

    % Add a little something to the covariance estimates
    % in order to assure stability
    if spm_type(V(n).dt(1),'intt'),
        vr0(n,n) = 0.083*V(n).pinfo(1,1);
    else
        vr0(n,n) = mxv^2*eps*10000;
    end
end

if isfield(obj,'msk') && ~isempty(obj.msk),
    VM = spm_vol(obj.msk);
    if sum(sum((VM.mat-V(1).mat).^2)) > 1e-6 || any(VM.dim(1:3) ~= V(1).dim(1:3)),
        error('Mask must have the same dimensions and orientation as the image.');
    end;
end;

% Load the data
nm      = 0;
for z=1:length(z0),
   %x1  = M(1,1)*x0 + M(1,2)*y0 + (M(1,3)*z0(z) + M(1,4));
   %y1  = M(2,1)*x0 + M(2,2)*y0 + (M(2,3)*z0(z) + M(2,4));
    z1  = M(3,1)*x0 + M(3,2)*y0 + (M(3,3)*z0(z) + M(3,4));
    e   = sqrt(sum(tpm.M(1:3,1:3).^2));
    e   = 5./e; % mm from edge of TPM
    buf(z).msk = z1>e(3);

    fz = cell(1,N);
    for n=1:N,
        fz{n}      = spm_sample_vol(V(n),x0,y0,o*z0(z),0);
        buf(z).msk = buf(z).msk & isfinite(fz{n}) & (fz{n}~=0);
    end

    if isfield(obj,'msk') && ~isempty(obj.msk),
        msk        = spm_sample_vol(VM,x0,y0,o*z0(z),0);
        buf(z).msk = buf(z).msk & msk;
    end;
    buf(z).nm  = sum(buf(z).msk(:));
    nm         = nm + buf(z).nm;
    for n=1:N,
        buf(z).f{n}  = single(fz{n}(buf(z).msk));
    end
    buf(z).dat = zeros([buf(z).nm,Kb],'single');
end;


% Initial Bias Field
llrb = 0;
for n=1:N,
    B1 = bias(n).B1;
    B2 = bias(n).B2;
    B3 = bias(n).B3;
    C  = bias(n).C;
    T  = bias(n).T;
    for z=1:numel(z0),
        bf           = transf(B1,B2,B3(z,:),T);
        tmp          = bf(buf(z).msk);
        llrb         = llrb + sum(tmp);
        buf(z).bf{n} = single(exp(tmp));
    end
    llrb      = llrb - 0.5*T(:)'*C*T(:);
    clear B1 B2 B3 T C
end


spm_chi2_plot('Init','Initialising','Log-likelihood','Iteration');
for iter=1:20,

    % Load the warped prior probability images into the buffer
    %------------------------------------------------------------
    for z=1:length(z0),
        if ~buf(z).nm, continue; end;
        [x1,y1,z1] = defs(Twarp,z,x0,y0,z0,M,buf(z).msk);
        b          = spm_sample_priors8(tpm,x1,y1,z1);
        for k1=1:Kb,
            buf(z).dat(:,k1) = single(b{k1});
        end;
    end;

    for iter1=1:10,

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Estimate cluster parameters
        %------------------------------------------------------------
        for subit=1:10,
            oll  = ll;
            mom0 = zeros(K,1)+tiny;
            mom1 = zeros(N,K);
            mom2 = zeros(N,N,K);
            ll   = llr+llrb;
            for z=1:length(z0),
                if ~buf(z).nm, continue; end;
                q = likelihoods(buf(z).f,buf(z).bf,mg,mn,vr);
                for k1=1:Kb,
                    b = buf(z).dat(:,k1);
                    for k=find(lkp==k1),
                        q(:,k) = q(:,k).*b;
                    end
                    clear b
                end
                sq = sum(q,2)+tiny;
                ll = ll + sum(log(sq));
                cr = zeros(size(q,1),N);
                for n=1:N,
                    cr(:,n)  = double(buf(z).f{n}.*buf(z).bf{n});
                end
                for k=1:K, % Moments
                    q(:,k)      = q(:,k)./sq;
                    mom0(k)     = mom0(k)     + sum(q(:,k));
                    mom1(:,k)   = mom1(:,k)   + (q(:,k)'*cr)';
                    mom2(:,:,k) = mom2(:,:,k) + (repmat(q(:,k),1,N).*cr)'*cr;
                end
                clear cr
            end;

            % Mixing proportions, Means and Variances
            for k=1:K,
                mg(k)     = (mom0(k)+eps)/(sum(mom0(lkp==lkp(k)))+eps);
                mn(:,k)   = mom1(:,k)/(mom0(k)+eps);
                vr(:,:,k) = (mom2(:,:,k) - mom0(k)*mn(:,k)*mn(:,k)')/(mom0(k)+eps) + vr0;
            end;

            if subit>1 || iter>1,
                spm_chi2_plot('Set',ll);
            end;
            if subit == 1,
                ooll = ll;
            elseif (ll-oll)<tol1*nm,
                % Improvement is small, so go to next step
                break;
            end;
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Estimate bias
        % Note that for multi-spectral data, the covariances among
        % channels are not computed as part of the second derivatives.
        % The aim is to save memory, and maybe make the computations
        % faster.
        %------------------------------------------------------------
        for subit=1:10,
            % Compute objective function and its 1st and second derivatives
            for n=1:N,
                d3 = numel(bias(n).T);
                if d3>0,
                    bias(n).Alpha = zeros(d3,d3); % Second derivatives
                    bias(n).Beta  = zeros(d3,1);  % First derivatives
                end
            end
            oll   = ll;
            ll    = llr+llrb;
            for z=1:length(z0),
                if ~buf(z).nm, continue; end;
                q = likelihoods(buf(z).f,buf(z).bf,mg,mn,vr);
                for k1=1:Kb,
                    b = buf(z).dat(:,k1);
                    for k=find(lkp==k1),
                        q(:,k) = q(:,k).*b;
                    end
                    clear b
                end
                sq = sum(q,2)+tiny;
                ll = ll + sum(log(sq));

                for n=1:N,
                    if ~isempty(bias(n).T),
                        cr = double(buf(z).f{n}.*buf(z).bf{n});
                        w1 = zeros(buf(z).nm,1);
                        w2 = zeros(buf(z).nm,1);
                        for k=1:K,
                            tmp = q(:,k)./sq/vr(n,n,k); % Only the diagonal of vr is used
                            w1  = w1 + tmp.*(mn(n,k) - cr);
                            w2  = w2 + tmp;
                        end
                        wt1   = zeros(d(1:2));
                        wt1(buf(z).msk) = 1 + cr.*w1;
                        wt2   = zeros(d(1:2));
                       %wt2(buf(z).msk) = cr.*cr.*w2 - cr.*w1;
                        wt2(buf(z).msk) = cr.*cr.*w2 + 1;
                        b3    = bias(n).B3(z,:)';
                        bias(n).Beta  = bias(n).Beta  + kron(b3,spm_krutil(wt1,bias(n).B1,bias(n).B2,0));
                        bias(n).Alpha = bias(n).Alpha + kron(b3*b3',spm_krutil(wt2,bias(n).B1,bias(n).B2,1));
                        clear w1 w2 wt1 wt2 b3
                    end
                end
            end
            % Accept new solutions
            spm_chi2_plot('Set',ll);
            llrb = 0;
            for n=1:N,
                if ~isempty(bias(n).T),
                    d3        = size(bias(n).T);
                    Alpha     = bias(n).Alpha; bias(n).Alpha = [];
                    Beta      = bias(n).Beta;  bias(n).Beta  = [];
                    C         = bias(n).C;
                    T         = bias(n).T;
                    R         = eye(size(Alpha))*0.01;
                    bias(n).T = T - reshape((Alpha + C + R)\(C*T(:)-Beta),d3);
                    llrb      = llrb - 0.5*bias(n).T(:)'*C*bias(n).T(:);
                    for z=1:length(z0),
                        if ~buf(z).nm, continue; end;
                        bf           = transf(bias(n).B1,bias(n).B2,bias(n).B3(z,:),bias(n).T);
                        tmp          = bf(buf(z).msk);
                        llrb         = llrb + sum(tmp);
                        buf(z).bf{n} = single(exp(tmp));
                    end
                end
            end
fprintf('* %d %g %g\n', subit, llrb,ll);
            if subit > 1 && ~((ll-oll)>tol1*nm),
                % Improvement is only small, so go to next step
                break;
            end
        end

        if iter==1 && iter1==1,
            % Most of the log-likelihood improvements are in the first iteration.
            % Show only improvements after this, as they are more clearly visible.
            spm_chi2_plot('Clear');
            spm_chi2_plot('Init','Processing','Log-likelihood','Iteration');
        end

        if ~((ll-ooll)>tol1*nm), disp('XXX'); break; end
    end

 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Estimate deformations
    %------------------------------------------------------------
    ll  = llr+llrb;
    for z=1:length(z0),
        if ~buf(z).nm, continue; end;
        cr = cell(1,N);
        for n=1:N,
            cr{n} = double(buf(z).f{n}.*buf(z).bf{n});
        end
        q   =  zeros(buf(z).nm,Kb);
        qt  = likelihoods(buf(z).f,buf(z).bf,mg,mn,vr);
        for k1=1:Kb,
            for k=find(lkp==k1),
                q(:,k1) = q(:,k1) + qt(:,k);
            end
            b = double(buf(z).dat(:,k1));
            buf(z).dat(:,k1) = single(q(:,k1));
            q(:,k1)          = q(:,k1).*b;
        end
        ll = ll + sum(log(sum(q,2)));
    end;
    fprintf('%d\t%d\t%g\n', iter, 0, ll);
    oll = ll;

    for subit=1:3,
        Alpha  = zeros([size(x0),numel(z0),6],'single');
        Beta   = zeros([size(x0),numel(z0),3],'single');
        for z=1:length(z0),
            if ~buf(z).nm, continue; end;
            [x1,y1,z1]      = defs(Twarp,z,x0,y0,z0,M,buf(z).msk);
            [b,db1,db2,db3] = spm_sample_priors8(tpm,x1,y1,z1);
            clear x1 y1 z1

            p   = zeros(buf(z).nm,1)+tiny;
            dp1 = zeros(buf(z).nm,1);
            dp2 = zeros(buf(z).nm,1);
            dp3 = zeros(buf(z).nm,1);
            for k1=1:Kb,
                pp  = double(buf(z).dat(:,k1));
                p   = p   + pp.*b{k1};
                dp1 = dp1 + pp.*(M(1,1)*db1{k1} + M(2,1)*db2{k1} + M(3,1)*db3{k1});
                dp2 = dp2 + pp.*(M(1,2)*db1{k1} + M(2,2)*db2{k1} + M(3,2)*db3{k1});
                dp3 = dp3 + pp.*(M(1,3)*db1{k1} + M(2,3)*db2{k1} + M(3,3)*db3{k1});
            end;
            clear b db1 db2 db3

            tmp             = zeros(d(1:2));
            tmp(buf(z).msk) = dp1./p; dp1 = tmp;
            tmp(buf(z).msk) = dp2./p; dp2 = tmp;
            tmp(buf(z).msk) = dp3./p; dp3 = tmp;

            Beta(:,:,z,1)   = -dp1;
            Beta(:,:,z,2)   = -dp2;
            Beta(:,:,z,3)   = -dp3;

            Alpha(:,:,z,1)  = dp1.*dp1;
            Alpha(:,:,z,2)  = dp2.*dp2;
            Alpha(:,:,z,3)  = dp3.*dp3;
            Alpha(:,:,z,4)  = dp1.*dp2;
            Alpha(:,:,z,5)  = dp1.*dp3;
            Alpha(:,:,z,6)  = dp2.*dp3;
            clear tmp p dp1 dp2 dp3
        end;

        if ~isfield(obj,'Twarp')
            switch iter
            case 1,
                prm = [param(1:4) 8*param(5:6) param(7:end)];
            case 2,
                prm = [param(1:4) 4*param(5:6) param(7:end)];
            case 3,
                prm = [param(1:4) 2*param(5:6) param(7:end)];
            otherwise
                prm = [param(1:4)   param(5:6) param(7:end)];
            end
        else
            prm = [param(1:4)   param(5:6) param(7:end)];
        end

        Beta   = Beta  + optimNn('vel2mom',Twarp,prm,scal);

        for lmreg=1:6,
            Twarp1 = Twarp - optimNn('fmg',Alpha,Beta,[prm+lam 1 1],scal);
            llr1   = -0.5*sum(sum(sum(sum(Twarp1.*optimNn('vel2mom',Twarp1,prm,scal)))));
            ll1    = llr1+llrb;
            for z=1:length(z0),
                if ~buf(z).nm, continue; end;
                [x1,y1,z1] = defs(Twarp1,z,x0,y0,z0,M,buf(z).msk);
                b          = spm_sample_priors8(tpm,x1,y1,z1);
                clear x1 y1 z1

                sq = zeros(buf(z).nm,1) + tiny;
                for k1=1:Kb,
                    sq = sq + double(buf(z).dat(:,k1)).*b{k1};
                end;
                clear b
                ll1 = ll1 + sum(log(sq));
                clear sq
            end;
            fprintf('%d\t%d\t%g\n', iter, subit, ll1);
            if ll1<ll,
                lam   = lam*8;
            else
                spm_chi2_plot('Set',ll1);
                lam   = lam*0.5;
                ll    = ll1;
                llr   = llr1;
                Twarp = Twarp1;
                break
            end
        end
        clear Alpha Beta

        if ~((ll-oll)>tol1*nm),
            break
        end
        oll = ll;
    end

    if iter>4 && ~((ll-ooll)>tol1*nm),
        break
    end
end;
% spm_chi2_plot('Clear');

results.image  = obj.image;
results.tpm    = tpm.V;
results.Affine = Affine;
results.lkp    = lkp;
results.MT     = MT;
results.Twarp  = Twarp;
results.Tbias  = {bias(:).T};
results.mg     = mg;
results.mn     = mn;
results.vr     = vr;
results.ll     = ll;
return;
%=======================================================================

%=======================================================================
function t = transf(B1,B2,B3,T)
if ~isempty(T),
    d2 = [size(T) 1];
    t1 = reshape(reshape(T, d2(1)*d2(2),d2(3))*B3', d2(1), d2(2));
    t  = B1*t1*B2';
else
    t  = zeros(size(B1,1),size(B2,1));
end;
return;
%=======================================================================

%=======================================================================
function [x1,y1,z1] = defs(Twarp,z,x0,y0,z0,M,msk)
x1a = x0    + double(Twarp(:,:,z,1));
y1a = y0    + double(Twarp(:,:,z,2));
z1a = z0(z) + double(Twarp(:,:,z,3));
if nargin>=7,
    x1a = x1a(msk);
    y1a = y1a(msk);
    z1a = z1a(msk);
end;
x1  = M(1,1)*x1a + M(1,2)*y1a + M(1,3)*z1a + M(1,4);
y1  = M(2,1)*x1a + M(2,2)*y1a + M(2,3)*z1a + M(2,4);
z1  = M(3,1)*x1a + M(3,2)*y1a + M(3,3)*z1a + M(3,4);
return;
%=======================================================================

%=======================================================================
function p = likelihoods(f,bf,mg,mn,vr)
K  = numel(mg);
N  = numel(f);
M  = numel(f{1});
cr = zeros(M,N);
for n=1:N,
    cr(:,n) = double(f{n}(:).*bf{n}(:));
end
p  = ones(numel(f{1}),K);
for k=1:K,
    amp    = mg(k)/sqrt((2*pi)^N * det(vr(:,:,k)));
    d      = cr - repmat(mn(:,k)',M,1);
    p(:,k) = amp * exp(-0.5* sum(d.*(d/vr(:,:,k)),2));
end
p = p + 1024*eps;
%=======================================================================

%=======================================================================

