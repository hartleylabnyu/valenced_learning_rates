%% Plot reward earned %%

% Load simulated data
load('../output/sim_2LR_data_setParams.mat');

%determine alpha_vals
alpha_vals = linspace(.5, .95, 10);

% Get data
data = sim_data.sub_data;

%compute total reward earned in each block for each participant
for sub = 1:length(data)
        block_order(sub) = data(sub).latents.block_order;
        alpha_pos(sub) = data(sub).params(2);
        alpha_neg(sub) = data(sub).params(3);
        if block_order(sub) == 1
            risk_good_reward(sub) = sum(data(sub).rewards(1:100)); %risk good first
            risk_bad_reward(sub) = sum(data(sub).rewards(101:200));
        elseif block_order(sub) == 2
            risk_good_reward(sub) = sum(data(sub).rewards(101:200)); 
            risk_bad_reward(sub) = sum(data(sub).rewards(1:100)); %risk bad first
        end
end
    
%put parameters into matrix and write to csv
sub_data = table(alpha_pos', alpha_neg', risk_good_reward', risk_bad_reward', 'VariableNames', {'alpha_pos', 'alpha_neg', 'risk_good_reward', 'risk_bad_reward'});

%write to csv
writetable(sub_data, '../output/2LR_sim_results.csv');

