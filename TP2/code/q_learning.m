function [pi_N, r_N] = q_learning(N, T_max, epsilon, gamma, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)
    S = max_height + 1;
    pi_N = zeros(N, S);
    r_N = zeros(N, 1);
    [dynamics, reward] = tree_MDP(max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
    occ = zeros(S, A);
    epsilon_p = [1 - epsilon, epsilon];
    uniform_p = zeros(A, 1);
    uniform_p(1 : A) = 1. / A;
    
    Q = zeros(S, A);
    for n = 1 : N
        x_current = 1;
        for t = 1 : T_max
            % choose next action
            a_current = 0;
            if simu(epsilon_p) == 1
                a_max = 1;
                Q_a_max = Q(x_current, a_max);
                for a = 2 : A
                    if (Q(x_current, a) > Q_a_max)
                        a_max = a;
                        Q_a_max = Q(x_current, a);
                    end
                end
                a_current = a_max;
            else
                a_current = simu(uniform_p);
            end
            
            % update the occurence table
            occ(x_current, a_current)++;
            
            % simulate next state and reward
            [x_next, r_current] = tree_sim(x_current, a_current, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price);
            
            r_N(n) += r_current;
            
            % compute the temporal difference
            Q_a_max = Q(x_next, 1);
            for a = 2 : A
                if (Q(x_next, a) > Q_a_max)
                    Q_a_max = Q(x_next, a);
                end
            end
            delta_current = r_current + gamma * Q_a_max - Q(x_current, a_current);
            
            % update the Q-function
            Q(x_current, a_current) += delta_current / occ(x_current, a_current);
            
            x_current = x_next;
        end
        
        % compute the current best policy
        for x = 1 : S
            a_max = 1;
            Q_a_max = Q(x, a_max);
            for a = 2 : A
                if (Q(x, a) > Q_a_max)
                    a_max = a;
                    Q_a_max = Q(x, a);
                end
            end
            pi_N(n, x) = a_max;
        end
    end
end