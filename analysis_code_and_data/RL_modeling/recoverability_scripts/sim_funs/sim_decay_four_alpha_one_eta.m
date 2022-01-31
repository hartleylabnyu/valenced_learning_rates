
function [choices, rewards, blocks, latents] = sim_decay_four_alpha_one_eta(task_struct, params)

%get task structure data
num_blocks = task_struct.num_blocks;
num_block_trials = task_struct.num_block_trials;

%get block order
block_order = task_struct.block_order;

%get params
beta = params(1);
choice_c = params(2);
alpha_init_pos_risk_good = params(3);
alpha_init_neg_risk_good = params(4);
alpha_init_pos_risk_bad = params(5);
alpha_init_neg_risk_bad = params(6);
eta = params(7);

%initialize choices
choices = zeros(num_blocks * num_block_trials, 1);
rewards = zeros(num_blocks * num_block_trials, 1);
blocks = zeros(num_blocks * num_block_trials, 1);

%loop through blocks and trials
for block = 1:num_blocks % loop through two blocks
    val_ests = zeros(1, 4); % Initialize values for each subject at beginning of block
    choice_stick = [0 0 0 0]; % Initialize choice stick at beginning of each block

    if block_order == 2 %risk bad first
        if block == 1
            deck_outcomes = task_struct.deck_outcomes(1:4, :); %risk bad 
            alpha_init_pos = alpha_init_pos_risk_bad;
            alpha_init_neg = alpha_init_neg_risk_bad;
        elseif block == 2
            deck_outcomes = task_struct.deck_outcomes(5:8, :); %risk good
            alpha_init_pos = alpha_init_pos_risk_good;
            alpha_init_neg = alpha_init_neg_risk_good;
        end
    else %risk bad second
        if block == 2
            deck_outcomes = task_struct.deck_outcomes(1:4, :); %risk bad 
            alpha_init_pos = alpha_init_pos_risk_bad;
            alpha_init_neg = alpha_init_neg_risk_bad;
        elseif block == 1
            deck_outcomes = task_struct.deck_outcomes(5:8, :); %risk good
            alpha_init_pos = alpha_init_pos_risk_good;
            alpha_init_neg = alpha_init_neg_risk_good;
        end
    end
    
 
    %loop through trials
    for trial = 1:num_block_trials
        
        % Determine choice probabilities
        ev = exp(beta.*val_ests + choice_c.*choice_stick); %multiply inverse temperature * value estimates and exponentiate
        sev = sum(ev);
        choice_probs = ev/sev; %divide values by sum of all values so the probabilities sum to 1
        
        % Coin flip to determine which machine to choose
        rand_num = rand(1); %generate random number between 0 and 1;
        
        if rand_num < choice_probs(1)
            choice = 1;
        elseif rand_num < choice_probs(1) + choice_probs(2)
            choice = 2;
        elseif rand_num < choice_probs(1) + choice_probs(2)  + choice_probs(3)
            choice = 3;
        else
            choice = 4;
        end
        
        %update choice stick
        choice_stick(choice) = 1;
        
        % Randomly select card based on choice
        reward = datasample(deck_outcomes(choice,:), 1); %datasample function randomly samples from vector
        
        % Compute prediction error based on reward
        pe = reward - val_ests(choice);
        
        % determine alpha init and eta
        if pe > 0
            alpha_init = alpha_init_pos;
        elseif pe < 0
            alpha_init = alpha_init_neg;
        end
        
        %determine learning rate (alpha)
        alpha = alpha_init /(1 + eta * (trial - 1));
        
        %update value estimates
        val_ests(choice) = val_ests(choice) + alpha * pe;

        %save trial information
        choices(trial + (block - 1) * num_block_trials) = choice;
        rewards(trial + (block - 1) * num_block_trials) = reward;
        blocks(trial + (block - 1) * num_block_trials) = block;
        latents.pe(trial+ (block - 1) * num_block_trials) = pe;
        latents.val_ests(trial+ (block - 1) * num_block_trials, :) = val_ests;
        latents.block_order = block_order;
        latents.alpha_pos(trial+ (block - 1) * num_block_trials) = alpha;
        latents.alpha_neg(trial+ (block - 1) * num_block_trials) = alpha;
        
    end
end





