function FEP_MB_demo
% This  routine illustrates a hierarchical decomposition of Markov blankets
% (of Markov blankets). It rests upon the dual operators of finding a
% partition (a Markov partition) and then using an adiabatic dimensional
% reduction (using the eigensolution of the Markov blanket). In brief, this
% means the states of particles at the next level become mixtures of the
% Markov blanket of particles at the level below.
%
% The ensuing hierarchical decomposition is illustrated in terms of
% Jacobian is and locations in a scathing space (evaluated using the graph
% Laplacian). This demonstration uses a fictive Jacobian that is created by
% hand.
%
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: FEP_MB_demo.m 7164 2017-09-07 13:46:00Z karl $

SOUP = 0;
if SOUP
    % default settings
    %----------------------------------------------------------------------
    rng('default')
    
    % Demo of synchronization manifold using coupled Lorenz attractors
    %======================================================================
    N    = 128;                         % number of (Lorenz) oscillators
    T    = 512;                         % number of time bins
    dt   = 1/32;                        % time interval
    
    % parameters
    %----------------------------------------------------------------------
    P.k  = 1 - exp(-rand(1,N)*4);       % variations in temporal scale
    P.d  = 1/8;                         % amplitude of random fluctuations
    
    % states
    %----------------------------------------------------------------------
    x.p  = randn(2,N)*4;                % microstates (position)
    x.v  = zeros(2,N);                  % microstates (velocity)
    x.q  = randn(3,N)/32;               % microstates (states)
    u    = zeros(1,T);                  % exogenous fluctuations
    
    
    % generate an dynamics from initial conditions
    %======================================================================
    spm_figure('GetWin','Markov blanket');clf, subplot(2,1,1)
    
    [Q,X,V,A,x] = spm_soup(x,u,P,T,dt,1);
    j           = (T - 32:T);
    J           = spm_soup(Q(:,:,j),X(:,:,j),V(:,:,j),P);
    A           = mean(J,3);
    
    mm          = spm_zeros(x);
    mm.q(3,:)   = 1;
    
    n     = [6 4 2 2];               % number of eigenvectors
    m     = [1 2 1 1];               % number of internal states
    jj    = cell(4,1);               % eligible internal states
    jj{1} = spm_vec(mm);             % eligible internal states
    
else
    
    % create an adjacency matrix or Jacobian based upon a lattice
    %======================================================================
    
    % within blanket coupling (intrinsic)
    %----------------------------------------------------------------------
    n     = 2;
    m     = 3;
    Jii   = spm_cat({[], eye(n,n),  spm_speye(n,m);
                     randn(n,n)/8, [], [];
                     [], spm_speye(m,n), (randn(m,m)/8 - eye(m,m))});
    
    
    % between blanket coupling (extrinsic)
    %----------------------------------------------------------------------
    Jij   = spm_cat({[], zeros(n,n),  zeros(n,m);
                     randn(n,n),  [], [];
                     [], zeros(m,n),  zeros(m,m)});
    
    
    % an ensemble of blankets
    %----------------------------------------------------------------------
    D     = 2;                      % distance for seperation
    N     = 8;                      % size of lattice
    [I,J] = ndgrid(1:N,1:N);        % locations
    for i = 1:numel(I)
        for j = 1:numel(J)
            d = sqrt( (I(i) - I(j))^2 + (J(i) - J(j))^2 );
            if i == j
                A{i,j} = Jii;
            elseif d < D
                A{i,j} = Jij;
            else
                A{i,j} = zeros(size(Jij));
            end
        end
    end
    
    n     = [4 4 2 2];               % number of eigenvectors
    m     = [3 2 1 1];               % number of internal states
    jj    = cell(4,1);               % eligible internal states
    
end

clear J
J{1}  = spm_cat(A);
z{1}  = num2cell(1:length(J{1}));


