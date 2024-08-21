%% AAE590ET Project: Case 1
clear 
clc 
close all
rng('Default')
tic
% System Modeling
w = [1, 10^-1, 1]; % Process noise definition (standard deviations)
Q = diag([w(1)^2, w(2)^2, w(3)^2]); % (covariances) 
G = [0, 0, 0; 1, 0, 0; 0, 0, 0; 0, 1, 0; 0, 0, 0; 0, 0, 1]; % Mapping Matrix
timespan = 0:0.1:500; % Defining timespan for noise
v = [1, 10, 10^-3, 10^-1]; % Measurement noise definition (standard deviations)
R = diag(v.^2);
tspan = 0:0.1:100;
x0 = [0, 180, 0, 90, 0, 10]; 

[noise] = getNoise(w, timespan); % Creating noise array
[Flight, Time] = getTrajectory(noise, G, tspan, x0); % System Dynamics Model



% Measurement Model 
[range, range_rate, theta, phi] = getMeasurements(Flight, v); 
[cart_traj] = getCartesian(range, theta, phi); 

% Storage Setup
xkm_history = NaN(6, length(Time));
xkp_history = NaN(6, length(Time));
Pkm_history = NaN(6, 6, length(Time));
Pkp_history = NaN(6, 6, length(Time));


% Initial Conditions 
x0_hat = [0, 171, 0, 99, 0, 11.96];  
P0 = diag((x0-x0_hat).*(x0-x0_hat));
init_conditions = [x0_hat(:); P0(:)]; 
xkm_pr = x0_hat; 
Pkm_pr = P0; 

% Kalman Filtering
options = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

