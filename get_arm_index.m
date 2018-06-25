function [arm_index, long] = get_arm_index(S, N, t)
    options = optimoptions('fmincon',...
                           'Algorithm', 'sqp',...
                           'SpecifyConstraintGradient',true,...
                           'SpecifyObjectiveGradient', true,...
                           'display', 'off');
    
    arms = length(S);
    q_long = zeros(arms,1);
    q_short = zeros(arms,1);
    for k=1:arms
        q_long(k) = fmincon(@obj_max, 0.5, [], [], [], [], 0, 1, @(q) gcon(q,S(k),N(k),t), options);
        q_short(k) = 1 - fmincon(@obj_min, 0.5, [], [], [], [], 0, 1, @(q) gcon(q,S(k),N(k),t), options);
    end
    
    [q_long_max, arm_index_long] = max(q_long);
    [q_short_max, arm_index_short] = max(q_short);
    
    if q_long_max > q_short_max
        arm_index = arm_index_long;
        long = true;
    else
        arm_index = arm_index_short;
        long = false;
    end
end