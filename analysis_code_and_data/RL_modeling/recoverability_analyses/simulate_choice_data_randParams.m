%% Simulate choices %%
clear all;
rng shuffle;

%% Variables to modify
%determine models to simulate
models = {'one_LR', 'two_LR', 'four_LR'};

% Data name
save_filename = '../output/sim_LR_data_randParams';

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
    beta = .19 + (30 - .19) *rand(1, num_subs); %uniform distribution from .19 to 30
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % MODELS TO SIMULATE %
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(model_to_simulate, 'one_LR')
        alpha = rand(1, num_subs);
        params = [beta', alpha'];
        param_names = {'beta', 'alpha'};
        function_name = 'sim_one_LR';
        
    elseif strcmp(model_to_simulate, 'two_LR')
        alpha_pos = rand(1, num_subs);
        alpha_neg = rand(1, num_subs);
        params = [beta', alpha_pos', alpha_neg'];
        param_names = {'beta','alpha_pos', 'alpha_neg'};
        function_name = 'sim_two_LR';
        
    elseif strcmp(model_to_simulate, 'four_LR')
        alpha_pos_risk_good = rand(1, num_subs);
        alpha_neg_risk_good = rand(1, num_subs);
        alpha_pos_risk_bad = rand(1, num_subs);
        alpha_neg_risk_bad = rand(1, num_subs);
        params = [beta', alpha_pos_risk_good', alpha_neg_risk_good', alpha_pos_risk_bad', alpha_neg_risk_bad'];
        param_names = {'beta', 'alpha_pos_risk_good', 'alpha_neg_risk_good', 'alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
        function_name = 'sim_four_LR';
    end
    
    % determine function
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
