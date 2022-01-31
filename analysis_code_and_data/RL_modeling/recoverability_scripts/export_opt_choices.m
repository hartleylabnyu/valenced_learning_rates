%% Plot Sims by Age Group %%
function [] = export_opt_choices(model_num)

%% Load data %%
load('../output/mat_files/sim_decay2_data_realParams');
all_model_data = sim_data(model_num);
data_name = all_model_data.function(5:end);
model_data = all_model_data.sub_data;

% specify where to save output
output_dir = '../output/posterior_predictive_checks/';

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
            if model_data(s).block(trial) == 1 %risk good
                if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4 %safe
                    opt_choice = 0; %not optimal
                else %risky
                    opt_choice = 1; %optimal
                end
                
            elseif model_data(s).block(trial) == 2 %risk bad
                if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2 %risky
                    opt_choice = 0; %not optimal
                else %safe
                    opt_choice = 1; %optimal
                end
            end
            index = ((s-1)*num_trials + trial);
            sub_choices(index, 1) = model_data(s).sub_id;
            sub_choices(index, 2) = trial;
            sub_choices(index, 3) = opt_choice;
        end %end trial loop
        
    %risk bad first 
    else 
        for trial = 1:num_trials
            if model_data(s).block(trial) == 1 %risk bad
                if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4 %safe choice
                    opt_choice = 1; %optimal
                else %risky choice
                    opt_choice = 0; %not optimal
                end
                
            elseif model_data(s).block(trial) == 2 %risk good
                if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2 %risky choice
                    opt_choice = 1; %optimal
                else %safe choice
                    opt_choice = 0; %not optimal
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

%% For each sub, find probability of each choice on each trial

%initialize choice data structure
choice_data = NaN(142*200, 3);

%trial vector
trial = 1:200;

%multiplication vector
mult_vec = [0:99];

for sub_num = 1:142
   indices = [1:200] + 200*(sub_num -1); %get indices to save data
   sub_indices = sub_num + 142*mult_vec; %get indices of sub data
   sub_data = model_data(sub_indices); %get subject data
   sub_choices = [sub_data.choices]; %get all choices
   common_choice = mode(sub_choices, 2); %find most common choice for each trial
   sub_id = repmat(sub_data(1).sub_id, 200, 1); 
   choice_data(indices, 1) = sub_id;
   choice_data(indices, 2) = trial';
   choice_data(indices, 3) = common_choice;
end

choice_data_table = array2table(choice_data,  'VariableNames',{'matlab_id','trial','frequent_choice'});
writetable(choice_data_table, [output_dir, data_name, '_freq_choices_sim.csv']);

end

    




