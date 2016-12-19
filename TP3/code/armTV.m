classdef armTV < handle
    % % arm of a soda strategy parametrized by T and V
    
    properties
        T % parameter T (of length 3)
        V % parameter V (of length 3)
        s % simulator
    end
    
    methods
        function self = armTV(T, V, s)
            self.T = T;
            self.V = V;
            self.s = s;
        end
        
        function [reward] = sample(self)
            % return a sample from the arm
            self.s.reset();
            reward = 0;
            while self.s.n_energy > 0 && self.s.n_nosugar > 0
                discount = soda_strategy_param(self.s.n_energy, self.s.n_nosugar, self.T, self.V);
                reward += self.s.simulate(discount);
            end
            % normalize the reward
            reward /= 100;
        end
                
    end    
end