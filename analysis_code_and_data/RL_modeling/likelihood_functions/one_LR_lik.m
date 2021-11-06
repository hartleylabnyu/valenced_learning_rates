%% KN
% Likelihood function for one LR model

function [lik, latents] = one_LR_lik(block, choices, keys, rewards, x, priors)

beta = x(1);
alpha = x(2);

% Initialize log likelihood at 0
lik = 0;

% Loop through trials
for trial = 1:length(choices)
    
    % At the start of each block, initialize value estimates and stickiness
    % indicators
    if trial == 1
        val_ests = zeros(1, 4);
        key_stick = [0 0 0 0];
        choice_stick = [0 0 0 0];
    elseif block(trial) ~= block(trial - 1)
        val_ests = zeros(1, 4);
        key_stick = [0 0 0 0];
        choice_stick = [0 0 0 0];
    else
        key_stick(keys(trial-1)) = 1;
        choice_stick(choices(trial-1)) = 1;
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
    val_ests(trial_choice) = val_ests(trial_choice) + alpha * PE;  
    
    %Save PE, val ests, learning rates on every trial
    latents.PE(trial) = PE;
    latents.val_ests(trial,:) = val_ests;
    latents.alpha_pos(trial) = alpha;
    latents.alpha_neg(trial) = alpha;
    latents.block(trial) = block(trial);
end

% Put priors on parameters
if (priors)
lik= lik+log(pdf('beta', alpha, 1.1,1.1));
lik= lik+log(pdf('gam', beta, 1.2, 5));
%lik= lik+lognpdf(key_c, 0, 3);
end


%flip sign of loglikelihood (which is negative, and we want it to be as close to 0 as possible) so we can enter it into fmincon, which searches for minimum, rather than maximum values
lik = -lik;

