%% Plot Sims by Age Group %%
function [] = plot_sims_age(model_num)

%% Load data %%
load('../output/sim_LR_data_realParams', 'sim_data');
all_model_data = sim_data(model_num);
data_name = all_model_data.function(5:end);
model_data = all_model_data.sub_data;

%plot or no?
make_plot = 1;

% specify where to save output
output_dir = '../output/';
%% Plot choices

%initialize matrix with choices
kid1_choices = NaN(2200, length(model_data(1).choices));
kid2_choices = NaN(2500, length(model_data(1).choices));
teen1_choices = NaN(2200, length(model_data(1).choices));
teen2_choices = NaN(2400, length(model_data(1).choices));
adult1_choices = NaN(2400, length(model_data(1).choices));
adult2_choices = NaN(2500, length(model_data(1).choices));

kid1_count = 0;
teen1_count = 0;
adult1_count = 0;
kid2_count = 0;
teen2_count = 0;
adult2_count = 0;

%determine whether each subject made the optimal choice
for s = 1:length(model_data)
    
    %if risk good first
    if model_data(s).latents.block_order == 1
        
        %if kid
        if model_data(s).age < 13
            kid1_count = kid1_count + 1;
            
            %loop through kid trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        kid1_choices(kid1_count, trial) = 0;
                    else
                        kid1_choices(kid1_count, trial) = 1;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        kid1_choices(kid1_count, trial) = 0;
                    else
                        kid1_choices(kid1_count, trial) = 1;
                    end
                end
            end %end trial loop
            
            %if teen
        elseif model_data(s).age < 18.0
            teen1_count = teen1_count + 1;
            
            %loop through teen trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        teen1_choices(teen1_count, trial) = 0;
                    else
                        teen1_choices(teen1_count, trial) = 1;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        teen1_choices(teen1_count, trial) = 0;
                    else
                        teen1_choices(teen1_count, trial) = 1;
                    end
                end
            end %end trial loop
            
            %if adult
        else
            adult1_count = adult1_count + 1;
            
            %loop through adult trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        adult1_choices(adult1_count, trial) = 0;
                    else
                        adult1_choices(adult1_count, trial) = 1;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        adult1_choices(adult1_count, trial) = 0;
                    else
                        adult1_choices(adult1_count, trial) = 1;
                    end
                end
            end %end trial loop
        end %end age if statement
        
    else %other block order
        if model_data(s).age < 13
            kid2_count = kid2_count + 1;
            
            %loop through kid trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        kid2_choices(kid2_count, trial) = 1;
                    else
                        kid2_choices(kid2_count, trial) = 0;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        kid2_choices(kid2_count, trial) = 1;
                    else
                        kid2_choices(kid2_count, trial) = 0;
                    end
                end
            end %end trial loop
            
            %if teen
        elseif model_data(s).age < 18.0
            teen2_count = teen2_count + 1;
            
            %loop through teen trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        teen2_choices(teen2_count, trial) = 1;
                    else
                        teen2_choices(teen2_count, trial) = 0;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        teen2_choices(teen2_count, trial) = 1;
                    else
                        teen2_choices(teen2_count, trial) = 0;
                    end
                end
            end %end trial loop
            
            %if adult
        else
            adult2_count = adult2_count + 1;
            
            %loop through adult trials
            for trial = 1:length(model_data(1).choices)
                if model_data(s).block(trial) == 1
                    if model_data(s).choices(trial) == 3 || model_data(s).choices(trial) == 4
                        adult2_choices(adult2_count, trial) = 1;
                    else
                        adult2_choices(adult2_count, trial) = 0;
                    end
                    
                elseif model_data(s).block(trial) == 2
                    if model_data(s).choices(trial) == 1 || model_data(s).choices(trial) == 2
                        adult2_choices(adult2_count, trial) = 1;
                    else
                        adult2_choices(adult2_count, trial) = 0;
                    end
                end
            end %end trial loop
        end %end age if statement
    end %end block if statement
    
    
end %end subject loop

%get the mean across subjects
mean_kid1_choices = mean(kid1_choices, 1);
mean_teen1_choices = mean(teen1_choices, 1);
mean_adult1_choices = mean(adult1_choices, 1);
mean_kid2_choices = mean(kid2_choices, 1);
mean_teen2_choices = mean(teen2_choices, 1);
mean_adult2_choices = mean(adult2_choices, 1);

%% Save choice data
opt_choice_table = array2table([mean_kid1_choices', mean_kid2_choices', ...
    mean_teen1_choices', mean_teen2_choices', mean_adult1_choices', mean_adult2_choices'], ...
    'VariableNames', {'Children_1', 'Children_2', 'Adolescents_1', 'Adolescents_2', ...
    'Adults_1', 'Adults_2'}); 

writetable(opt_choice_table, [output_dir, data_name, '_mean_opt_choices_sim.csv']);
    

%% plot
if (make_plot)
figure('units','inch','position',[50,50,20,20]);
subplot(3, 2, 1)
plot(mean_kid1_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_kid1_choices(101:200), 'LineWidth', 4);
legend('Risk Good', 'Risk Bad');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [55/255 139/255 241/255; 255/255 221/255 60/255;]);
set(gca,'FontSize', 16)
title('Children: Risk Good First');

subplot(3, 2, 2)
plot(mean_kid2_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_kid2_choices(101:200), 'LineWidth', 4);
legend('Risk Bad', 'Risk Good');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [255/255 221/255 60/255; 55/255 139/255 241/255]);
set(gca,'FontSize', 16)
title('Children: Risk Bad First');


subplot(3, 2, 3)
plot(mean_teen1_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_teen1_choices(101:200), 'LineWidth', 4);
legend('Risk Good', 'Risk Bad');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [55/255 139/255 241/255; 255/255 221/255 60/255;]);
set(gca,'FontSize', 16)
title('Adolescents: Risk Good First');

subplot(3, 2, 4)
plot(mean_teen2_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_teen2_choices(101:200), 'LineWidth', 4);
legend('Risk Bad', 'Risk Good');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [255/255 221/255 60/255; 55/255 139/255 241/255]);
set(gca,'FontSize', 16)
title('Adolescents: Risk Bad First');

subplot(3, 2, 5)
plot(mean_adult1_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_adult1_choices(101:200), 'LineWidth', 4);
legend('Risk Good', 'Risk Bad');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [55/255 139/255 241/255; 255/255 221/255 60/255;]);
set(gca,'FontSize', 16)
title('Adults: Risk Good First');

subplot(3, 2, 6)
plot(mean_adult2_choices(1:100), 'LineWidth', 4);
hold on
plot(mean_adult2_choices(101:200), 'LineWidth', 4);
legend('Risk Bad', 'Risk Good');
xlabel('Trial');
ylabel('Prop. Optimal Choices');
set(gca, 'ColorOrder', [255/255 221/255 60/255; 55/255 139/255 241/255]);
set(gca,'FontSize', 16)
title('Adults: Risk Bad First');

sgtitle(data_name, 'Interpreter', 'None')
end
