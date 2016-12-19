function [V] = value_iteration(K, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)
    S = max_height + 1;
    V = zeros(K, S);
    
    [dynamics, reward] = tree_MDP(max_height, A, sick_prob,growth, maintenance_cost, planting_cost, sell_price);
    
    %% Q_0 = zeros(S, A);
    %% Q_1 =  reward;
    Q = reward;
    
    for k = 2 : K + 1
        for x = 1 : S
            V(k - 1, x) = Q(x, 1);
            for a = 2 : A
                V(k - 1, x) = max(V(k - 1, x), Q(x, a));
            end
        end
        
        if k == K + 1
            break
        end

        for x = 1 : S
            for a = 1 : A
                Q(x, a) = 0;
                for y = 1 : S
                    Q(x, a) += dynamics(x, y, a) * V(k - 1, y);
                end 
                Q(x, a) = reward(x, a) + gamma * Q(x, a);
            end
        end
    end
end