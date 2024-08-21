%% AAE 439, TEAM 10, Trajectory Project
clear; close all;
tic
%% Easy Variable Change

% Wind speed
Vwind = 3.048; % m/s

% Time steps (time step convergence)(change this value here, it changes
% time steps for all loops)
num = 383; % number of time steps for launch - pre parachute deployment


% Number of Angles Calculated, starting at 75 (1 to 16) 
% where 1 = 75, 2 = 76, 3 = 77, etc
num_a = 13; 


%% Initialize thrust and drag data
thrustdata = readmatrix('thrust_data.csv');
dragdata = readmatrix('DragDataNew.csv');

% Parse needed data from initialized data
thrust = thrustdata(:,3); %in N
drag = dragdata(:,6); %in N

% Constants
% masses [kg]
mRocket = 2/2.205;
mProp = 0.121;
mMotor = 0.261;
tBurn = 2.3;
m0 = mRocket + mMotor;
mdot = mProp/tBurn;
m = m0;
% gravity
g = 9.8; % m/s^2

% Initialize Arrays
F = zeros(1, num);
Diameter_p = zeros(1, num);
theta_int = linspace(78,90,13); % cycle through all values of theta between 75 and 90 degrees

% Trajectory parameters based on thrusting or coasting
for k = 1:num
    if k <= 65 % Thrusting for 2.3 s
        F(k) = thrust(k);
        D(k) = drag(k);
    else % Coasting until parachute deploys
        F(k) = 0;
        D(k) = drag(k);
        if D(k) < 0
           D(k) = D(k) * -1;
        end
    end
end


%% Trajectory - pre parachute depolyment
opts = odeset('RelTol',1e-2,'AbsTol',1e-2);

% Set initial parameters
t = linspace(0,16.398,num); % time until apogee, from OpenRocket

% Determine theta and velocity (deg and m/s) for ignition phase
% Section 1
for k = 1:num_a

    % Use ode 45 to solve differential system of equations for theta and
    % velocity
    i_cond = [.001, theta_int(k)]; % initial conditions [v, theta] 

    [time, output] = ode45(@(time, output) trajectory_rev2(time, output, Vwind, F, D, t), t, i_cond, opts);
    v(:, k) = output(:,1);
    theta(:,k) = output(:,2);
    dt = time(2); % time change, constant
    startD = 0; % starting distance at 0 m in x direction
    start_h = 1.8288; %start height of the rocket in m 

    for j = 1:1:num
        % Adjusting for changing mass during burn
        if j <= 65 % propellant burn
            m = m0 - mdot*t(j);
        else % Propellant burn finished
            m = m0 - mProp;
        end
        
        % Updating psi, lift, acceleration, height, distance
        % Newton's second law
        psi = atand((v(j,k)*sind(theta(j,k)))/(Vwind + (v(j,k)*cosd(theta(j,k)))));
        Lsum = (-m*g*cosd(psi)) + (F(j) - D(j))*sind(theta(j, k) - psi); 
        L = Lsum/cosd(theta(j,k) - psi);
        acc1(j,k) = (((F(j) - D(j))*cosd(psi - theta(j,k)) - L*sind(psi - theta(j,k))) - m*g*sind(theta(j,k)))/m;

        % Kinematics
        height(j,k) = start_h + v(j,k)*sind(theta(j,k))*dt + .5*acc1(j,k)*sind(psi)*dt^2;
        distance(j, k) = startD + v(j,k)*cosd(theta(j,k))*dt + .5*acc1(j,k)*cosd(psi)*dt^2;
        start_h = height(j,k);
        startD = distance(j, k);
    end
end

% Plotting launch before parachute deployment
%{
figure(1)
subplot(2,2,1)
plot(time,v)
title('Time vs Velocity, Before Parachute Deployment')
xlabel('Time [s]')
ylabel('Velocity [m/s]')

subplot(2,2,2)
plot(time,theta)
title('Time vs Theta, Before Parachute Deployment')
xlabel('Time [s]')
ylabel('Theta [degrees]')

subplot(2,2,3)
plot(time,acc1)
title('Time vs Acceleration, Before Parachute Deployment')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')

subplot(2,2,4)
plot(time, height)
title('Time vs Height, Before Parachute Deployment')
xlabel('Time [s]')
ylabel('Height [m]')

figure(2)
plot(distance, height, 'k-');
xlabel ('x Distance [m]') 
ylabel ('Height [m]');
title('Rocket Trajectory Before Parachute Deployment')
%}
%% Model with Parachute

