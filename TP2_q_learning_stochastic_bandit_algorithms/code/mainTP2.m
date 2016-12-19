%% Problem specification

% state space (including a sick state)
max_height = 5;
S = max_height + 1;
sick_state = max_height + 1;
init_state = 1;

% action space (a=1 keep; a=2 cut)
A = 2;

% maintenance and planting cost
maintenance_cost = 1.0;
% planting cost
planting_cost = 1.0;
% price for selling a tree
sell_price = 1.0;

%% Parameters of the dynamics 

% probability of getting sick
sick_prob = 0.1;
% probability of growing: growth_proba(k,j) is the probability of growing by j when the current height is k
growth = zeros(max_height - 1, max_height - 1);
growth(1 : (max_height - 3), 1 : 3) = 1/3;
growth(max_height - 2, 1 : 2 ) = 1/2;
growth(max_height - 1, 1) = 1;

% discount parameter
r = 0.05;
gamma = 1. / (1 + r);
state_start = 1;

%% Q-learning algorithm
disp('Q-learning');

% epsilon-greedy policy in Q-learning
epsilon = 0.01;
N = 100; % 100
T_max = 1000; % 1000

[pi_N, r_N] = q_learning(N, T_max, epsilon, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);

% Performance in the initial state
%{
V_diff_N = zeros(N, 1);
V_opt = bellman_value(pi_N(N, :), gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)(1);
for n = 1 : N
    V_n = bellman_value(pi_N(n, :), gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)(1);
    V_diff_N(n) = abs(V_opt - V_n);
end
plot(1 : N, V_diff_N)
%}

% Performance over all the other states
%{
V_diff_all_N = zeros(N, 1);
V_opt_S = bellman_value(pi_N(N, :), gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
for n = 1 : N
    V_n_S = bellman_value(pi_N(n, :), gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
    V_diff_all_N(n) = abs(V_opt_S(1) - V_n_S(1));
    for s = 2 : S
        V_temp = abs(V_opt_S(s) - V_n_S(s));
        if V_temp > V_diff_all_N(n)
            V_diff_all_N(n) = V_temp;
        end
    end
end
plot(1 : N, V_diff_all_N)
%}

% plot(1 : N, r_N)

%% Build your own bandit problem 

% this is an example, please change the parameters or arms!
%{
Arm1 = armBernoulli(0.3);
Arm2 = armBernoulli(0.25);
Arm3 = armBernoulli(0.2);
Arm4 = armBernoulli(0.1);
%}

%{
Arm1 = armBernoulli(0.6);
Arm2 = armBernoulli(0.5);
Arm3 = armBernoulli(0.4);
Arm4 = armBernoulli(0.2);
%}

MAB = {Arm1, Arm2, Arm3, Arm4};

% bandit : set of arms

NbArms = length(MAB);

Means = zeros(1, NbArms);
for i = 1 : NbArms
    Means(i) = MAB{i}.mean;
end

% Display the means of your bandit (to find the best)
Means;
muMax = max(Means);


%% Comparison of the regret on one run of the bandit algorithm

T = 5000; % horizon

rangeT = zeros(T, 1);
for t = 1 : T
    rangeT(t) = t;
end

%{
[rew1, draws1] = UCB1(T, MAB);
reg1 = muMax * rangeT - cumsum(rew1);
[rew2, draws2] = TS(T, MAB);
reg2 = muMax * rangeT - cumsum(rew2);

plot(1 : T, reg1, 1 : T, reg2)
title('Regret of one run - Bernoulli bandit models')
xlabel('Time series')
ylabel('Regret')
legend('UCB1', 'TS', 'Location', 'southeast')
%}

%% (Expected) regret curve for UCB and Thompson Sampling

%{
C = 0;
for i = 1 : NbArms
    if Means(i) < muMax
        C += (muMax - Means(i)) / (Means(i) * log(Means(i) / muMax) + (1 - Means(i)) * log((1 - Means(i)) / (1 - muMax)));
    end
end

oracle = zeros(T, 1);
for t = 1 : T
    oracle(t) = C * log(t);
end

rew1_expectation = zeros(T, 1);
rew2_expectation = zeros(T, 1);
times = 100;
for n = 1 : times
    rew1_expectation += UCB1(T, MAB);
    rew2_expectation += TS(T, MAB);
end
rew1_expectation /= times;
rew2_expectation /= times;
reg1_expectation = muMax * rangeT - cumsum(rew1_expectation);
reg2_expectation = muMax * rangeT - cumsum(rew2_expectation);
plot(1 : T, reg1_expectation, 1 : T, reg2_expectation, 1 : T, oracle)
title('Expectation of regret - Bernoulli bandit models')
xlabel('Time series')
ylabel('Regret')
legend('UCB1', 'TS', 'Lai and Robbins lower bound', 'Location', 'southeast')
%}

%% Non-parametric bandits (bounded rewards)
%{
Arm5 = armExp(0.3);
Arm6 = armExp(0.25);
Arm7 = armExp(0.2);
Arm8 = armExp(0.1);
%}

%{
Arm5 = armExp(0.6);
Arm6 = armExp(0.5);
Arm7 = armExp(0.4);
Arm8 = armExp(0.2);
%}

MAB2 = {Arm5, Arm6, Arm7, Arm8};

NbArms2 = length(MAB2);

Means2 = zeros(1, NbArms2);
for i = 1 : NbArms2
    Means2(i) = MAB2{i}.mean;
end

muMax2 = max(Means2);

%{
[rew3, draws3] = UCB1(T, MAB2);
reg3 = muMax2 * rangeT - cumsum(rew3);
[rew4, draws4] = TS_adaptation(T, MAB2);
reg4 = muMax2 * rangeT - cumsum(rew4);

plot(1 : T, reg3, 1 : T, reg4)
title('Regret of one run - Non-parametric bandits - Exponential bandit models')
xlabel('Time series')
ylabel('Regret')
legend('UCB1', 'Adaptation of TS for non-binary rewards', 'Location', 'southeast')
%}

%{
C2 = 0;
for i = 1 : NbArms2
    if Means2(i) < muMax2
        C2 += (muMax2 - Means2(i)) / (Means2(i) * log(Means2(i) / muMax2) + (1 - Means2(i)) * log((1 - Means2(i)) / (1 - muMax2)));
    end
end

oracle2 = zeros(T, 1);
for t = 1 : T
    oracle2(t) = C2 * log(t);
end

rew3_expectation = zeros(T, 1);
rew4_expectation = zeros(T, 1);
times = 100;
for n = 1 : times
    rew3_expectation += UCB1(T, MAB2);
    rew4_expectation += TS_adaptation(T, MAB2);
end
rew3_expectation /= times;
rew4_expectation /= times;

reg3_expectation = muMax2 * rangeT - cumsum(rew3_expectation);
reg4_expectation = muMax2 * rangeT - cumsum(rew4_expectation);

plot(1 : T, reg3_expectation, 1 : T, reg4_expectation, 1 : T, oracle2)
title('Expectation of regret - Non-parametric bandits - Exponential bandit models')
xlabel('Time series')
ylabel('Regret')
legend('UCB1', 'Adaptation of TS for non-binary rewards', 'Lai and Robbins lower bound', 'Location', 'southeast')
%}
