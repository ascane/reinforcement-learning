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


%% The MDP
% computes the transition array P=P(x,y,a) and expected value matrix R=R(x,a)
disp('Computing the true MDP...');
[P, R] = tree_MDP(max_height, A, sick_prob, growth,maintenance_cost, planting_cost, sell_price);

disp('Computing the simuation...');
[state, reward] = tree_sim(1, 1, max_height, A, sick_prob, growth,maintenance_cost, planting_cost, sell_price);
disp('state: ');
disp(state);
disp('reward: ');
disp(reward);

%% Parameters for the RL part
r = 0.05;
% discount parameter
gamma = 1. / (1 + r);
state_start = 1;

% number of trajectories used in MC or TD(0)
%runs = 250;
runs = 10;
% maximum number of steps per trajectory in MC and TD(0) (this will limit
% the accuracy of the two methods)
%max_step = 1000;
max_step =50;

%% Example of policy that may be evaluated
pi = zeros(S, 1);
% keep
pi(1 : 3) = 1;
% cut
pi(4 : max_height) = 2;
pi(sick_state) = 2;

%% Policy evaluation: DP (matrix inversion) versus RL (Monte-Carlo)
disp('Monte Carlo...');
mc_values = monte_carlo_value(state_start, pi, runs, gamma, max_step, max_height, A, sick_prob,growth, maintenance_cost, planting_cost, sell_price);
disp(mc_values(runs));
%disp(mc_values);

disp('Bellman...');
b_values = bellman_value(pi, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
b_value = b_values(state_start);
disp(b_value);

x = [1 : runs];
plot(x, mc_values - b_value);

%% Value Iteration
disp('Value Iteration...');
K_VI = 100;
V_VI = value_iteration(K_VI, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
V_VI_opt = V_VI(K_VI, :);
%disp(V_VI);

%% Policy Iteration
disp('Policy Iteration...');
K_PI = 5;
[V_PI, pi_K] = policy_iteration(pi, K_PI, gamma, max_height, A, sick_prob,growth, maintenance_cost, planting_cost, sell_price);
V_PI_opt = V_PI(K_PI, :);

%disp(V_PI);
disp(pi_K);

%% Speed of convergence
x = [1 : K_VI];
y = zeros(K_VI, 1);
for k = 1 : K_VI
    y(k) = max(abs(V_VI(k, :) - V_PI_opt));
end
plot(x, y);