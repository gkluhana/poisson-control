function [F,U] = extractFU(Wg,def_setup,prob_setup)
switch def_setup.permute
    case '123'
        F = Wg(1:prob_setup.nu);
        U = Wg(prob_setup.nu+1:prob_setup.nu+prob_setup.ny);
    case '231'
        U = Wg(1:prob_setup.ny);
        F = Wg(end-prob_setup.nu+1:end);
end

