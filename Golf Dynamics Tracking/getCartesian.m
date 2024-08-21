function [cart_traj] = getCartesian(range, theta, phi)
    for i = 1:length(range)
        x(i) = range(i) * sin(phi(i)) * cos(theta(i)); 
        z(i) = range(i) * sin(phi(i)) * sin(theta(i)); 
        y(i)= range(i) * cos(phi(i)); 
    end 
    cart_traj = [x', y', z']; 
end

