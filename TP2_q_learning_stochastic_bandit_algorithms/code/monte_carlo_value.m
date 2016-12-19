function [values] = monte_carlo_value(state_start, pi, runs, gamma, max_step, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)

    value = 0;
    values = zeros(runs, 1);
    for n = 1 : runs
        state_current = state_start;
        gamma_product = 1;
        for t = 1 : max_step
            if t > 1
                gamma_product *= gamma;
            end
            action = pi(state_current);
            [state_current, reward] = tree_sim(state_current, action, max_height, A, sick_prob,growth, maintenance_cost, planting_cost, sell_price);
            value += gamma_product * reward;
        end
        values(n) = value / n;
    end
end
