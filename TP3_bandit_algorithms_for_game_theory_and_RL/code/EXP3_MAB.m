function [rew, draws] = EXP3_MAB(R, MAB, eta, beta)
    rew = zeros(R, 1);
    draws = zeros(R, 1);
    nbArms = length(MAB);

    EXP3_algo = EXP3(eta, beta, nbArms);
    for r = 1 : R
        draws(r) = EXP3_algo.play();
        rew(r) = MAB{draws(r)}.sample();
        EXP3_algo.getReward(draws(r), rew(r));
    end
    
end