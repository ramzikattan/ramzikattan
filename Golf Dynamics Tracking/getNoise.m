function [noise] = getNoise(w, timespan)

    for i = 1:length(w)
        noise(i, :) = w(i) * randn(1, length(timespan));
    end
end

