function [ActionsA, ActionsB, Rew] = EXP3vEXP3(n, eta, beta, G)
    ActionsA = zeros(n, 1);
    ActionsB = zeros(n, 1);
    Rew = zeros(n, 1);
    
    [nbActionsA, nbActionsB] = size(G);
    EXP3_A = EXP3(eta, beta, nbActionsA);
    EXP3_B = EXP3(eta, beta, nbActionsB);
    for i = 1 : n
        ActionsA(i) = EXP3_A.play();
        ActionsB(i) = EXP3_B.play();
        Rew(i) = G(ActionsA(i), ActionsB(i));
        EXP3_A = EXP3_A.getReward(ActionsA(i), Rew(i));
        EXP3_B = EXP3_B.getReward(ActionsB(i), -Rew(i));
    end
end