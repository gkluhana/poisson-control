
% pdecoDriver.m
%
% Generates the saddle point matrix, the stiffness matrix and mass matrix
% for the pde test problem 1. 
% 
% [A,B,K,M,dirn,ubdy] = PDEDriverrob(N,beta,bc,ob)
% 
% INPUT - blank returns default value
% N -    number of elements on one axis (1/h, where h is the mesh size)
% beta - Regularization parameter
% bc -   What boundary conditions to enforce 'dirichlet', 'neumann' or
%        'mixed'
% ob - the objective function - 1,2,3...
%
% OUTPUT
% A - saddle point matrix
% b - right hand side
% K - stiffness matrix
% M - mass matrix/home/rees/Thesis/Thesis code/PoissonControl

function [A,b,bdy_set,ubdy,uhat,def_setup,prob_setup] = pdecoDriver(def_setup)%(N,beta,bc,ob)

%% set N and h
N=2^def_setup.pow;
h=1/N;

%%



switch def_setup.bc
    case 'dirichlet'
        [dir,neu] = robbdy(N);
        dirn = unique(dir);
        neun = unique(neu);
        bdy_set.bdn = unique([dirn;neun]);
        bdy_set.dirn = bdy_set.bdn;
        bdy_set.neun = [];
        bdy_set.dbynodes = 1:4*N; % set nodes on boundary with dirichlet bcs
    case 'neumann'
        [dir,neu] = neubdy(N);
        bdy_set.dirn = unique(dir);
        bdy_set.neun = unique(neu);
        bdy_set.bdn = unique([bdy_set.dirn;bdy_set.neun]);
        bdy_set.dbynodes = [4*N]; % set nodes on boundary with dirichlet bcs
    case 'mixed'
        [dir,neu] = robbdy(N);
        bdy_set.dirn = unique(dir);
        bdy_set.neun = unique(neu);
        bdy_set.bdn = unique([bdy_set.dirn;bdy_set.neun]);
        bdy_set.dbynodes = [1:N+1,N+2:2:3*N];
end
[b K M ubdy uhat]=setupmat(h,bdy_set,def_setup.ob,def_setup.plots,def_setup.permute);
prob_setup.yelt = 'q1';
prob_setup.uelt = 'q1';
prob_setup.dim = 2;
prob_setup.eqn = 'poiss';
prob_setup.bc = 'dir';

l=length(M);

prob_setup.nu = length(M); % size of control
prob_setup.ny = length(K); % size of state


switch def_setup.permute
    case '123'
        A = [def_setup.beta*M sparse(l,l) -M;...                           
        sparse(l,l) M K';...           
        -M K sparse(l,l)];
    case '231'
        A = [M K' sparse(l,l);...                           
        K sparse(l,l) -M;...           
        sparse(l,l) -M def_setup.beta*M ];
end

