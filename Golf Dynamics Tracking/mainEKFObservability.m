%% AAE590ET Project: Main EKF
clear 
clc 
close all

% System Modeling
w = [1, 1, 1]; % Process noise definition
Q = diag([w(1)^2, w(2)^2, w(3)^2]);
G = [0, 0, 0; 1, 0, 0; 0, 0, 0; 0, 1, 0; 0, 0, 0; 0, 0, 1]; % Mapping Matrix
timespan = 0:0.1:500; % Defining timespan for noise
v = [10^-1, 10^-1, 10^-2, 10^-2]; 
R = chol(diag(v), 'lower');
tspan = 0:0.1:100;
x0 = [0, 10, 0, 5, 0, 2]; 

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


% Initializations 
x0_hat = [0, 170, 0, 80, 0, 10];  
P0 = (x0-x0_hat).*(x0-x0_hat)';
init_conditions = [x0_hat(:); P0(:)]; 
xkm_pr = x0_hat; 
Pkm_pr = P0; 
tkm = 0; 
x = 1; 
step = round(length(Time) / 5);
zk = NaN(4, length(Time)); 
%zk(:, find(Time <= 1)) = [range(find(Time <= 1)); range_rate(find(Time <= 1)); theta(find(Time <= 1)); phi(find(Time <= 1))];

for i = 1:step:length(Time)
   zk(:, i) = [range(i); range_rate(i); theta(i); phi(i)];
end

% Kalman Filtering
options = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);

for i = 2:length(Time)
   
    % Priori Prediction
    tk = Time(i);
    span = [tkm, tk];
    init_conditions = [xkm_pr(:); Pkm_pr(:)]; 
    [t, propagate] = ode45(@(t, propagate) Propagate(t, propagate, G, Q), span, init_conditions); % This is right
    xkm = propagate(end, 1:6).';
    Pkm = reshape(propagate(end, 7:end), 6, 6);
    
    if isnan(zk(:, i)) == [0, 0, 0, 0];
    % Innovations
    H = getMeasurementJacobian(xkm); 
    Wk = H*Pkm*H.' + R; 
    Ck = Pkm*H.'; 
    
    % Gain
    Kk = Ck / Wk; 
    
    % Update 
    z_est = getEstimate(xkm)';
    Zk = zk(:, i);
    xkp = xkm + Kk * (zk(:, find(Time <= tk, 1, 'last')) - z_est);
    Pkp = Pkm - Ck*Kk.' - Kk*Ck.' + Kk*Wk*Kk.'; 
    Pkp = 0.5 * (Pkp + Pkp.');
    
    else
        xkp = xkm; 
        Pkp = Pkm;
    
    end
    
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
fill3([0, max(Flight(1, :))*100, max(Flight(1, :))*100, 0], [-100, -100, 100, 100], [0, 0, 0, 0], 'g')
xlim([0, max(Flight(1, :))*1.1])
%ylim([-5, 5])
zlim([0, (max(Flight(3, :))*1.1)])
grid on
xlabel('X Coordinates (ft)')
ylabel('Y Coordinates (ft)')
zlabel('Z Coordinates (ft)')
title('Kalman Filter Estimate of Ball Trajectory')
legend('Kalman Filter', 'True Trajectory')

%{
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
plot(Time, error1p)
hold on 
plot(Time, 1 * sigma_1p, 'r')
plot(Time, -1 * sigma_1p, 'r')
plot(Time, 2 * sigma_1p, 'r')
plot(Time, -2 * sigma_1p, 'r')
plot(Time, 3 * sigma_1p, 'r')
plot(Time, -3 * sigma_1p, 'r')
grid on 

figure
plot(Time, error2p)
hold on 
plot(Time, 1 * sigma_2p, 'r')
plot(Time, -1 * sigma_2p, 'r')
plot(Time, 2 * sigma_2p, 'r')
plot(Time, -2 * sigma_2p, 'r')
plot(Time, 3 * sigma_2p, 'r')
plot(Time, -3 * sigma_2p, 'r')
grid on 

figure
plot(Time, error3p)
hold on 
plot(Time, 1 * sigma_3p, 'r')
plot(Time, -1 * sigma_3p, 'r')
plot(Time, 2 * sigma_3p, 'r')
plot(Time, -2 * sigma_3p, 'r')
plot(Time, 3 * sigma_3p, 'r')
plot(Time, -3 * sigma_3p, 'r')
grid on 

figure
plot(Time, error4p)
hold on 
plot(Time, 1 * sigma_4p, 'r')
plot(Time, -1 * sigma_4p, 'r')
plot(Time, 2 * sigma_4p, 'r')
plot(Time, -2 * sigma_4p, 'r')
plot(Time, 3 * sigma_4p, 'r')
plot(Time, -3 * sigma_4p, 'r')
grid on 

figure
plot(Time, error5p)
hold on 
plot(Time, 1 * sigma_5p, 'r')
plot(Time, -1 * sigma_5p, 'r')
plot(Time, 2 * sigma_5p, 'r')
plot(Time, -2 * sigma_5p, 'r')
plot(Time, 3 * sigma_5p, 'r')
plot(Time, -3 * sigma_5p, 'r')
grid on 

figure
plot(Time, error6p)
hold on 
plot(Time, 1 * sigma_6p, 'r')
plot(Time, -1 * sigma_6p, 'r')
plot(Time, 2 * sigma_6p, 'r')
plot(Time, -2 * sigma_6p, 'r')
plot(Time, 3 * sigma_6p, 'r')
plot(Time, -3 * sigma_6p, 'r')
grid on 
%}