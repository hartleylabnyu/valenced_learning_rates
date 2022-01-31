%% KN
% Likelihood function for decay model

function [lik, latents] = decay_one_alpha_one_eta_lik(block, choices, keys, rewards, x, priors)

beta = x(1);
choice_c = x(2);
alpha_init = x(3);
eta = x(4);

% Initialize log likelihood at 0
lik = 0;

% Loop through trials
for trial = 1:length(choices)
    
    % At the start of each block, initialize value estimates and stickiness
    % indicators
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
    ev = exp(beta.*val_ests + choice_c .* choice_stick); %multiply inverse temperature * value estimates and exponentiate
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
    
    %determine the trial number within the block
    if trial < 101
        trial_num = trial;
    elseif trial > 100
        trial_num = trial - 100;
    end

    %determine alpha
    alpha = alpha_init / (1 + eta * (trial_num-1));
    
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
lik= lik+log(pdf('beta', alpha_init, 1.1,1.1));
lik= lik+log(pdf('beta', eta, 1.1, 1.1));
lik= lik+log(pdf('gam', beta, 1.2, 5));
lik= lik+lognpdf(choice_c, 0, 3);
end


%flip sign of loglikelihood (which is negative, and we want it to be as close to 0 as possible) so we can enter it into fmincon, which searches for minimum, rather than maximum values
lik = -lik;

