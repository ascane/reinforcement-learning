function [discount] = soda_strategy_discount(n_energy, n_nosugar)

    if (n_energy <= n_nosugar)
        discount = -0.2;
    else
        discount = 0.2;
    end

end

