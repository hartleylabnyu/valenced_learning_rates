%% Simulate choices %%
clear all;
rng shuffle;

%% Variables to modify
%determine models to simulate
models = {'four_LR_sticky'};

% Data name
save_filename = '../output/sim_4LR_sticky';

%number of subjects
num_subs = 1000;

%% Task structure
num_block_trials = 100;
num_blocks = 2;
num_trials = num_block_trials * 2;

risk_bad_deck_outcomes = [180, 190, 200, -230, -240, -250;
    180, 190, 200, -230, -240, -250;
    100, 110, 120, -50, -60, -70;
    100, 110, 120, -50, -60, -70] ./260;

risk_good_deck_outcomes = [240, 250, 260, -190, -200, -210;
    240, 250, 260, -190, -200, -210;
    40, 50, 60, -90, -100, -110;
    40, 50, 60, -90, -100, -110] ./ 260;

task_struct.deck_outcomes = [risk_bad_deck_outcomes; risk_good_deck_outcomes];
task_struct.num_blocks = num_blocks;
task_struct.num_block_trials = num_block_trials;

%define arbitrary block order for each participant
block_order = datasample(1:2, num_subs);

%% Models to simulate
addpath('sim_funs');

%% initialize structure
sim_data(length(models)) = struct();

%% Loop through models
for m = 1:length(models)
    model_to_simulate = models{m};
    
    clear model_data;
    model_data(num_subs) = struct();
    
    %print message about which subject is being fit
    fprintf('Simulating model %d out of %d...\n', m, length(models));
    
    % generate parameters for each model
    beta = .15 + (30 - .15) *rand(1, num_subs); %uniform distribution from .15 to 30
    choice_c = -10 + 20 *rand(1, num_subs); %uniform distribution from -10 to 10 (for parameter recovery; used t-distribution for model recovery)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % MODELS TO SIMULATE %
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %baseline models
    if strcmp(model_to_simulate, 'one_LR')
        alpha = rand(1, num_subs);
        params = [beta', alpha'];
        param_names = {'beta', 'alpha'};
        
    elseif strcmp(model_to_simulate, 'two_LR')
        alpha_pos = rand(1, num_subs);
        alpha_neg = rand(1, num_subs);
        params = [beta', alpha_pos', alpha_neg'];
        param_names = {'beta','alpha_pos', 'alpha_neg'};
        
    elseif strcmp(model_to_simulate, 'four_LR')
        alpha_pos_risk_good = rand(1, num_subs);
        alpha_neg_risk_good = rand(1, num_subs);
        alpha_pos_risk_bad = rand(1, num_subs);
        alpha_neg_risk_bad = rand(1, num_subs);
        params = [beta', alpha_pos_risk_good', alpha_neg_risk_good', alpha_pos_risk_bad', alpha_neg_risk_bad'];
        param_names = {'beta', 'alpha_pos_risk_good', 'alpha_neg_risk_good', 'alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
        
        
        % models w/ stickiness
    elseif strcmp(model_to_simulate, 'one_LR_sticky')
        alpha = rand(1, num_subs);
        params = [beta', choice_c', alpha'];
        param_names = {'beta', 'choice_c', 'alpha'};
        
    elseif strcmp(model_to_simulate, 'two_LR_sticky')
        alpha_pos = rand(1, num_subs);
        alpha_neg = rand(1, num_subs);
        params = [beta', choice_c', alpha_pos', alpha_neg'];
        param_names = {'beta', 'choice_c', 'alpha_pos', 'alpha_neg'};
        
    elseif strcmp(model_to_simulate, 'four_LR_sticky')
        alpha_pos_risk_good = rand(1, num_subs);
        alpha_neg_risk_good = rand(1, num_subs);
        alpha_pos_risk_bad = rand(1, num_subs);
        alpha_neg_risk_bad = rand(1, num_subs);
        params = [beta', choice_c', alpha_pos_risk_good', alpha_neg_risk_good', alpha_pos_risk_bad', alpha_neg_risk_bad'];
        param_names = {'beta', 'choice_c', 'alpha_pos_risk_good', 'alpha_neg_risk_good', 'alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
        
        
        % decay models
    elseif strcmp(model_to_simulate, 'decay_one_alpha_one_eta')
        alpha_init = rand(1, num_subs);
        eta = rand(1, num_subs);
        params = [beta', choice_c', alpha_init', eta'];
        param_names = {'beta', 'choice_c', 'alpha_init', 'eta'};
        
    elseif strcmp(model_to_simulate, 'decay_two_alpha_one_eta')
        alpha_init_pos = rand(1, num_subs);
        alpha_init_neg = rand(1, num_subs);
        eta = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos', alpha_init_neg', eta'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos', 'alpha_init_neg', 'eta'};
        
    elseif strcmp(model_to_simulate, 'decay_four_alpha_one_eta')
        alpha_init_pos_risk_good = rand(1, num_subs);
        alpha_init_neg_risk_good = rand(1, num_subs);
        alpha_init_pos_risk_bad = rand(1, num_subs);
        alpha_init_neg_risk_bad = rand(1, num_subs);
        eta = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos_risk_good', alpha_init_neg_risk_good', alpha_init_pos_risk_bad', alpha_init_neg_risk_bad', eta'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos_risk_good', 'alpha_init_neg_risk_good', 'alpha_init_pos_risk_bad', 'alpha_init_neg_risk_bad', 'eta'};
        
    elseif strcmp(model_to_simulate, 'decay_one_alpha_two_eta')
        alpha_init = rand(1, num_subs);
        eta_pos = rand(1, num_subs);
        eta_neg = rand(1, num_subs);
        params = [beta', choice_c', alpha_init', eta_pos', eta_neg'];
        param_names = {'beta', 'choice_c', 'alpha_init', 'eta_pos', 'eta_neg'};
        
    elseif strcmp(model_to_simulate, 'decay_two_alpha_two_eta')
        alpha_init_pos = rand(1, num_subs);
        alpha_init_neg = rand(1, num_subs);
        eta_pos = rand(1, num_subs);
        eta_neg = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos', alpha_init_neg', eta_pos', eta_neg'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos', 'alpha_init_neg', 'eta_pos', 'eta_neg'};
        
    elseif strcmp(model_to_simulate, 'decay_four_alpha_two_eta')
        alpha_init_pos_risk_good = rand(1, num_subs);
        alpha_init_neg_risk_good = rand(1, num_subs);
        alpha_init_pos_risk_bad = rand(1, num_subs);
        alpha_init_neg_risk_bad = rand(1, num_subs);
        eta_pos = rand(1, num_subs);
        eta_neg = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos_risk_good', alpha_init_neg_risk_good', alpha_init_pos_risk_bad', alpha_init_neg_risk_bad', eta_pos', eta_neg'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos_risk_good', 'alpha_init_neg_risk_good', 'alpha_init_pos_risk_bad', 'alpha_init_neg_risk_bad', 'eta_pos', 'eta_neg'};
        
     elseif strcmp(model_to_simulate, 'decay_one_alpha_four_eta')
        alpha_init = rand(1, num_subs);
        eta_pos_risk_good = rand(1, num_subs);
        eta_neg_risk_good = rand(1, num_subs);
        eta_pos_risk_bad = rand(1, num_subs);
        eta_neg_risk_bad = rand(1, num_subs);
        params = [beta', choice_c', alpha_init', eta_pos_risk_good', eta_neg_risk_good', eta_pos_risk_bad', eta_neg_risk_bad'];
        param_names = {'beta', 'choice_c', 'alpha_init', 'eta_pos_risk_good', 'eta_neg_risk_good', 'eta_pos_risk_bad', 'eta_neg_risk_bad'};
        
    elseif strcmp(model_to_simulate, 'decay_two_alpha_four_eta')
        alpha_init_pos = rand(1, num_subs);
        alpha_init_neg = rand(1, num_subs);
        eta_pos_risk_good = rand(1, num_subs);
        eta_neg_risk_good = rand(1, num_subs);
        eta_pos_risk_bad = rand(1, num_subs);
        eta_neg_risk_bad = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos', alpha_init_neg', eta_pos_risk_good', eta_neg_risk_good', eta_pos_risk_bad', eta_neg_risk_bad'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos', 'alpha_init_neg', 'eta_pos_risk_good', 'eta_neg_risk_good', 'eta_pos_risk_bad', 'eta_neg_risk_bad'};
        
    elseif strcmp(model_to_simulate, 'decay_four_alpha_four_eta')
        alpha_init_pos_risk_good = rand(1, num_subs);
        alpha_init_neg_risk_good = rand(1, num_subs);
        alpha_init_pos_risk_bad = rand(1, num_subs);
        alpha_init_neg_risk_bad = rand(1, num_subs);
        eta_pos_risk_good = rand(1, num_subs);
        eta_neg_risk_good = rand(1, num_subs);
        eta_pos_risk_bad = rand(1, num_subs);
        eta_neg_risk_bad = rand(1, num_subs);
        params = [beta', choice_c', alpha_init_pos_risk_good', alpha_init_neg_risk_good', alpha_init_pos_risk_bad', alpha_init_neg_risk_bad', eta_pos_risk_good', eta_neg_risk_good', eta_pos_risk_bad', eta_neg_risk_bad'];
        param_names = {'beta', 'choice_c', 'alpha_init_pos_risk_good', 'alpha_init_neg_risk_good', 'alpha_init_pos_risk_bad', 'alpha_init_neg_risk_bad', 'eta_pos_risk_good', 'eta_neg_risk_good', 'eta_pos_risk_bad', 'eta_neg_risk_bad'};    
    end
    
    % determine function
    function_name = ['sim_', model_to_simulate];
    fh = str2func(function_name);
    
    %loop through subjects and generate data
    for s = 1:num_subs
        task_struct.block_order = block_order(s);
        [choices, rewards, block, latents] = fh(task_struct, params(s, :));
        model_data(s).params = params(s, :);
        model_data(s).choices = choices;
        model_data(s).rewards = rewards;
        model_data(s).block = block;
        model_data(s).latents = latents;
    end
    
    sim_data(m).sub_data = model_data;
    sim_data(m).function = function_name;
    sim_data(m).n_params = size(params, 2);
    sim_data(m).param_names = param_names;
    
end

save(save_filename, 'sim_data');
