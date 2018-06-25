function [log_wealth_kl, log_wealth_optimal] = run_mab(p, max_n)
    eps = 0.001;
    log_wealth_optimal = zeros(max_n+1, 1);
    log_wealth_kl = zeros(max_n+1, 1);
    
    [~, p_opt_index] = max(abs(p-1/2));
    p_opt = p(p_opt_index);
    kelly_opt = 2*p_opt-1;
   
    arms = length(p);
    
    z = binornd(1, p);
    x = 2*z-1;
    S = z;
    N = ones(arms, 1);
    f = zeros(arms, 1);
    
    for t=1:arms
        f(t) = x(t) / 2;
    end
    
    for t=1:max_n
        %choose arm
        arm_index = get_arm_index(S,N,t);
        z = binornd(1, p(arm_index));
        x = 2*z-1;
        S(arm_index) = S(arm_index) + z;
        
        %update wealth
        %scale back f to avoid really wild fluctations at the beginning
        %this is just a heuristic that does not yet appear in the paper
        %the constant in the denominator was chosen arbitrarily
        %f_scales ~ f(arm_index) as N->Inf
        f_scaled = f(arm_index);% * N(arm_index) / (N(arm_index) + 2);
        log_growth_kl = log(1 + f_scaled * x); 
        
        log_wealth_kl(t+1) = log_wealth_kl(t) + log_growth_kl;
        N(arm_index) = N(arm_index) + 1;
        f(arm_index) = (N(arm_index) * f(arm_index) + x) / (N(arm_index) + 1);

        if arm_index ~= p_opt_index
            log_growth_opt = log(1 + kelly_opt * (2*binornd(1, p_opt)-1));
        else
            log_growth_opt = log(1 + kelly_opt * x);
        end
        
        log_wealth_optimal(t+1) = log_wealth_optimal(t) + log_growth_opt;
    end
    f
    N
end

