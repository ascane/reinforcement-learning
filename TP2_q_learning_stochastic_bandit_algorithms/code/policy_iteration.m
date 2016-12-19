function [V, pi_K] = policy_iteration(pi, K, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)
    S = max_height + 1;
    
    [dynamics, reward] = tree_MDP(max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
    
    V = zeros(K, S);
    pi_current = pi;
    
    for k = 2 : K + 1
        Vk = bellman_value(pi_current, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
        for x = 1 : S
            V(k - 1, x) = Vk(x);
        end
        
        if k == K + 1
            break
        end
        
        for x = 1 : S
            value_current = -Inf;
            for a = 1 : A
                Qxa = 0;
                for y = 1 : S
                    Qxa += dynamics(x, y, a) * V(k - 1, y);
                end
                Qxa = reward(x, a) + gamma * Qxa;
                
                if Qxa > value_current
                    pi_current(x) = a;
                    value_current = Qxa;
                end
            end
            
        end
    end
    
    pi_K = pi_current;
end