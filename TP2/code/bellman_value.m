function [values] = bellman_value(pi, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)

    S = max_height + 1;
    
    [dynamics, reward] = tree_MDP(max_height, A, sick_prob,growth, maintenance_cost, planting_cost, sell_price);
    
    R = zeros(S, 1);
    for i = 1 : S
        R(i) = reward(i, pi(i));
    end
    
    P = zeros(S, S);
    for i = 1 : S
        for j = 1 : S
            P(i, j) = dynamics(i, j, pi(i));
        end
    end
    
    I = eye(S);
    
    values = inv(I - gamma * P) * R;
 end
 