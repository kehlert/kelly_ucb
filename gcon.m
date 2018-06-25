function [c, ceq, jac_c, jac_ceq] = gcon(q,S,N,t)
    ceq = 0;
    jac_ceq = 0;
    p = S/N;
    
    [kl_div, grad] = get_kl_div(p, q);
    c = N*kl_div - log(t);
    jac_c = N*grad;
end

