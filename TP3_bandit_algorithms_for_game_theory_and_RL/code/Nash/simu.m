function [i]= simu(p)
% random drawn under p: P(X=i)=p_i
q = cumsum(p);
u = rand;
i = 1;
while (u > q(i))
    i = i + 1;
end
