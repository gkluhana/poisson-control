function multdata = genA(def_setup,multdata,K)

% generates matrices once for geometric multigrid for the advection
% diffusion equation

for i = def_setup.pow:-1:1            % loop over all the levels
    h = 2^(-i+1);           % define h
    N = 1/h;
    
    %% get the sd constant, delta
    hk = min(abs(h/def_setup.c), abs(h/def_setup.s));
    
    P_h = h*(abs(def_setup.gamma))/((2)*def_setup.epsilon);
    
    % delta (ESW pg 136)
    if P_h > 1
        def_setup.delta = hk*(1-1/P_h)/((2)*abs(def_setup.gamma));
    else
        def_setup.delta = 0;
    end
    
    %% assemble the stiffness matrix
    cd AdvDiffControl
    switch def_setup.bc
        case 'mixed'
            dirn = unique(N);
        case 'dirichlet'
            [dir,neu] = robbdy(N);
            dirn = unique(dir); neun = unique(neu);
            dirn = unique([dirn;neun]);
        case 'neumann'
            dirn = unique(neubdy(N));
    end
    Abar = stiffsupg_co(h,def_setup,def_setup.delta);
    cd ..
    Abar(:,dirn) =[];
    Abar(dirn,:) = [];
    multdata(i).A = Abar;
    
    %% assemble the smoothing matrices
    if strcmp(multdata(1).smoother,'gs')==1
        multdata(i).GSfwd = tril(multdata(i).A,0); % (D-L);
        multdata(i).GSbwd = triu(multdata(i).A,0); % (D-U);
    end
end

if strcmp(multdata(1).smoother,'gs')==1
        multdata(def_setup.pow+1).GSfwd = tril(K,0); % (D-L);
        multdata(def_setup.pow+1).GSbwd = triu(K,0); % (D-U);
end

