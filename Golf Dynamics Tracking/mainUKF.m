%% AAE590ET Project: Main UKF
clear 
clc 
close all

% System Modeling
w = [1, 10^-1, 1]; % Process noise definition (standard deviations)
Q = diag([w(1)^2, w(2)^2, w(3)^2]); % (covariances) 
G = [0, 0, 0; 1, 0, 0; 0, 0, 0; 0, 1, 0; 0, 0, 0; 0, 0, 1]; % Mapping Matrix
timespan = 0:0.1:500; % Defining timespan for noise
v = [1, 10, 10^-3, 10^-1]; % Measurement noise definition (standard deviations)
R = diag(v.^2);
tspan = 0:0.1:100;
x0 = [0, 180, 0, 90, 0, 10]'; 
meas_dim = 4; %
num_states = 6; 


% System Dynamics Model
[noise] = getNoise(w, timespan); % Creating noise array
[Flight, Time] = getTrajectory(noise, G, tspan, x0); % System Dynamics Model
num_time_steps = length(Time);

% Measurement Model 
[range, range_rate, theta, phi] = getMeasurements(Flight, v); 
[cart_traj] = getCartesian(range, theta, phi); 
Zk = [range; range_rate; theta; phi];

m0 = [1, 171, 1, 99, 1, 11.96]';
%P0 = [P0 = diag((x0-x0_hat).*(x0-x0_hat))10, 0, 0, 0, 0, 0; 0, 10, 0, 0, 0, 0; 0, 0, 10, 0, 0, 0; 0, 0, 0, 10, 0, 0; 0, 0, 0, 0, 10, 0; 0, 0, 0, 0, 0, 10]; 
P0 = (x0-m0)*(x0-m0)';


% Preallocate Memory For Arrays Storing Information For Each Time Step
mkm_hist = NaN(num_states,num_time_steps); % array of all priori estimates
mkp_hist = NaN(num_states,num_time_steps); % array of all posteriori estimates
Pkm_hist = NaN(num_states,num_states,num_time_steps); % array of all priori estimation error covariances
Pkp_hist = NaN(num_states,num_states,num_time_steps); % array of all posteriori covariances
Wk_hist = NaN(meas_dim,meas_dim,num_time_steps); % inovations matrix
Ck_hist = NaN(num_states,meas_dim,num_time_steps); % Cross covariance matrix
Kk_hist = NaN(num_states,meas_dim,num_time_steps); % Kalman gain matrix
mkp_hist(:,1) = m0; 
Pkp_hist(:,:,1) = P0;

% Uncented Parameters For Scaled Unscented Transform
alpha = 0.001;
beta = 2;
kappa = 3-num_states;
lambda = alpha^2*(num_states + kappa) - num_states;

% Set Initial Posteriori k-1 Values
mkm1 = m0; 
Pkm1 = P0;
sigma_km1 = NaN(num_states,num_states*2+1);
sigma_km = NaN(num_states,num_states*2+1);
sigma_dyn = NaN(num_states,num_states*2+1);
sigma_meas = NaN(num_states,num_states*2+1);

w_mean = NaN(1,num_states*2+1);
w_cov = NaN(1,num_states*2+1);

w_mean(1) = lambda / (num_states + lambda);
w_mean(2:end) = 1 / (2*(num_states+lambda));
w_cov(1) = lambda / (num_states + lambda) + (1-alpha^2+beta);
w_cov(2:end) = 1 / (2*(num_states+lambda));
tkm = 0; 
for i = 2:num_time_steps 
    tk = Time(i);
    span = [tkm, tk];
    zk = Zk(:, i); 
    
    % Calculate Cholesky Factor
    P_chol = chol(Pkm1, 'lower'); 
    
    % Calculate Sigma Points From Previous Time Step
    sigma_km1(:,1) = mkm1;
    for l = 2:num_states+1
        sigma_km1(:,l) = mkm1 + sqrt(num_states+lambda)*P_chol(:,l-1);
        sigma_km1(:,l+num_states) = mkm1 - sqrt(num_states + lambda)*P_chol(:,l-1);
    end
    
   % Calculate New Apriori Prediction Sigma Points
    for l = 1:2*num_states+1
        [~, propagate] = ode45(@(t, propagate) PropagateUKF(t, propagate, G, Q), span, sigma_km1(:, l)); % This is right    

        sigma_dyn(:,l) =  propagate(end,1:num_states).';
    end
    
    % Calculate Apriori Mean and Covariance
    mkm = zeros(num_states,1);
    Pkm = zeros(num_states,num_states);
    
    for l = 1:num_states*2+1
        mkm = mkm + sigma_dyn(:,l).*w_mean(l);
    end
    for l = 1:num_states*2+1

        Pkm = Pkm + (sigma_dyn(:,l)-mkm)*(sigma_dyn(:,l)-mkm).'.*w_cov(l);
    end

    Pkm = Pkm + G*Q*G.';
    
    % Update 
    
    % Measurement Sigma Points
    sigma_km(:,1) = mkm;
    Pkm_chol = chol(Pkm,'lower');

    for l = 2:num_states+1
        sigma_km(:,l) = mkm + sqrt(num_states+lambda)*Pkm_chol(:,l-1);
        sigma_km(:,l+num_states) = mkm - sqrt(num_states+lambda)*Pkm_chol(:,l-1);
    end
    
    zk_hat = zeros(meas_dim,1);
    Wk = zeros(meas_dim,meas_dim);
    Ck = zeros(num_states,meas_dim);    
    
    % Compute Gains
    for l = 1:num_states*2+1
        Zk(:,l) = getEstimate(sigma_km(:,l)); 
        zk_hat = zk_hat + w_mean(l) .* Zk(:,l);
    end
    
    for l = 1:num_states*2+1

        Wk = Wk + w_cov(l).*(Zk(:,l) - zk_hat)*(Zk(:,l) - zk_hat).';
        Ck = Ck + w_cov(l).*(sigma_km(:,l) - mkm)*(Zk(:,l) - zk_hat).';

    end
    Wk = Wk + R;
    
    % calculate posterior state
    Kk = Ck/Wk;
    mkp = mkm + Kk*(zk-zk_hat);
    Pkp = Pkm - Ck*Kk.' - Kk*Ck.' + Kk*Wk*Kk.';
    Pkp = 1/2*(Pkp+Pkp.');

    % store values
    mkm_hist(:,i) = mkm;
    mkp_hist(:,i) = mkp;
    Pkm_hist(:,:,i) = Pkm;
    Pkp_hist(:,:,i) = Pkp;
    Wk_hist(:,:,i) = Wk;
    Ck_hist(:,:,i) = Ck;
    Kk_hist(:,:,i) = Kk;
    t_span_hist(:,i) = tspan;
    
    %recursion
    mkm1 = mkp;
    Pkm1 =Pkp;
    tkm1 = tk;
    
end

plot3(mkp_hist(1, :), mkp_hist(5, :), mkp_hist(3, :))
hold on 
plot3(Flight(1, :), Flight(5, :), Flight(3, :)); 
