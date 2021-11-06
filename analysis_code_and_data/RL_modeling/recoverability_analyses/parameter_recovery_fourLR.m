%% Parameter recovery %%
clear all;
%% Load data %%

%simulated data
load('../output/sim_LR_data_randParams');

%model fits
load('../output/fits_LR_data_randParams');

%% Get simulated and recovered parameters from each model

sim_params = zeros(size(model_fits(3,3).results.params));
fit_params = zeros(size(model_fits(3,3).results.params));

for s = 1:length(sim_data(1).sub_data)
    sim_params(s, :) = sim_data(3).sub_data(s).params;
    fit_params(s, :) = model_fits(3, 3).results.params(s, :);
end
%% Plot
figure;
n_params = sim_data(3).n_params;
param_names = sim_data(3).param_names;

for p = 1:n_params
    subplot(1, n_params, p); %new subplot for each parameter
    scatter(sim_params(:, p), fit_params(:, p), 10, 'MarkerFaceColor', [102 102 255]./255, 'MarkerEdgeColor', 'k');
    P = polyfit(sim_params(:, p), fit_params(:, p), 1);
    yfit = P(1)*sim_params(:, p)+P(2);
    hold on;
    plot(sim_params(:, p),yfit,'k-.', 'LineWidth', 3);
    title([param_names(p), round(P(1), 2)], 'Interpreter', 'none');
    set(gca, 'FontSize', 12);
end

%% save sim_params and fit_params
sim_params_table = array2table(sim_params, 'VariableNames', param_names);
fit_params_table = array2table(fit_params, 'VariableNames', param_names);


writetable(sim_params_table, '../output/fourLR_sim_params.csv');
writetable(fit_params_table, '../output/fourLR_fit_params.csv')




