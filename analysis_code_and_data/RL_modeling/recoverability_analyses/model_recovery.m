%% Model recovery %%
% KN - 8/25/21

clear all;

%% Load data %%
load('../output/fits_LR_data_randParams');

%% Extract AICs for each data set and each model %%

%initialize
best_models_aic = [];
best_models_bic = [];

for dataset = 1:size(model_fits, 1)
    dataset_aics = [];
    dataset_bics = [];
    for model = 1:size(model_fits, 2)
        dataset_aics = [dataset_aics, model_fits(dataset, model).results.AIC];
        [x, dataset_aic_index] = min(dataset_aics, [], 2);
        dataset_bics = [dataset_bics, model_fits(dataset, model).results.BIC];
        [x, dataset_bic_index] = min(dataset_bics, [], 2);
    end
    best_models_aic = [best_models_aic, dataset_aic_index];
    best_models_bic = [best_models_bic, dataset_bic_index];
end


%% Plot proportion of times simulated and recovered match
% first, get model names
for dataset = 1:size(model_fits, 2)
    model_name{dataset} = model_fits(dataset, 1).sim_model(5:end);
end

%% AIC heatmapt
aic_table = array2table(best_models_aic, 'VariableNames', model_name);
aic_table_stacked = stack(aic_table, 1:size(model_fits, 2),  'NewDataVariableName','Recovered Model',...
          'IndexVariableName','Simulated Model');
bic_table = array2table(best_models_bic, 'VariableNames', model_name);
bic_table_stacked = stack(bic_table, 1:size(model_fits, 2),  'NewDataVariableName','Recovered Model',...
          'IndexVariableName','Simulated Model');      

%
figure;
subplot(1,2,1)
h = heatmap(aic_table_stacked, 'Simulated Model', 'Recovered Model');
h.YDisplayLabels = model_name;
title('AIC');
set(gca,'FontSize',14)
colorbar off
subplot(1,2,2)
h = heatmap(bic_table_stacked, 'Simulated Model', 'Recovered Model');
h.YDisplayLabels = model_name;
title('BIC');
set(gca,'FontSize',14)
colorbar off

%% export bics
writetable(bic_table_stacked, '../output/BIC_recovery.csv');

