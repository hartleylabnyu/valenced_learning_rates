%% Simulate choices %%
clear all;
rng shuffle;

%% Variables to modify
% Data name
save_filename = '../output/sim_2LR_data_setParams';

%% Task structure
num_block_trials = 100;
num_blocks = 2;
num_trials = num_block_trials * 2;
num_subs = 10000;

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
sim_data(1) = struct();

%% Create parameter comibinations
alpha_pos = linspace(.05, .95, 10);
alpha_neg = linspace(.05, .95, 10);
alpha_vals = combvec(alpha_pos, alpha_neg)';
alpha_vals = repmat(alpha_vals, 100, 1);
beta = 2 + (30 - 2) *rand(1, num_subs); %uniform distribution from 2 to 30
params = [beta', alpha_vals];
param_names = {'beta','alpha_pos', 'alpha_neg'};
function_name = 'sim_two_LR';


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

sim_data.sub_data = model_data;
sim_data.function = function_name;
sim_data.n_params = size(params, 2);
sim_data.param_names = param_names;

save(save_filename, 'sim_data');
