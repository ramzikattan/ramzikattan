%% AAE590ET Project: Get Trajectory
function [flight, t] = getTrajectory(noise, G, timespan, x0)
options = odeset('RelTol', 1e-10, 'AbsTol', 1e-10, 'Events', @(t, x) hitground(t, x));

[t, x] = ode45(@(t, x) flightg(t, x), [0, 500], x0, options); 

flight = x';
function xprime = flightg(t, x)   
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

    xprime(1) = x(2); % X'
    xprime(2)=-(D/m)*x(2)^2+M*(W_J*x(6)-W_K*x(4)); % X''
    xprime(3)=x(4); % Y'
    xprime(4)=-32.2-(D/m)*x(4)^2+M*(W_K*x(2)-W_I*x(6)); % Y''
    xprime(5)=x(6); % Z'
    xprime(6)=-(D/m)*x(6)^2+M*(W_I*x(4)-W_J*x(2)); % Z''

    xprime = xprime' + (G * noise(1:3, find(timespan <= t, 1, 'last'))); 

    xprime = xprime(:);
end

end

