function [J] = getMeasurementJacobian(x)
    C_d = 0.23; % Between 0.24 and 0.7, typically
    r = 0.85; % Radius (in)
    rho = 0.0000442881929; % Atmospheric Density (lb/in^3)
    A = pi*(r/12)^2; % Area of a golf ball (in^2)
    D = ((1/2)*C_d*rho*A); % Drag Force (lb/in)
    s = 0.000005; % Magnus Coefficient (Assumed constant)
    m = 0.20235843; % Mass of golf ball (lbs)
    M = s/m; % Magnus coefficient divided by mass
    W_I = 110; % Spin in x-direction
    W_J = 110; % Spin in y-direction
    W_K = -110; % Spin in z-direction
    
    T = [x(1), x(3), x(5)]; 
    J(1, 1) = x(1) / norm(T);
    J(1, 2) = 0;
    J(1, 3) = x(3) / norm(T);
    J(1, 4) = 0;
    J(1, 5) = x(5) / norm(T);
    J(1, 6) = 0; 
    J(2, 1) = -(((x(6)*x(5) + x(4)*x(3))*x(1) - (x(5)^2 + x(3)^2)*x(2)) / norm(T)^3); 
    J(2, 2) = x(1) / norm(T);
    J(2, 3) = -(((x(6)*x(5) + x(1)*x(2))*x(3) - (x(5)^2 + x(1)^2)*x(4)) / norm(T)^3); 
    J(2, 4) = x(3) / norm(T);
    J(2, 5) = -(((x(3)*x(4) + x(1)*x(2))*x(5) - (x(3)^2 + x(5)^2)*x(6)) / norm(T)^3); 
    J(2, 6) = x(5) / norm(T);
    J(3, 1) = -x(5) / (x(1)^2 + x(5)^2); 
    J(3, 2) = 0;
    J(3, 3) = 0;
    J(3, 4) = 0;
    J(3, 5) = x(1) / (x(5)^2 + x(1)^2); 
    J(3, 6) = 0;
    J(4, 1) = (x(1)*x(3)) / (norm(T)^3 * (1 - x(3)^2 / (norm(T)^2))); 
    J(4, 2) = 0;
    J(4, 3) = - (x(1)^2 + x(5)^2) / (norm(T)^3 * (1 - x(3)^2 / (norm(T)^2))); 
    J(4, 4) = 0; 
    J(4, 5) = (x(5)*x(3)) / (norm(T)^3 * (1 - x(3)^2 / (norm(T)^2)));
    J(4, 6) = 0; 
    
end

