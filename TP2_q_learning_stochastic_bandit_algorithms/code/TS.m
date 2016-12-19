function [rew, draws] = TS(T, MAB)
    rew = zeros(T, 1);
    draws = zeros(T, 1);
    nbArms = length(MAB);
    
    N = zeros(nbArms, 1);
    S = zeros(nbArms, 1);
    
    for t = 1 : T
        arm_best = 1;
        value_best = armBeta(S(arm_best) + 1, N(arm_best) - S(arm_best) + 1).sample();
        for arm = 2 : nbArms
            value = armBeta(S(arm) + 1, N(arm) - S(arm) + 1).sample();
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