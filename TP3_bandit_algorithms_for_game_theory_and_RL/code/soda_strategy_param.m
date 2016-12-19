function [discount] = soda_strategy_param(n_energy, n_nosugar, T, V)
    discount = 0;
    diff_n = abs(n_energy - n_nosugar);

    if n_energy > n_nosugar
        if diff_n > T(1) && diff_n <= T(2)
            discount = V(1);
        elseif diff_n > T(2) && diff_n <= T(3)
            discount = V(2);
        elseif diff_n > T(3)
            discount = V(3);
        end
    else
        if diff_n > T(1) && diff_n <= T(2)
            discount = -V(1);
        elseif diff_n > T(2) && diff_n <= T(3)
            discount = -V(2);
        elseif diff_n > T(3)
            discount = -V(3);
        end
    end
end