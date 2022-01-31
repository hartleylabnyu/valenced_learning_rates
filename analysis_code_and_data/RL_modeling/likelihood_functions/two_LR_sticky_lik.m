%% KN
% Likelihood function for two LR model

function [lik, latents] = two_LR_sticky_lik(block, choices, keys, rewards, x, priors)

beta = x(1);
choice_c = x(2);
alpha_pos = x(3);
alpha_neg = x(4);

% Initialize log likelihood at 0
lik = 0;


% Loop through trials
for trial = 1:length(choices)
    
    % At the start of each block, initialize value estimates
    if trial == 1
        val_ests = zeros(1, 4);
        choice_stick = [0 0 0 0];
    elseif block(trial) ~= block(trial - 1)
        val_ests = zeros(1, 4);
        choice_stick = [0 0 0 0];
    else
        choice_stick(choices(trial-1)) = 1;
    end
   
    
    % Determine choice probabilities
    ev = exp(beta.*val_ests + choice_c.*choice_stick); %multiply inverse temperature * value estimates and exponentiate
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
        val_ests(trial_choice) = val_ests(trial_choice) + alpha_pos * PE; 
    else
        val_ests(trial_choice) = val_ests(trial_choice) + alpha_neg * PE;
    end
    
    %Save PE, val ests, learning rates on every trial
    latents.PE(trial) = PE;
    latents.val_ests(trial,:) = val_ests;
    latents.alpha_pos(trial) = alpha_pos;
    latents.alpha_neg(trial) = alpha_neg;
    latents.block(trial) = block(trial);
     
end

% Put priors on parameters
if (priors)
lik= lik+log(pdf('beta', alpha_pos, 1.1,1.1));
lik= lik+log(pdf('beta', alpha_neg, 1.1,1.1));
lik= lik+log(pdf('gam', beta, 1.2, 5));
lik= lik+lognpdf(choice_c, 0, 3);
end

%flip sign of loglikelihood (which is negative, and we want it to be as close to 0 as possible) so we can enter it into fmincon, which searches for minimum, rather than maximum values
lik = -lik;

