function [J] = getModelJacobian(x)
    C_d = 0.23; % Between 0.24 and 0.7, typically
    r = 0.85; % Radius (in)
    rho = 0.0000442881929; % Atmospheric Density (lb/in^3)
    A = pi*(r/12)^2; % Area of a golf ball (in^2)
    D = ((1/2)*C_d*rho*A); % Drag Force (lb/in)
    s = 0.000005; % Magnus Coefficient (Assumed constant)
    m = 0.20235843; % Mass of golf ball (lbs)
    M = s/m; % Magnus coefficient divided by mass
    W_I = 110; % Spin in x-direction
    W_J = 0; % Spin in y-direction
    W_K = -110; % Spin in z-direction
    
    J(1, :) = [0, 1, 0, 0, 0, 0]; 
    J(2, :) = [0, -2*D*x(2)/m, 0, -M*W_K, 0, M*W_J]; 
    J(3, :) = [0, 0, 0, 1, 0, 0]; 
    J(4, :) = [0, M*W_K, 0, -2*D*x(4)/m, 0, -M*W_I]; 
    J(5, :) = [0, 0, 0, 0, 0, 1]; 
    J(6, :) = [0, -M*W_J, 0, M*W_I, 0, -2*D*x(6)/m]; 
end

