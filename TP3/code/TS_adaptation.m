function [rew, draws] = TS_adaptation(R, MAB)
    rew = zeros(R, 1);
    draws = zeros(R, 1);
    nbArms = length(MAB);
    
    N = zeros(nbArms, 1);
    S = zeros(nbArms, 1);
    
    for r = 1 : R
        arm_best = 1;
        value_best = armBeta(S(arm_best) + 1, N(arm_best) - S(arm_best) + 1).sample();
        for arm = 2 : nbArms
            value = armBeta(S(arm) + 1, N(arm) - S(arm) + 1).sample();
            if value > value_best
                value_best = value;
                arm_best = arm;
            end
        end
        
        draws(r) = arm_best;
        rew(r) = MAB{arm_best}.sample();
        rew_update = armBernoulli(rew(r)).sample();
        N(arm_best) += 1;
        S(arm_best) += rew_update;
    end
end