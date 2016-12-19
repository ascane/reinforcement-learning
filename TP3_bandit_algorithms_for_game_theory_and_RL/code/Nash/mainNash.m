n = 10000;
eta = 0.01;
beta = 0.01;

G = [2, -1; 0, 1];

[ActionsA, ActionsB, Rew] = EXP3vEXP3(n, eta, beta, G);


% Compute the average number of choosing action 1 for AnbOnesA = zeros(n, 1);
if ActionsA(1) == 1
    nbOnesA(1) = 1;
end
for i = 2 : n
    nbOnesA(i) = nbOnesA(i - 1);
    if ActionsA(i) == 1
        nbOnesA(i) += 1;
    end
end

avgNbOnesA = zeros(n, 1);
for i = 1 : n
    avgNbOnesA(i) = double(nbOnesA(i)) / i;
end

% Compute the average number of choosing action 1 for B
nbOnesB = zeros(n, 1);
if ActionsB(1) == 1
    nbOnesB(1) = 1;
end
for i = 2 : n
    nbOnesB(i) = nbOnesB(i - 1);
    if ActionsB(i) == 1
        nbOnesB(i) += 1;
    end
end

avgNbOnesB = zeros(n, 1);
for i = 1 : n
    avgNbOnesB(i) = double(nbOnesB(i)) / i;
end

plot(1 : n, avgNbOnesA, 1 : n, avgNbOnesB)
title('Convergence of average number of choosing action 1')
xlabel('Time series')
ylabel('Average number of choosing action 1')
legend('A', 'B', 'Location', 'southeast')

% Compute the average reward for A
avgRew = cumsum(Rew);
for i = 1 : n
    avgRew(i) /= i;
end
plot(1 : n, avgRew)
title('Average reward for A')
xlabel('Time series')
ylabel('Average reward')
