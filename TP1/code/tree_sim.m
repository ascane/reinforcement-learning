function [state, reward] = tree_sim(current_state, action, max_height, A, sick_prob, growth, maintenance_cost, planting_cost, sell_price)
    S = max_height + 1;
    state_sick = max_height + 1;
    
    dynamics = zeros(S, 1);
    
    %%% action = keep
    if action == 1
        if current_state < max_height
            for diff_height = 1 : (max_height-current_state)
                dynamics(current_state + diff_height) = (1 - sick_prob) * growth(current_state, diff_height);
            end
            dynamics(state_sick) = sick_prob;   
        elseif current_state == max_height
            dynamics(max_height) = 1 - sick_prob;
            dynamics(state_sick) = sick_prob;
        else 
            dynamics(state_sick) = 1.0;
        end
        
    %%% action = cut
    else
        dynamics(1) = 1.0;
    end
    
    state = simu(dynamics);
    reward = 0;
    
    %%% action = keep
    if action == 1
        if current_state <= max_height
            reward = -maintenance_cost;
        end
        
    %%% action = cut
    else
        if current_state <= max_height
            reward = sell_price * current_state - planting_cost;
        else
            reward = -planting_cost;
        end
    end
end
