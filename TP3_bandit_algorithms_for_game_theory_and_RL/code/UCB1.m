function [rew, draws] = UCB1(R, MAB)
    rew = zeros(R, 1);
    draws = zeros(R, 1);
    nbArms = length(MAB);
    
    N = zeros(nbArms, 1);
    S = zeros(nbArms, 1);
    
    for r = 1 : min(R, nbArms)
        draws(r) = r;
        rew(r) = MAB{r}.sample();
        N(r) += 1;
        S(r) += rew(r);
    end
    
    for r = nbArms + 1 : R
        arm_best = 1;
        value_best = S(arm_best) / N(arm_best) + sqrt(log(r) / (2 * N(arm_best)));
        for arm = 2 : nbArms
            value = S(arm) / N(arm) + sqrt(log(r) / (2 * N(arm)));
            if value > value_best
                value_best = value;
                arm_best = arm;
            end
        end
        
        draws(r) = arm_best;
        rew(r) = MAB{arm_best}.sample();
        N(arm_best) += 1;
        S(arm_best) += rew(r);
    end
end