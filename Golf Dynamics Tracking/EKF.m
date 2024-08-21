function [outputArg1,outputArg2] = EKF(Time, timespan, )

for i = 2:length(Time)
    
    % Priori Prediction
    tk = timespan(i);
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
    Zk = zk(:, find(Time <= tk, 1, 'last'));
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

end

