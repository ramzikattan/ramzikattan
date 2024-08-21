%% AAE590ET Project: Process Noise Determination
clear 
clc 
close all

% System Modeling
G = [0, 0, 0; 1, 0, 0; 0, 0, 0; 0, 1, 0; 0, 0, 0; 0, 0, 1]; % Mapping Matrix
timespan = 0:0.1:500; % Defining timespan for noise
v = [10^-2, 10^-2, 10^-3, 10^-3]; 
R = chol(diag(v), 'lower');
tspan = 0:0.1:100;
x0 = [0, 175, 0, 75, 0, 0]; 
rng('Default')
figure
for i = -5:3
    w = [10^i, 10^(i-1), 10^i]; % Process noise definition
    Q = diag([w(1), w(2), w(3)]);
    [noise] = getNoise(w, timespan); % Creating noise array
    [Flight, Time] = getTrajectory(noise, G, tspan, x0); % System Dynamics Model
    plot3(Flight(1, :), Flight(5, :), Flight(3, :))
    hold on
end
legend('i = -5', 'i = -4', 'i = -3', 'i = -2', 'i = -1', 'i = 0', 'i = 1', 'i = 2', 'i = 3')
xlabel('X Coordinate (ft)')
ylabel('Z Coordinate (ft)')
zlabel('Y Coordinate (ft)')
title('Determination of Process Noise i = [-5, 3]')
grid on

figure
for i = -5:1
    w = [10^i, 10^(i-1), 10^i]; % Process noise definition
    Q = diag([w(1), w(2), w(3)]);
    [noise] = getNoise(w, timespan); % Creating noise array
    [Flight, Time] = getTrajectory(noise, G, tspan, x0); % System Dynamics Model
    plot3(Flight(1, :), Flight(5, :), Flight(3, :))
    hold on
end
legend('i = -5', 'i = -4', 'i = -3', 'i = -2', 'i = -1', 'i = 0', 'i = 1')
xlabel('X Coordinate (ft)')
ylabel('Z Coordinate (ft)')
zlabel('Y Coordinate (ft)')
title('Determination of Process Noise i = [-5, 1]')
grid on