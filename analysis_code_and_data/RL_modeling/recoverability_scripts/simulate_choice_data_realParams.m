%% Simulate choices %%
clear all;
rng shuffle;

%% Variables to modify

%determine models to simulate
models = {'decay_four_alpha_four_eta'};

% Data name
save_filename = '../output/mat_files/sim_decay2_data_realParams';

%number of subjects
num_subs = 142;

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

%% Models to simulate
addpath('sim_funs');

%how many times should each parameter combo be repeated
num_reps = 100;

%initialize data structure
sim_data(length(models)) = struct();

%% Loop through models
for m = 1:length(models)
    model_to_simulate = models{m};
    
    %get dataset to sample from
    params_data_name = ['../output/model_fits_real_data/mat_files/fit_', models{m}];
    load(params_data_name);
    params = model_fit.results.params;
    sim_ages = model_fit.results.age;
    sim_subs = model_fit.results.sub;
    num_subs = length(model_fit.results.sub);
    block_order = model_fit.results.block_order;
    function_name = ['sim_', models{m}];
    if strcmp(function_name,'sim_one_LR') == 1
        param_names = {'beta', 'alpha'};
    elseif strcmp(function_name,'sim_one_LR_sticky') == 1
        param_names = {'beta', 'choice_c', 'alpha'};
    elseif strcmp(function_name,'sim_two_LR') == 1
        param_names = {'beta', 'alpha_pos', 'alpha_neg'};
    elseif strcmp(function_name,'sim_four_LR') == 1
        param_names = {'beta', 'alpha_pos_risk_good', 'alpha_neg_risk_good','alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
    elseif strcmp(function_name,'sim_four_LR_sticky') == 1
        param_names = {'beta', 'choice_c', 'alpha_pos_risk_good', 'alpha_neg_risk_good','alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
    elseif strcmp(function_name,'sim_four_LR_sticky') == 1
        param_names = {'beta', 'choice_c', 'alpha_pos_risk_good', 'alpha_neg_risk_good','alpha_pos_risk_bad', 'alpha_neg_risk_bad'};
    elseif strcmp(function_name,'sim_decay_two_alpha_four_eta') == 1
        param_names = {'beta', 'choice_c', 'alpha_init_pos', 'alpha_init_neg','eta_pos_risk_good', 'eta_neg_risk_good', 'eta_pos_risk_bad', 'eta_neg_risk_bad'};
    elseif strcmp(function_name,'sim_decay_four_alpha_two_eta') == 1
        param_names = {'beta', 'choice_c', 'alpha_init_pos_risk_good', 'alpha_init_neg_risk_good', 'alpha_init_pos_risk_bad', 'alpha_init_neg_risk_bad','eta_pos', 'eta_neg'};
     elseif strcmp(function_name,'sim_decay_four_alpha_four_eta') == 1
        param_names = {'beta', 'choice_c', 'alpha_init_pos_risk_good', 'alpha_init_neg_risk_good', 'alpha_init_pos_risk_bad', 'alpha_init_neg_risk_bad','eta_pos_risk_good', 'eta_neg_risk_good', 'eta_pos_risk_bad', 'eta_neg_risk_bad'};
    end
    
    %initialize structure
    clear model_data;
    model_data(num_subs + (num_reps-1)*num_subs) = struct();
    
    %print message about which subject is being fit
    fprintf('Simulating model %d out of %d...\n', m, length(models));
    
    % determine function
    fh = str2func(function_name);
    
    %loop through subjects and generate data
    for r = 1:num_reps
        for s = 1:num_subs
            task_struct.block_order = block_order(s);
            [choices, rewards, block, latents] = fh(task_struct, params(s, :));
            model_data(s + (r-1)*num_subs).params = params(s, :);
            model_data(s + (r-1)*num_subs).choices = choices;
            model_data(s + (r-1)*num_subs).rewards = rewards;
            model_data(s + (r-1)*num_subs).block = block;
            model_data(s + (r-1)*num_subs).latents = latents;
            model_data(s + (r-1)*num_subs).age = sim_ages(s);
            model_data(s + (r-1)*num_subs).sub_id = sim_subs(s);
        end
    end
    
    sim_data(m).sub_data = model_data;
    sim_data(m).function = function_name;
    sim_data(m).n_params = size(params, 2);
    sim_data(m).param_names = param_names;
    
end

save(save_filename, 'sim_data');
