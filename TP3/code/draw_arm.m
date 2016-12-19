function [reward] = draw_arm(T, V, s)
    reward = 0;
    
    s.reset();
    while s.n_energy > 0 && s.n_nosugar > 0
        discount = soda_strategy_param(s.n_energy, s.n_nosugar, T, V);
        reward += s.simulate(discount);
    end
end