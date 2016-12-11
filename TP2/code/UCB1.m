function [rew, draws] = UCB1(T, MAB)
    rew = zeros(T, 1);
    draws = zeros(T, 1);
    nbArms = length(MAB);
    
    N = zeros(nbArms, 1);
    S = zeros(nbArms, 1);
    
    for t = 1 : min(T, nbArms)
        draws(t) = t;
        rew(t) = MAB{t}.sample();
        N(t) += 1;
        S(t) += rew(t);
    end
    
    for t = nbArms + 1 : T
        arm_best = 1;
        value_best = S(arm_best) / N(arm_best) + sqrt(log(t) / (2 * N(arm_best)));
        for arm = 2 : nbArms
            value = S(arm) / N(arm) + sqrt(log(t) / (2 * N(arm)));
            if value > value_best
                value_best = value;
                arm_best = arm;
            end
        end
        
        draws(t) = arm_best;
        rew(t) = MAB{arm_best}.sample();
        N(arm_best) += 1;
        S(arm_best) += rew(t);
    end
end