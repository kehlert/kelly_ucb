function [kl_div, grad] = get_kl_div(p,q)
    if p == 0
        kl_div = -log(1-q);
        grad = 1/(1-q);
    elseif p == 1
        kl_div = -log(q);
        grad = -1./q;
    elseif p > 0 && (q == 0 || q == 1)
        kl_div = Inf;
        grad = -Inf;
    else
        kl_div = p*log(p./q)+(1-p)*log((1-p)./(1-q)); 
        grad = (q-p)./((1-q).*q);
    end
end

