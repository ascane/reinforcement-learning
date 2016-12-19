function [avg_array] = temporal_avg(array)
    len = length(array);
    cumsum_array = cumsum(array);
    avg_array = zeros(1, len);
    for i = 1 : len
        avg_array(i) = double(cumsum_array(i)) / i;
    end
end