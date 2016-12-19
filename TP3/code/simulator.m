classdef simulator < handle
    % arm with finite support
    
    properties
        state % {0=no-exam, 1=exam}
        p_exam_noexam % probability of transition from an exam to no-exam state
        p_noexam_exam % probability of transition from an no_exam to exam state
        std_price % the price of either soda when no discount is applied
        n_energy % number of energy drink cans
        n_nosugar % number of no sugar cans
    end
    
    methods
        function self = simulator()
            self.p_exam_noexam = 0.7;
            self.p_noexam_exam = 0.3;
            self.std_price = 1.0;
            self.state = 0;
            self.n_energy = 50;
            self.n_nosugar = 50;
        end
        
        function reset(self)
            self.n_energy = 50;
            self.n_nosugar = 50;
            self.state = 0;
        end
        
        function [reward, n_energy, n_nosugar] = simulate(self, discount)
            discount_fraction = discount/self.std_price;
            
            %self.state = 0;
            if (self.state == 0)
                % no-exam situation
                %pref_energy = rand;
                pref_energy = 0.6;
                pref_nosugar = 1 - pref_energy;
                
                
                % apply changes depending on the discount
                if (discount_fraction > 0.0)
                    % the energy drink is discounted
                    pref_energy = pref_energy * exp(2 * discount_fraction * log(1 / pref_energy));
                    pref_nosugar = 1-pref_energy;
                    
                elseif (discount_fraction < 0.0)
                    % the sugar free is discounted
                    pref_nosugar = pref_nosugar * exp(-2 * discount_fraction * log(1 / pref_nosugar));
                    pref_energy = 1 - pref_nosugar;
                end
                
            elseif (self.state == 1)
                % exam situation
                %pref_energy = rand^0.3;
                pref_energy = 0.8;
                pref_nosugar = 1 - pref_energy;
                
                % apply changes depending on the discount
                if(discount_fraction > 0.0)
                    % the energy drink is discounted
                    
                    if (4 * pref_energy > 1.0)
                        pref_energy = pref_energy + (1 - pref_energy) * pref_energy^4;
                    else
                        pref_energy = pref_energy + 3 * pref_energy * pref_energy^4;
                    end
                    pref_nosugar = 1 - pref_energy;
                    
                elseif(discount_fraction < 0.0)
                    % the sugar free is discounted
                    if (4 * pref_nosugar > 1.0)
                        pref_nosugar = pref_nosugar + (1 - pref_nosugar) * pref_nosugar^4;
                    else
                        pref_nosugar = pref_nosugar + 3 * pref_nosugar * pref_nosugar^4;
                    end
                    pref_energy = 1 - pref_nosugar;
                end
            end
            % random user preference
            if (rand < pref_energy)
                % user with preference for energy drink
                reward = self.std_price - max(discount,0);
                self.n_energy = self.n_energy - 1;
            else
                % user with preference for energy drink
                reward = self.std_price + min(discount,0);
                self.n_nosugar = self.n_nosugar - 1;
            end
            
            % evolution of the state of the environment
            if (self.state == 0 && rand < self.p_noexam_exam)
                self.state = 1;
            elseif (self.state == 1 && rand < self.p_exam_noexam)
                self.state = 0;
            end
            
            n_energy = self.n_energy;
            n_nosugar = self.n_nosugar;
        end
        
    end
end