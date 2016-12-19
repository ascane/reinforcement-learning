s = simulator;

R = 500; # nb of restocks to estimate the expectation
tot_rewards = zeros(1, R);
tot_sodas = zeros(1, R);

policy = @(n1,n2) soda_strategy_discount(n1, n2);

for r = 1 : R
      s.reset(); # refill
      [rew, n_energy, n_nosugar] = s.simulate(0);
      reward = rew;
      t = 1;
      while (n_energy > 0 && n_nosugar> 0)
          # no re-fill is needed
          discount = policy(n_energy, n_nosugar);
          [rew, n_energy, n_nosugar] = s.simulate(discount);
          reward = reward + rew;
          t = t + 1;
      end
      tot_rewards(r) = reward; # total reward obtained
      tot_sodas(r) = t; # number of sodas solde
end