% Initial conditions from section 1
start_h2 = height(end,:);
start_D2 = distance(end,:);
start_thetaD = theta(end,:);

% Constants
rho = 1.293; % air density [kg/m^3]
cd = 0.75; % drag coefficient of parachute
Diameter_p = convlength(36, 'in', 'm'); % diameter of parachute
terminalVelocity = -sqrt((8*m*g)/(pi*rho*cd*Diameter_p^2)); % terminal velocity
A = pi*Diameter_p^2/4; % area of parachute
j = num; % iterations for section 1

% Set to add on time array
time_updated = time(end);
time_iteration = numel(time);

% Reaching terminal velocity
% Section 2
dt = 0.01; 
for k = 1:num_a

    % Setting initial conditions
    thetaD = start_thetaD(k);
    start_h = start_h2(k);
    startD = start_D2(k);
    
    % Determining trajectory before terminal velocity, updating
    % acceleration, height, distance, velocity, time
  
    while abs(v(j,k) - terminalVelocity) >= 0.05 * abs(terminalVelocity)
        a(j,k) = (1/2*rho*v(j, k)^2*cd*A - m*g*cosd(thetaD))/m;
        j = j + 1;
        
        v(j,k) = -sqrt((v(j-1, k)*cosd(thetaD) + a(j-1,k)*cosd(thetaD)*dt)^2 + (v(j-1, k)*sind(thetaD) + a(j-1,k)*sind(thetaD)*dt)^2);
        height(j,k) = start_h + v(j,k)*sind(thetaD)*dt + .5*a(j-1,k)*sind(thetaD)*dt^2;
        distance(j, k) = startD + v(j,k)*cosd(thetaD)*dt + .5*a(j-1,k)*cosd(thetaD)*dt^2;
        start_h = height(j,k);
        startD = distance(j, k);
        
%         time_iteration = time_iteration + 1; 
%         time_updated = time_updated + dt;
%         time(time_iteration)= time_updated;
                
    end
    tempJ(k) = j;
    j = num;
end

% Final values set initial conditions for next stage

for i = 1:num_a
    start_h3(i) = height(tempJ(i), i);
    start_D3(i) = distance(tempJ(i), i);
    acc3(i) = a(tempJ(i)-1, i);
end
thetaD = start_thetaD;

% After termninal velocity is reached
% Section 3
for k = 1:num_a

    % Setting initial conditions
    j = tempJ(k);
    start_h = start_h3(k);
    startD = start_D3(k);
    
    % Update height, distance, time
    while start_h > 0
        j = j+1;
        height(j,k) = start_h + terminalVelocity*sind(thetaD(k))*dt + .5*acc3(k)*sind(thetaD(k))*dt^2;
        distance(j, k) = startD + terminalVelocity*cosd(thetaD(k))*dt + .5*acc3(k)*cosd(thetaD(k))*dt^2;
        start_h = height(j,k);
        startD = distance(j, k);
        
%         time_iteration = time_iteration + 1; 
%         time_updated = time_updated + dt;
%         time(time_iteration)= time_updated;
    end
end

time = linspace(0, dt*length(distance), length(distance));
% Plotting launch including parachute deployment
%{
figure(3)
subplot(2,1,1)
plot(time,distance)
title('Time vs Distance, Entire Trajectory')
xlabel('Time [s]')
ylabel('x Distance [m]')

subplot(2,1,2)
plot(time, height)
title('Time vs Height, Entire Trajectory')
xlabel('Time [s]')
ylabel('Height [m]')

figure(4);
plot(distance, height);
xlabel ('x Distance [m]')
ylabel ('Height [m]');
title('Rocket Trajectory, Entire')
%}
for i = 1:num_a
    figure(5); hold on; grid on;
    plot(distance(:, i), height(:, i));
    final_dist(i) = distance(find(height(:, i) <= 0, 1, 'first'), i);
end
xlabel 'x distance [m]'; ylabel 'height [m]'
final_dist'
toc

