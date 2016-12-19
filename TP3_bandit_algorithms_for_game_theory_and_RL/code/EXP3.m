classdef EXP3 < handle
    % EXP 3 strategy
    
    properties
        nbActions
        eta
        beta
        w 
    end
    
    methods
        
        function self = EXP3(eta, beta, nbActions)
            self.nbActions = nbActions;
            self.eta = eta;
            self.beta = beta;
            self.w = ones(1, self.nbActions);
        end
        
        function self = init(self)
            self.w = ones(1, self.nbActions);
        end
        
        function [action] = play(self)
           % use the weights to choose an action to play
           W = sum(self.w);
           p_hat = zeros(1, self.nbActions);
           for a = 1:(self.nbActions)
              p_hat(a) = (1 - self.beta) * self.w(a) / W + self.beta / self.nbActions;
           end
           
           action = simu(p_hat);
           
        end
        
        function self = getReward(self, arm, reward)
            % update the weights given the arm drawn and the reward observed
            p_hat_arm = (1 - self.beta) * self.w(arm) / sum(self.w) + self.beta / self.nbActions;
            self.w(arm) *= exp(self.eta * reward / p_hat_arm);
        end

    end    
end