% Fit RL models
% KN - Oct. 2021

% Clear everything that's loaded
clearvars

%% Load the simulated data
load('../output/sim_LR_data_randParams');
data = sim_data;

%add likelihood functions
addpath('lik_funs');

%determine the number of subjects
n_subjects = length(data(1).sub_data);

% Model-fitting settings
niter = 10; %Number of iterations per participant
filename = '../output/fits_LR_data_randParams';

% Determine models to fit
models = {'one_LR', 'two_LR', 'four_LR'};

%% Initialize model_fits structure
num_sim_datasets = size(sim_data, 2);
num_models_to_fit = length(models);
model_fits(num_sim_datasets, num_models_to_fit) = struct();
model_fits(1).results = [];
model_fits(1).fit_model = 'fit_model';
model_fits(1).sim_model = 'sim_model';

%% Fit models
for d = 1:num_sim_datasets %loop through simulated datasets
    sim_model_data = sim_data(d).sub_data;
    
    for m = 1:num_models_to_fit % loop through models to be fit
        model_to_fit = models{m};
        
        %print message about which model is being fit
        fprintf('Fitting model %d out of %d for dataset %d out of %d...\n', m, length(models), d, num_sim_datasets)
        
        %%%%%%%%%%%%%%%%%
        % MODELS TO FIT %
        %%%%%%%%%%%%%%%%%
        if strcmp(model_to_fit, 'one_LR')
            n_params = 2; %beta, alpha
            lb = [1e-6, 1e-6]; %determine the lower bounds of the parameters
            ub = [30, 1]; %determine the upper bounds of the parameters
            function_name = 'one_LR_lik';
        elseif strcmp(model_to_fit, 'two_LR')
            n_params = 3; %beta, alpha_pos, alpha_neg
            lb = [1e-6, 1e-6, 1e-6];
            ub = [30, 1, 1];
            function_name = 'two_LR_lik';
        elseif strcmp(model_to_fit, 'four_LR')
            n_params = 5; %beta, risk_good_alpha_pos, risk_good_alpha_neg, risk_bad_alpha_pos, risk_bad_alpha_neg
            lb = [1e-6, 1e-6, 1e-6, 1e-6, 1e-6];
            ub = [30, 1, 1, 1, 1];
            function_name = 'four_LR_lik';  
        end
        
        % determine function
        fh = str2func(function_name);
        
        % preallocate
        [logpost, negloglik, AIC, BIC] = deal(nan(n_subjects, 1));
        [params] = nan(n_subjects, n_params);
        
        %initialize results structure
        results(1) = struct();
        results.logpost = logpost;
        results.params = params;
        results.negloglik = negloglik;
        results.AIC = AIC;
        results.BIC = BIC;
        
        %loop through subjects
        parfor s = 1:n_subjects
            sub_data = sim_model_data(s);
            
            %fprintf('Fitting subject %d out of %d...\n', s, n_subjects) %print message saying which subject is being fit
            
            for iter = 1:niter  % run niter times from random initial conditions, to get best fit
                
                % choosing a random number between the lower and upper bounds
                % (defined above) to initialize each of the parameters
                starting_points = rand(1,length(lb)).* (ub - lb) + lb; % random initialization
                
                % Run fmincon
                [res, nlp] = ...
                    fmincon(@(x) fh(sub_data.latents.block_order, sub_data.block, sub_data.choices, sub_data.rewards, x, 1),... %fit with priors to get nlp
                    starting_points,[],[],[],[], lb, ub,[],...
                    optimset('maxfunevals',10000,'maxiter',2000, 'Display', 'off'));
                
                %flip sign to get log posterior
                logp = -1 * nlp;
                
                %store results if better logp is found
                if iter == 1 || logpost(s) < logp %if previous logpost < current one, update
                    logpost(s) = logp;
                    params(s, :) = res;
                    negloglik(s) = fh(sub_data.latents.block_order, sub_data.block, sub_data.choices, sub_data.rewards, res, 0); %fit w/o priors to get nll
                    AIC(s) = 2*negloglik(s) + 2*length(res);
                    BIC(s) = 2*negloglik(s) + length(res)*log(length(sub_data.choices));
                end
                
            end
        end
        
        results.logpost = logpost;
        results.params = params;
        results.negloglik = negloglik;
        results.AIC = AIC;
        results.BIC = BIC;
        
        %save for each model
        model_fits(d, m).results = results;
        model_fits(d, m).fit_model = model_to_fit;
        model_fits(d, m).sim_model = sim_data(d).function;
        
        %clear results structure for next model
        clear results;
        
    end
end


%Save fitting results
save(filename, 'model_fits');



