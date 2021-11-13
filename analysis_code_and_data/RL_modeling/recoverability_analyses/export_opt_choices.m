%% Plot Sims by Age Group %%
function [] = export_opt_choices(model_num)

%% Load data %%
load('../output/sim_LR_data_realParams');
all_model_data = sim_data(model_num);
data_name = all_model_data.function(5:end);
model_data = all_model_data.sub_data;

% specify where to save output
output_dir = '../output/';

%% initialize sub choices vector
num_subs = size(model_data, 2);
num_trials = length(model_data(1).choices);
sub_choices = NaN(num_subs*num_trials, 3);

%%

%determine whether each subject made the optimal choice
for s = 1:num_subs
    
    %if risk good first
    if model_data(s).latents.block_order == 1
        for trial = 1:num_trials
            if model_data(s).block(trial) == 1
                if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                    opt_choice = 0;
                else
                    opt_choice = 1;
                end
                
            elseif model_data(s).block(trial) == 2
                if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                    opt_choice = 0;
                else
                    opt_choice = 1;
                end
            end
            index = ((s-1)*num_trials + trial);
            sub_choices(index, 1) = model_data(s).sub_id;
            sub_choices(index, 2) = trial;
            sub_choices(index, 3) = opt_choice;
        end %end trial loop
        
        
    else %other block order
        
        %loop through kid trials
        for trial = 1:num_trials
            if model_data(s).block(trial) == 1
                if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                    opt_choice = 1;
                else
                    opt_choice = 0;
                end
                
            elseif model_data(s).block(trial) == 2
                if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                    opt_choice = 1;
                else
                    opt_choice = 0;
                end
            end
            
            index = ((s-1)*num_trials + trial);
            sub_choices(index, 1) = model_data(s).sub_id;
            sub_choices(index, 2) = trial;
            sub_choices(index, 3) = opt_choice;
            
        end %end trial loop
    end %end block if statement
end %end subject loop



%% Compute means for each subject
opt_choice_table = array2table(sub_choices, ...
    'VariableNames', {'matlab_id', 'trial', 'opt_choice'});

%get mean for each subject
sub_means = grpstats(opt_choice_table, {'matlab_id', 'trial'}, 'mean');

writetable(sub_means, [output_dir, data_name, '_opt_choices_sim.csv']);


