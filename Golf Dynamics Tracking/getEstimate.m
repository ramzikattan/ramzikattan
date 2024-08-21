function [z_est] = getEstimate(x)
    T = [x(1), x(3), x(5)]; 
    z_est(1) = norm(T); 
    z_est(2) = (x(1)*x(2) + x(3)*x(4) + x(5)*x(6)) / norm(T); 
    z_est(3) = atan(x(5) / x(1)); 
    z_est(4) = acos(x(3) / norm(T)); 
end

