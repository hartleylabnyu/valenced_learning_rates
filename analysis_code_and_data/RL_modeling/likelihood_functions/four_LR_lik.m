%% KN
% Likelihood function for Four LR model

function [lik, latents] = four_LR_lik(block, choices, keys, rewards, x, priors)

beta = x(1);
alpha_pos_risk_good = x(2);
alpha_neg_risk_good = x(3);
alpha_pos_risk_bad = x(4);
alpha_neg_risk_bad = x(5);

%initialize
alpha_pos = 0;
alpha_neg = 0;

% Initialize log likelihood at 0
lik = 0;

% Loop through trials
for trial = 1:length(choices)
    
    % At the start of each block, initialize value estimates
    if trial == 1
        val_ests = zeros(1, 4);
        key_stick = [0 0 0 0];
    elseif block(trial) ~= block(trial - 1)
        val_ests = zeros(1, 4);
        key_stick = [0 0 0 0];
    else
        key_stick(keys(trial-1)) = 1; %put 1 on key from previous trial
    end
   
    
    % Determine choice probabilities
    ev = exp(beta.*val_ests); %multiply inverse temperature * value estimates and exponentiate
    sev = sum(ev);
    choice_probs = ev/sev; %divide values by sum of all values so the probabilities sum to 1
    
    % Determine the choice the participant actually made on this trial
    trial_choice = choices(trial);
    
    %Determine the probability that the participant made the choice they
    %made
    lik_choice = choice_probs(trial_choice);
    
    %update log likelihood
    lik = lik + log(lik_choice);
    
    % Get the reward the participant received on this trial
    trial_reward = rewards(trial);
    
    %Compute  prediction error
    PE = trial_reward - val_ests(trial_choice);
    
    % Update value estimates for next trial
    if PE > 0
        if block(trial) == 1
            alpha_pos = alpha_pos_risk_good;
        else
            alpha_pos = alpha_pos_risk_bad;
        end
        val_ests(trial_choice) = val_ests(trial_choice) + alpha_pos * PE;
    else
        if block(trial) == 1
            alpha_neg = alpha_neg_risk_good;
        else
            alpha_neg = alpha_neg_risk_bad;
        end
        val_ests(trial_choice) = val_ests(trial_choice) + alpha_neg * PE;
    end
    
    %Save PE, val ests, learning rates on every trial
    latents.PE(trial) = PE;
    latents.val_ests(trial,:) = val_ests;
    latents.alpha_pos(trial) = alpha_pos;
    latents.alpha_neg(trial) = alpha_neg;
    latents.block(trial) = block(trial);
    
    
end

% % Put priors on parameters
if (priors)
lik= lik+log(pdf('beta', alpha_pos_risk_good, 1.1,1.1));
lik= lik+log(pdf('beta', alpha_neg_risk_good, 1.1,1.1));
lik= lik+log(pdf('beta', alpha_pos_risk_bad, 1.1,1.1));
lik= lik+log(pdf('beta', alpha_neg_risk_bad, 1.1,1.1));
lik= lik+log(pdf('gam', beta, 1.2, 5));
%lik= lik+lognpdf(key_c, 0, 3);
end

%empirical priors from Gershman 2016
% lik= lik+log(pdf('beta', alpha_pos1, .01, .032));
% lik= lik+log(pdf('beta', alpha_neg1, .012, .021));
% lik= lik+log(pdf('beta', alpha_pos2, .01, .032));
% lik= lik+log(pdf('beta', alpha_neg2, .012, .021));
% lik= lik+lognpdf(key_c, .15, 1.42);
% lik= lik+lognpdf(choice_c, .15, 1.42);
% lik= lik+log(pdf('gam', beta, 4.82, 0.88));


%flip sign of loglikelihood (which is negative, and we want it to be as close to 0 as possible) so we can enter it into fmincon, which searches for minimum, rather than maximum values
lik = -lik;