% hierarchal decomposition
%==========================================================================
N     = 3;                       % number of hierarchies
x     = {};                      % indices of states of partitions
u{1}  = [];
y{1}  = [];
for i = 1:N
    
    % Markov blanket partition
    %----------------------------------------------------------------------
    spm_figure('getwin',sprintf('Markov level %i',i));
    
    [x{i},u{i + 1}] = spm_Markov_blanket(J{i},z{i},m(i),u{i},y{i},jj{i});
    
    if i < N
        
        % dimension reduction (eliminating internal states)
        %------------------------------------------------------------------
        [J{i + 1},z{i + 1},y{i + 1}] = spm_A_reduce(J{i},x{i},n(i));
        
    end
end

return

% subroutines
%==========================================================================

% Markov blanket - parents, children, and parents of children
%==========================================================================
function [J,z,y] = spm_A_reduce(J,x,N)
% reduction of Markovian partition
% J  - Jacobian (x)
% x  - {3 x N} indices of Markovian partition
% N  - number of eigenvectors to retain [default: 2]
%
% J  - Jacobian (z)
% z  - {1 x n} indices of partition for the next level
% y  - {1 x N} indices of partition for the current level
%__________________________________________________________________________

% preliminaries
%--------------------------------------------------------------------------
nx    = size(x,2);                % number of partitions
if nargin < 3
    N = 2;                        % number of generalised eigenvectors
end

% reduction
%----------------------------------------------------------------------
for i = 1:nx
    y{i}  = spm_vec(x(1:2,i));
    Jii   = full(J(y{i},y{i}));
    n(i)  = min(N,size(Jii,1));
    [e,s] = eig(Jii);
    [d,j] = sort(real(diag(s)),'descend');
    v{i}  = e(:,j(1:n(i)));
    u{i}  = pinv(v{i});
    
end
for i = 1:nx
    for j = 1:nx
        Jij    = full(J(spm_vec(x(1:2,i)),spm_vec(x(1:2,j))));
        A{i,j} = u{i}*Jij*v{j};
    end
    z{i}   = sum(n(1:(i - 1))) + (1:n(i));
end
J     = spm_cat(A);


% Markovian partition
%==========================================================================
function [x,u,y] = spm_Markov_blanket(J,z,m,uu,zz,mj)
% Markovian partition
% J  - Jacobian
% z  - {1 x N} indices of partition
% m  - number of internal states [default: 3]
%
% uu - embedding space 
% mj - candidate internal states [optional]
%
% x  - {3 x N} indices of states of partitions
%     x{1,j} - active states of j-th partition
%     x{2,j} - sensory states of j-th partition
%     x{3,j} - internal states of j-th partition
%
% y  - {3 x N} indices of partition
%     y{1,j} - active states of j-th partition
%     y{2,j} - sensory states of j-th partition
%     y{3,j} - internal states of j-th partition
%__________________________________________________________________________

% preliminaries
%--------------------------------------------------------------------------
nz    = length(z);                % number of partitions
if nargin < 3
    m = 3;                        % maximum size of internal states
end
if nargin < 4
   uu = {};                       % embedding space of lower-level
end
if nargin < 5
   mj = ones(nz,1);               % eligible internal states
end
if isempty(mj)
   mj = ones(nz,1);               % eligible internal states
end


% Adjacency matrix (over z)
%--------------------------------------------------------------------------
for i = 1:nz
    for j = 1:nz
        Lij    = J(z{i},z{j});
        if any(any(Lij))
            L(i,j) = abs(norm(full(Lij)) > exp(-16));
        else
            L(i,j) = 0;
        end
    end
end
L     = double(L);

% internal states (defined by graph Laplacian)
%--------------------------------------------------------------------------
G     = L - diag(diag(L));
G     = G - diag(sum(G));
G     = expm(G);

% get principal dimensions of scaling space (X)
%--------------------------------------------------------------------------
GRAPHICS = 1;
if GRAPHICS
    [u,v] = eig(G,'nobalance');
    [v,j] = sort(real(diag(v)),'descend');
    u     = u(:,j);
    nj    = min(32,size(u,2));
    v     = v(1:nj);
    for i = 1:nj
        [p,h] = hist(real(u(:,i)),16);
        dh    = h(2) - h(1);
        p     = p(:)/sum(p)/dh;
        v(i)  = log(v(i)) - p'*log(p + exp(-16))*dh;
    end
    [v,j] = sort(real(v),'descend');
    u     = real(u(:,j));
