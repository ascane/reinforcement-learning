s = simulator; # initializing the simulator 
R = 500; #number of restocks
# parameters can be changed WITHIN the simulator object

%% Trying the simulator 

# print the number of drinks of each kind
[s.n_energy, s.n_nosugar]
# perform a transition with no discount
[rew, n_energy, n_nosugar] = s.simulate(0)
# reset the simulator
s.reset();

%% Comparison of one policy with the baseline

V = [0.1, 0.2, 0.5];
T = [2, 5, 10];

policy1 = @(n1,n2) soda_strategy_discount(n1, n2);
policy2 = @(n1,n2) soda_strategy_nodiscount(n1, n2);
policy3 = @(n1,n2) soda_strategy_param(n1, n2, T, V);

policy1(n_energy, n_nosugar)
policy2(n_energy, n_nosugar)
policy3(n_energy, n_nosugar)

[reward] = draw_arm(T, V, s);
reward

%{
R = 500; # nb of restocks to estimate the expectation
tot_rewards1 = simulation(policy1, R);
tot_rewards2 = simulation(policy2, R);
tot_rewards3 = simulation(policy3, R);
plot(1 : R, temporal_avg(tot_rewards1), 1 : R, temporal_avg(tot_rewards2), 1 : R, temporal_avg(tot_rewards3))
title('Expectation of total reward collected before restock')
xlabel('Time series')
ylabel('Reward')
legend('discount', 'no discount', 'T = [2, 5, 10], V = [0.1, 0.2, 0.5]', 'Location', 'southeast')
%}

%% Choose a bandit problem

nArms = 4;
TableT = [[2, 5, 10]; [3, 6, 9]; [1, 3, 5]; [1, 5, 7]];
TableV = [[0.1, 0.2, 0.5]; [0.1, 0.2, 0.3]; [0.2, 0.3, 0.4]; [0.2, 0.5, 0.9]];

MAB = {};
for iArm = 1 : nArms
    MAB(iArm) = armTV(TableT(iArm, :), TableV(iArm, :), s);
end


%{
%% Finding the best arm
R = 500; # nb of restocks
policy3 = @(n1,n2) soda_strategy_param(n1, n2, T, V);
policy4 = @(n1,n2) soda_strategy_param(n1, n2, TableT(2, :), TableV(2, :));
policy5 = @(n1,n2) soda_strategy_param(n1, n2, TableT(3, :), TableV(3, :));
policy6 = @(n1,n2) soda_strategy_param(n1, n2, TableT(4, :), TableV(4, :));
tot_rewards3 = simulation(policy3, R);
tot_rewards4 = simulation(policy4, R);
tot_rewards5 = simulation(policy5, R);
tot_rewards6 = simulation(policy6, R);
plot(1 : R, temporal_avg(tot_rewards3), 1 : R, temporal_avg(tot_rewards4), 1 : R, temporal_avg(tot_rewards5), 1 : R, temporal_avg(tot_rewards6))
title('Expectation of total reward collected before restock')
xlabel('Time series')
ylabel('Reward')
legend('T = [2, 5, 10], V = [0.1, 0.2, 0.5]', 'T = [3, 6, 9], V = [0.1, 0.2, 0.3]', 'T = [1, 3, 5], V = [0.2, 0.3, 0.4]', 'T = [1, 5, 7], V = [0.2, 0.5, 0.9]', 'Location', 'southeast')
%}

%% Comparing differnt MAB algorithms
R = 1000; # nb of restocks
eta = 0.01;
beta = 0.01;
best_policy = @(n1,n2) soda_strategy_param(n1, n2, TableT(3, :), TableV(3, :));
best_tot_rewards = simulation(best_policy, R) / 100;
[rew_UCB, draws_UCB] = UCB1(R, MAB);
[rew_TS, draws_TS] = TS_adaptation(R, MAB);
[rew_EXP3, draws_EXP3] = EXP3_MAB(R, MAB, eta, beta);
plot(1 : R, temporal_avg(rew_UCB), 1 : R, temporal_avg(rew_TS), 1 : R, temporal_avg(rew_EXP3), 1 : R, temporal_avg(best_tot_rewards))
title('Comparison among different MAB algorithms')
xlabel('Time series')
ylabel('Expectation of Normalized Reward')
legend('UCB', 'Thompson Sampling', 'EXP3', 'Best policy: T = [1, 3, 5], V = [0.2, 0.3, 0.4]', 'Location', 'southeast')