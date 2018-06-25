p=[0.4, 0.5, 0.6, 0.8];
samples = 80;
max_n = 100;

arms = length(p);
regret = zeros(samples, max_n+1);
parfor i=1:samples
    i
    [log_wealth_kl, log_wealth_optimal] = run_mab(p, max_n);
    regret(i,:) = log_wealth_optimal - log_wealth_kl;
end
%%
%get_kl_div(0.5, 0.6)
[~, p_opt_index] = max(abs(p-1/2));
p_opt = p(p_opt_index);
diffs = p_opt*log(p_opt) + (1-p_opt)*log(1-p_opt) - ...
        (p.*log(p) + (1-p).*log(1-p));

upper_bound_coeff = 0;
loglog_term = 0;
for i=1:length(p)
    kl = get_kl_div(max(p(i),1-p(i)),max(p_opt,1-p_opt));
    %kl1 = get_kl_div(p(i),max(p_opt,1-p_opt));
    %kl2 = get_kl_div(1-p(i),max(p_opt,1-p_opt));
    if i ~= p_opt_index
        %upper_bound_coeff = upper_bound_coeff + diffs(i) / (kl1) + diffs(i) / (kl2);
        upper_bound_coeff = upper_bound_coeff + diffs(i) / kl;
        loglog_term = loglog_term + 1/2*log(log(2:max_n)/kl+1);
    end
end
%%
regret_bound = upper_bound_coeff * log(2:max_n) + 0.5*log((2:max_n)+1) + ...
   loglog_term + arms/2*log(pi/2);
plot(2:max_n, regret_bound, 'Color', 'black', 'LineWidth', 2);
xlim([0, max_n]);
xlabel('Number of pulls') % x-axis label
ylabel('$\log W_T(\Phi^*) - \log W_T(\hat{\Phi})$','Interpreter','latex') % y-axis label
hold on;
asymp_lower_bound = upper_bound_coeff * log(2:max_n);
plot(2:max_n, asymp_lower_bound, 'Color', 'black', 'LineWidth', 2);
plot(regret(1:50,:)');
plot(1:(max_n+1), mean(regret),'--', 'Color', 'black', 'LineWidth', 2);
hold off;