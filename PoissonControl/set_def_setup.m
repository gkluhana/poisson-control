function def_setup = set_def_setup

def_setup.pow = 5;          % No of elts on edge is 2^pow
def_setup.bc = 'dirichlet'; % dirichlet, neumann or mixed
def_setup.beta = 1e-4;      % regularization parameter
def_setup.ob = 1;           % objective function -- 1,2 or 3
def_setup.plots = 1;        % 0 no plots,1 for plots with subfigures or 2 for no subfigures
def_setup.type = 'dist2d';  % dist2d, dist3d, bound2d
def_setup.permute = '231';  % permutation of the matrix --'123' or '231'
def_setup.precon = 'exact'  % exact preconditioner
