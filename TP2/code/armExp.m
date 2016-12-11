classdef armExp < handle
    % arm with trucated exponential distribution
    
    properties
        lambda % parameter of the exponential distribution
        mean % expectation of the arm
        var % variance of the arm 
    end
    
    methods
        function self = armExp(lambda)
            self.lambda = lambda;
            self.mean = (1 / lambda) * (1 - lambda * exp(-lambda) / (1 - exp(-lambda)));
            self.var = (-exp(-lambda) + 2. / (lambda * lambda) * (1 - exp(-lambda) - lambda * exp(-lambda))) / (1 - exp(-lambda)) - self.mean * self.mean;
        end
        
        function [reward] = sample(self)
            reward = -1 / self.lambda * log(1 - (1 - exp(-self.lambda)) * rand);
        end
                
    end    
end