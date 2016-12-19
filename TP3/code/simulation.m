function [tot_rewards] = simulation(policy, R)
    s = simulator;
    tot_rewards = zeros(1, R);
    for r = 1 : R
        s.reset(); # refill
        [rew, n_energy, n_nosugar] = s.simulate(0);
        reward = rew;
        while (n_energy > 0 && n_nosugar> 0)
            # no re-fill is needed
            discount = policy(n_energy, n_nosugar);
            [rew, n_energy, n_nosugar] = s.simulate(discount);
            reward += rew;
        end
        tot_rewards(r) = reward; # total reward obtained
    end
end