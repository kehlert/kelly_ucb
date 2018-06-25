function [f,g,H] = obj_min(q)
% Calculate objective f
f = q;

if nargout > 1 % gradient required
    g = 1;
    
    if nargout > 2
        H = 0;
    end
end