end

% get Markov blanket and divide into sensory and active states
%--------------------------------------------------------------------------
B     = L + L' + L'*L;
B     = B - diag(diag(B));
nn    = zeros(nz,1);

% recursive partition
%--------------------------------------------------------------------------
for i = 1:128
    
    % internal states (defined by graph Laplacian)
    %----------------------------------------------------------------------
    j = ~(B*nn) & ~nn & mj;
    if any(j)
        
        % find densely coupled internal states (using the graph Laplacian)
        %------------------------------------------------------------------
        [g,j] = max(diag(G).*j);
        if m > 1
            g     = G(:,j);
            g(j)  = -Inf;
            [g,k] = sort(g,'descend');
            try
                j = [j; k(1:m - 1)];
            end
        end

        jj    = sparse(j,1,1,size(L,1),1);              % internal states
        bb    = B*jj & ~jj & ~nn;                       % Markov blanket
        ee    = ~bb & ~jj;                              % external states
        b     = find(bb);
        e     = find(ee);
        s     = b(find( any(L(b,e),2)));
        a     = b(find(~any(L(b,e),2)));
        
        % partition
        %------------------------------------------------------------------
        x{1,i} = spm_cat(z(a));
        x{2,i} = spm_cat(z(s));
        x{3,i} = spm_cat(z(j));
        
        % states accounted for (nn)
        %------------------------------------------------------------------
        nn   = nn | bb | jj;
        
    else
        
        % no internal states - find active states (not influenced by e)
        %------------------------------------------------------------------
        j = ~any(L(~nn,nn),2);
        if any(j)
            
            % sensory states connected with active states
            %--------------------------------------------------------------
            a  = find(~nn);
            a  = a(find(j,1));
            aa = sparse(a,1,1,size(L,1),1);
            ss = (L*aa | L'*aa) & ~aa & ~nn;
            a  = find(aa);
            s  = find(ss);
            j  = [];
            
            % partition
            %--------------------------------------------------------------
            x{1,i} = spm_cat(z(a));
            x{2,i} = spm_cat(z(s));
            x{3,i} = [];
            
            % states accounted for (nn)
            %--------------------------------------------------------------
            nn   = nn | aa | ss;
            
        elseif any(~nn)
            
            % sensory states connected with sensory states
            %--------------------------------------------------------------
            s  = find(~nn);
            ss = sparse(s(1),1,1,nz,1);
            ss = ss | B*ss & ~nn;
            s  = find(ss);
            a  = [];
            j  = [];
            
            % partition
            %--------------------------------------------------------------
            x{1,i} = [];
            x{2,i} = spm_cat(z(s));
            x{3,i} = [];
            
            % states accounted for (nn)
            %--------------------------------------------------------------
            nn   = nn | ss;
        end
    end
    
    % indices for the i-th particle
    %----------------------------------------------------------------------
    y{1,i} = a;
    y{2,i} = s;
    y{3,i} = j;
    
    % plot
    %----------------------------------------------------------------------
    if all(nn)
        if GRAPHICS,clf
            
            % colours for different politicians
            %--------------------------------------------------------------
            nx    = size(x,2);
            msz   = fix(16 + 64/nx);
            for k = 1:nx
                bol{k} = spm_softmax(log(rand(3,1))*2);
                col{k} = bol{k}*(1 - 1/2) + ones(3,1)/2;
            end
            
            % plot different states
            %--------------------------------------------------------------
            subplot(3,2,4)
            for k = 1:nx
                plot(u(y{1,k},1),u(y{1,k},2),'.r','MarkerSize',msz), hold on
                plot(u(y{2,k},1),u(y{2,k},2),'.m','MarkerSize',msz), hold on
                plot(u(y{3,k},1),u(y{3,k},2),'.b','MarkerSize',msz), hold on
            end
            axis square
            title(sprintf('Markov partition [%i particles]',nx),'Fontsize',16)
            
            % plot different states (in lower embedding dimensions)
            %--------------------------------------------------------------
            if ~isempty(uu)
                subplot(3,2,1)
                for k = 1:nx
                    plot(uu(x{1,k},1),uu(x{1,k},2),'.','color',bol{k},'MarkerSize',msz), hold on
                    plot(uu(x{2,k},1),uu(x{2,k},2),'.','color',bol{k},'MarkerSize',msz), hold on
                    plot(uu(x{3,k},1),uu(x{3,k},2),'.','color',col{k},'MarkerSize',msz), hold on
                end
                axis square
                title('Partition','Fontsize',16)
            end
            
            % plot different states (in three embedding dimensions)
            %--------------------------------------------------------------
            subplot(3,2,2)
            for k = 1:nx
                plot3(u(y{1,k},1),u(y{1,k},2),u(y{1,k},3),'.r','MarkerSize',msz), hold on
                plot3(u(y{2,k},1),u(y{2,k},2),u(y{2,k},3),'.m','MarkerSize',msz), hold on
                plot3(u(y{3,k},1),u(y{3,k},2),u(y{3,k},3),'.b','MarkerSize',msz), hold on
            end
            axis square
            title('Embedding space','Fontsize',16)
            rotate3d(gca,'on')
            
            
            % plot different particles
            %--------------------------------------------------------------
            subplot(3,2,3)
            for k = 1:nx
                plot(u(y{1,k},1),u(y{1,k},2),'.','color',bol{k},'MarkerSize',msz), hold on
                plot(u(y{2,k},1),u(y{2,k},2),'.','color',bol{k},'MarkerSize',msz), hold on
                plot(u(y{3,k},1),u(y{3,k},2),'.','color',col{k},'MarkerSize',msz), hold on
            end
            axis square
            title(sprintf('Particles [%i n-states]',nz),'Fontsize',16)
            
            % Jacobian
            %--------------------------------------------------------------
            j = spm_vec(x');
            k = spm_vec(x );
            subplot(3,2,5),imagesc(log(abs(J(k,k)) + exp(-8))),axis square
            subplot(3,2,6),imagesc(log(abs(J(j,j)) + exp(-8))),axis square
            
            
            % Colors
            %--------------------------------------------------------------
            nj   = spm_length(x);
            msz  = fix(16 + 128/nj);
            j    = 1:nj;
            k    = spm_unvec(j,x')';
            j    = spm_unvec(j,x);
            subplot(3,2,5),hold on
            for q = 1:nx
                plot(j{1,q},ones(size(x{1,q})),'.','color',bol{q},   'MarkerSize',msz)
                plot(j{2,q},ones(size(x{2,q})),'.','color',bol{q},   'MarkerSize',msz)
                plot(j{3,q},ones(size(x{3,q})),'.','color',col{q},   'MarkerSize',msz)
                plot(j{1,q},zeros(size(x{1,q})) + nj,'.','color','r','MarkerSize',msz)
                plot(j{2,q},zeros(size(x{2,q})) + nj,'.','color','m','MarkerSize',msz)
                plot(j{3,q},zeros(size(x{3,q})) + nj,'.','color','b','MarkerSize',msz)
            end
            
            subplot(3,2,6),hold on
            for q = 1:nx
                plot(k{1,q},ones(size(x{1,q})),'.','color',bol{q},   'MarkerSize',msz)
                plot(k{2,q},ones(size(x{2,q})),'.','color',bol{q},   'MarkerSize',msz)
                plot(k{3,q},ones(size(x{3,q})),'.','color',col{q},   'MarkerSize',msz)
                plot(k{1,q},zeros(size(x{1,q})) + nj,'.','color','r','MarkerSize',msz)
                plot(k{2,q},zeros(size(x{2,q})) + nj,'.','color','m','MarkerSize',msz)
                plot(k{3,q},zeros(size(x{3,q})) + nj,'.','color','b','MarkerSize',msz)
            end
            
        end
        break
    end
    
end
return