tkm = 0; 
zk = [range; range_rate; theta; phi];
for i = 2:length(Time)
    
    % Priori Prediction
    tk = Time(i);
    span = [tkm, tk];
    init_conditions = [xkm_pr(:); Pkm_pr(:)]; 
    [t, propagate] = ode45(@(t, propagate) Propagate(t, propagate, G, Q), span, init_conditions); % This is right
    xkm = propagate(end, 1:6).';
    Pkm = reshape(propagate(end, 7:end), 6, 6);
    
    % Innovations wrong
    H = getMeasurementJacobian(xkm); 
    Wk = H*Pkm*H.' + R; 
    Ck = Pkm*H.'; 
    
    % Gain wrong
    Kk = Ck / Wk; 
    
    % Update 
    z_est = getEstimate(xkm)';
    Zk = zk(:, i); %zk(:, find(Time <= tk, 1, 'last'));
    xkp = xkm + Kk * (zk(:, find(Time <= tk, 1, 'last')) - z_est);
    Pkp = Pkm - Ck*Kk.' - Kk*Ck.' + Kk*Wk*Kk.'; 
    Pkp = 0.5 * (Pkp + Pkp.');
    
    % Storage
    xkm_history(:, i) = xkm; 
    xkp_history(:, i) = xkp; 
    Pkm_history(:,:, i) = Pkm; 
    Pkp_history(:,:,i) = Pkp; 
    
    % Recursive
    xkm_pr = xkp; 
    Pkm_pr = Pkp;
    tkm = tk;
end

figure
plot3(xkp_history(1, :), xkp_history(5, :), xkp_history(3, :), 'bo')
hold on 
plot3(Flight(1, :), Flight(5, :), Flight(3, :), 'ro')
fill3([0, max(Flight(1, :))*1.1, max(Flight(1, :))*1.1, 0], [-max(Flight(5, :)), -max(Flight(5, :)), max(Flight(5, :)), max(Flight(5, :))], [0, 0, 0, 0], 'g')
grid on
xlabel('X Coordinates (ft)')
ylabel('Y Coordinates (ft)')
zlabel('Z Coordinates (ft)')
title('Kalman Filter Estimate of Ball Trajectory')
legend('Kalman Filter', 'True Trajectory')

%% Sigma Bounds
sigma_1p = sqrt(squeeze(Pkp_history(1,1,:)));
sigma_1m = sqrt(squeeze(Pkm_history(1,1,:)));
sigma_2p = sqrt(squeeze(Pkp_history(2,2,:)));
sigma_2m = sqrt(squeeze(Pkm_history(2,2,:)));
sigma_3p = sqrt(squeeze(Pkp_history(3,3,:)));
sigma_3m = sqrt(squeeze(Pkm_history(3,3,:)));
sigma_4p = sqrt(squeeze(Pkp_history(4,4,:)));
sigma_4m = sqrt(squeeze(Pkm_history(4,4,:)));
sigma_5p = sqrt(squeeze(Pkp_history(5,5,:)));
sigma_5m = sqrt(squeeze(Pkm_history(5,5,:)));
sigma_6p = sqrt(squeeze(Pkp_history(6,6,:)));
sigma_6m = sqrt(squeeze(Pkm_history(6,6,:)));

%% Errors
error1p = Flight(1, :) - xkp_history(1,:); 
error1m = Flight(1, :) - xkm_history(1,:); 
error2p = Flight(2, :) - xkp_history(2,:); 
error2m = Flight(2, :) - xkm_history(2,:); 
error3p = Flight(3, :) - xkp_history(3,:); 
error3m = Flight(3, :) - xkm_history(3,:); 
error4p = Flight(4, :) - xkp_history(4,:); 
error4m = Flight(4, :) - xkm_history(4,:); 
error5p = Flight(5, :) - xkp_history(5,:); 
error5m = Flight(5, :) - xkm_history(5,:); 
error6p = Flight(6, :) - xkp_history(6,:); 
error6m = Flight(6, :) - xkm_history(6,:); 

%% Plot Estimation Error and Associated ±3 Sigma Bounds
% Each State
figure
subplot(3, 2, 1)
plot(Time, error1p, 'k')
hold on 
plot(Time, 1 * sigma_1p, 'r')
plot(Time, -1 * sigma_1p, 'r')
plot(Time, 2 * sigma_1p, 'b')
plot(Time, -2 * sigma_1p, 'b')
plot(Time, 3 * sigma_1p, 'g')
plot(Time, -3 * sigma_1p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in X-Coordinate (ft)')
title('X-Coordinate Error')
legend('Error in X', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )


subplot(3, 2, 2)
plot(Time, error2p, 'k')
hold on 
plot(Time, 1 * sigma_2p, 'r')
plot(Time, -1 * sigma_2p, 'r')
plot(Time, 2 * sigma_2p, 'b')
plot(Time, -2 * sigma_2p, 'b')
plot(Time, 3 * sigma_2p, 'g')
plot(Time, -3 * sigma_2p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in $\dot{X}$-Coordinate (ft)', 'Interpreter', 'latex')
title('$\dot{X}$-Coordinate Error', 'Interpreter', 'latex')
legend('Error in $\dot{X}$', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )


subplot(3, 2, 3)
plot(Time, error3p, 'k')
hold on 
plot(Time, 1 * sigma_3p, 'r')
plot(Time, -1 * sigma_3p, 'r')
plot(Time, 2 * sigma_3p, 'b')
plot(Time, -2 * sigma_3p, 'b')
plot(Time, 3 * sigma_3p, 'g')
plot(Time, -3 * sigma_3p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in Y-Coordinate (ft)')
title('Y-Coordinate Error')
legend('Error in Y', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )

subplot(3, 2, 4)
plot(Time, error4p, 'k')
hold on 
plot(Time, 1 * sigma_4p, 'r')
plot(Time, -1 * sigma_4p, 'r')
plot(Time, 2 * sigma_4p, 'b')
plot(Time, -2 * sigma_4p, 'b')
plot(Time, 3 * sigma_4p, 'g')
plot(Time, -3 * sigma_4p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in $\dot{Y}$-Coordinate (ft)', 'Interpreter', 'latex')
title('$\dot{Y}$-Coordinate Error', 'Interpreter', 'latex')
legend('Error in $\dot{Y}$', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )

subplot(3, 2, 5)
plot(Time, error5p, 'k')
hold on 
plot(Time, 1 * sigma_5p, 'r')
plot(Time, -1 * sigma_5p, 'r')
plot(Time, 2 * sigma_5p, 'b')
plot(Time, -2 * sigma_5p, 'b')
plot(Time, 3 * sigma_5p, 'g')
plot(Time, -3 * sigma_5p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in Z-Coordinate (ft)')
title('Z-Coordinate Error')
legend('Error in Z', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )

subplot(3, 2, 6)
plot(Time, error6p, 'k')
hold on 
plot(Time, 1 * sigma_6p, 'r')
plot(Time, -1 * sigma_6p, 'r')
plot(Time, 2 * sigma_6p, 'b')
plot(Time, -2 * sigma_6p, 'b')
plot(Time, 3 * sigma_6p, 'g')
plot(Time, -3 * sigma_6p, 'g')
grid on 
xlabel('Time (s)')
ylabel('Error in $\dot{Z}$-Coordinate (ft)', 'Interpreter', 'latex')
title('$\dot{Z}$-Coordinate Error', 'Interpreter', 'latex')
legend('Error in $\dot{Z}$', '$\sigma$', '$-\sigma$', '$2\sigma$', '$-2\sigma$', '$3\sigma$', '$-3\sigma$',  'Interpreter', 'latex' )
toc