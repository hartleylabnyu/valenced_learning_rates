%% Fit models to choice data: Casino card task %%
% Kate Nussenbaum - katenuss@nyu.edu

% clear everything
clear;

% load path to likelihood functions
addpath('likelihood_functions/');

% load data
data = readtable('../data/other_data_files/matlab_choice_data.csv');

%determine the number of subjects
sub_list = unique(data.matlab_id);
n_subjects = length(sub_list);

%% VARIABLES TO MODIFY %%
% save filename
filename = 'output/model_fits/choice_data_fits_test';

% How many iterations to run per participant
niter = 10;

% models to fit
models = {'1L'};
%models = {'1L', '2L', '4L', '1LS', '2LS', '4LS', 'decay1a1e', 'decay1a2e', 'decay1a4e', ...
%    'decay2a1e', 'decay2a2e', 'decay2a4e', 'decay4a1e', 'decay4a2e', 'decay4a4e'};

%preallocate structure
model_fits(length(models)) = struct();

%% FIT MODELS TO DATA %%
%----------------------------------%
% Loop through models and subjects %
%----------------------------------%

for m = 1:length(models)
    model_to_fit = models{m};
    
    %print message about which subject is being fit
    fprintf('Fitting model %d out of %d...\n', m, length(models))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model-specific info %
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Baseline models
    if strcmp(model_to_fit, '1L')
        n_params = 2; %beta, alpha
        lb = [1e-6, 1e-6];
        ub = [30, 1];
        function_name = 'one_LR_lik';
    elseif strcmp(model_to_fit, '2L')
        n_params = 3; %beta, alpha pos, alpha neg
        lb = [1e-6, 1e-6, 1e-6];
        ub = [30, 1, 1];
        function_name = 'two_LR_lik';
    elseif strcmp(model_to_fit, '4L')
        n_params = 5; %beta,  alpha_pos_risk_good, alpha_neg_risk_good, alpha_pos_risk_bad, alpha_neg_risk_bad
        lb = [1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 1, 1, 1, 1];
        function_name = 'four_LR_lik';
        
    % Models with stickiness
    elseif strcmp(model_to_fit, '1LS')
        n_params = 3; %beta, sticky, alpha
        lb = [1e-6, -10, 1e-6];
        ub = [30, 10, 1];
        function_name = 'one_LR_sticky_lik';
    elseif strcmp(model_to_fit, '2LS')
        n_params = 4; %beta, sticky, alpha_pos, alpha_neg
        lb = [1e-6, -10, 1e-6, 1e-6];
        ub = [30, 10, 1, 1];
        function_name = 'two_LR_sticky_lik';
    elseif strcmp(model_to_fit, '4LS')
        n_params = 6; %beta, choice sticky, alpha_pos_risk_good, alpha_neg_risk_good, alpha_pos_risk_bad, alpha_neg_risk_bad
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1];
        function_name = 'four_LR_sticky_lik';
        
   % Models with decaying learning rate and stickiness
    elseif strcmp(model_to_fit, 'decay1a1e')
        n_params = 4; %beta, sticky, alpha_init, eta
        lb = [1e-6, -10, 1e-6, 1e-6];
        ub = [30, 10, 1, 1];
        function_name = 'decay_one_alpha_one_eta_lik';
    elseif strcmp(model_to_fit, 'decay2a1e')
        n_params = 5; %beta, sticky, alpha_init (x2), eta
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1];
        function_name = 'decay_two_alpha_one_eta_lik';
    elseif strcmp(model_to_fit, 'decay4a1e')
        n_params = 7; %beta, sticky, alpha_init (x4), eta
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1, 1];
        function_name = 'decay_four_alpha_one_eta_lik'; 
    elseif strcmp(model_to_fit, 'decay1a2e')
        n_params = 5; %beta, sticky, alpha_init, eta (x2)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1];
        function_name = 'decay_one_alpha_two_eta_lik';
    elseif strcmp(model_to_fit, 'decay2a2e')
        n_params = 6; %beta, sticky, alpha_init (x2), eta (x2)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1];
        function_name = 'decay_two_alpha_two_eta_lik';
    elseif strcmp(model_to_fit, 'decay4a2e')
        n_params = 8; %beta, sticky, alpha_init (x4), eta (x2)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1, 1, 1];
        function_name = 'decay_four_alpha_two_eta_lik';
    elseif strcmp(model_to_fit, 'decay1a4e')
        n_params = 7; %beta, sticky, alpha_init, eta (x4)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1, 1];
        function_name = 'decay_one_alpha_four_eta_lik'; 
    elseif strcmp(model_to_fit, 'decay2a4e')
        n_params = 8; %beta, sticky, alpha_init (x2), eta (x4)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1, 1, 1];
        function_name = 'decay_two_alpha_four_eta_lik';
    elseif strcmp(model_to_fit, 'decay4a4e')
        n_params = 10; %beta, sticky, alpha_init (x4), eta (x4)
        lb = [1e-6, -10, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
        ub = [30, 10, 1, 1, 1, 1, 1, 1, 1, 1];
        function_name = 'decay_four_alpha_four_eta_lik';
    end
    
    
    % convert function name to function
    model_filename = ['output/model_fits/fit_', function_name(1:end-4)];
    fh = str2func(function_name);
    
    % generate matrices to save data
    [logpost, negloglik, AIC, BIC] = deal(nan(n_subjects, 1));
    [params] = nan(n_subjects, n_params);
    
    %determine csv filename for model results
    csv_filename = ['output/model_fits/', function_name(1:end-4), '.csv'];
    
    
    %loop through subjects
    parfor s = 1:n_subjects
        subject = sub_list(s);
        sub_data = data(data.matlab_id == subject, :);
        sub_age = sub_data.age(1);
        sub_block_order = sub_data.block_type_num(1);
        
        %print message about which subject is being fit
        fprintf('Fitting subject %d out of %d...\n', s, n_subjects)
        
        %determine filename for latents
        latents_filename{s} = ['output/model_fits/latents/latents_', function_name(1:end-4), '_', int2str(subject), '.csv'];
        
        for iter = 1:niter  % run niter times from random initial conditions, to get best fit
            
            % choose a random number between the lower and upper bounds to initialize each of the parameters
            starting_points = rand(1,length(lb)).* (ub - lb) + lb; % random initialization
            
            % Run fmincon (unless null model)
            [res,nlp] = ...
                fmincon(@(x) fh(sub_data.block_type_num, sub_data.choices, sub_data.keys, sub_data.rewards, x, 1),...
                starting_points,[],[],[],[],lb, ub,[],...
                optimset('maxfunevals',10000,'maxiter',2000, 'Display', 'off'));
            
            %flip sign to get log posterior (if priors are in models, if no priors, this will be the log likelihood)
            logp = -1 * nlp;
            
            %store results if minimum is found
            if iter == 1 || logpost(s) < logp
                logpost(s) = logp;
                params(s, :) = res;
                [negloglik(s), latents(s)] = fh(sub_data.block_type_num, sub_data.choices, sub_data.keys, sub_data.rewards, res, 0); %fit model w/ 'winning' parameters w/o priors to get the negative log likelihood
                AIC(s) = 2*negloglik(s) + 2*length(res);
                BIC(s) = 2*negloglik(s) + length(res)*log(length(sub_data.choices));
                age(s) = sub_age;
                sub(s) = subject;
                block_order(s) = sub_block_order;
                
                %write latents CSV for each participant
                dlmwrite(latents_filename{s}, [(subject * ones(size(latents(s).PE)))', latents(s).block', latents(s).PE', latents(s).val_ests, latents(s).alpha_pos', latents(s).alpha_neg']);
            end
            
        end
        
    end
    
    results.sub = sub;
    results.age = age;
    results.block_order = block_order;
    results.logpost = logpost;
    results.params = params;
    results.negloglik = negloglik;
    results.AIC = AIC;
    results.BIC = BIC;
    
    %write csv for each model
    dlmwrite(csv_filename, [sub_list, results.negloglik, results.logpost, results.AIC, results.BIC, results.params]);
    
    %save structure for each model
    model_fits(m).results = results;
    model_fits(m).fit_model = model_to_fit;
    
    model_fit = model_fits(m);
    
    %Save fitting results
    save(model_filename, 'model_fit');
    
end


%Save fitting results
save(filename, 'model_fits');


