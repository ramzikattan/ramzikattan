function [range, range_rate, theta, phi] = getMeasurements(T, v)

    for i = 1:length(T)
        traj = [T(1, i), T(3, i), T(5,i)];
        range(i) = (norm(traj)) + (randn * v(1));
        range_rate(i) = ((T(1, i)*T(2, i) + T(3, i)*T(4, i) + T(5, i)*T(6, i)) / norm(traj)) + (randn * v(2));
        theta(i) = atan(T(5, i) / T(1, i)) + (randn * v(3)); 
        phi(i) = acos(T(3, i) / (norm(traj))) + (randn * v(4)); 
    end

    measurement = [range, range_rate, theta, phi];
end

