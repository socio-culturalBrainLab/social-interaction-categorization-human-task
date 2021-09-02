function[fig] = reaction_time_global(stimuli)

subjects = unique(stimuli(:,15)); %store the participants' names
nb_subjects = length(subjects); %store the number of participants

conditions = {'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'};
% store the different conditions possible 

react_times = zeros(nb_subjects, 12); %initialisation of the reaction times for each phase
react_times_cond = zeros(nb_subjects, length(conditions)*6); %initialisation of the reaction times depending on the condition
% *6 because there are 2 phases of test, and 3 plots for each (all trials,
% successful and error trials)
phases = [30 40 60 70]; %record of the different phases 
phases_test = [40 70]; %record of the differente phases of test
for i=1:nb_subjects %for each participant
    react_times_cond_temp = zeros(1, length(conditions)*6); 
    react_times_temp = zeros(1,12); %initialisation of temporary variables to compute means for each subject
    stimuli_subject = stimuli(find(~cellfun('isempty',strfind(stimuli(:,15), subjects{i}))),:); %only consider the trials of this subject
    stimuli_learning = stimuli_subject(any(cellfun('isempty', stimuli_subject(:,2)), 2), :); %take only the trials where one picture was presented (to calculate mean reaction time)
    mean_react_time = mean(cellfun(@mean, stimuli_learning(:,10))); %store the mean reaction time in learning phase of this subject
    
    stimuli_test = stimuli_subject(find([stimuli_subject{:,9}] == 40 |[stimuli_subject{:,9}] == 70),:); %only the test trials
    
    for k=1:length(stimuli_subject) %for each trial of this participant
        for j=1:4 %for each phase (L1, L2, T1, T2)
            if stimuli_subject{k,9} == phases(j) && stimuli_subject{k,11} == 0 %if it's a success during this phase
                react_times_temp(end+1,(j*3)-2) = stimuli_subject{k,10} - mean_react_time; %add the reaction time normalized to the all trials record
                react_times_temp(end+1,(3*j)-1) = stimuli_subject{k,10} - mean_react_time; %add the reaction time normalized to the success trials record
            elseif stimuli_subject{k,9} == phases(j) && stimuli_subject{k,11} ~= 0 %if it's an error during this phase
                react_times_temp(end+1,(j*3)-2) = stimuli_subject{k,10} - mean_react_time; %add the reaction time normalized to the all trials record
                react_times_temp(end+1,3*j) = stimuli_subject{k,10} - mean_react_time; %add the reaction time normalized to the error trials record 
            end
        end
    end
    
    react_times_temp(react_times_temp == 0) = missing; %get rid of the 0's (otherwise it would not calculate the mean properly)
    react_times(k,:) = nanmean(react_times_temp); %compute the mean of each reaction time and store it in the reaction times global

    %THIS DOESN'T WORK SO FAR
    for k=1:length(stimuli_test) %only for the test trials
        for i=1:length(conditions) %for each condition
            if isequal(stimuli_test{k,13},conditions{i}) %if this trial is this condition
                for j=1:2 %for each test phase 
                    if stimuli_test{k,9} == phases_test(j) && stimuli_test{k,11} == 0 %if it's a success during this phase
                        react_times_cond_temp(end+1,(i-1)*6 +(j*3)-2) = stimuli_test{k,10} - mean_react_time; %add the reaction time normalized to the all trials record
                        react_times_cond_temp(end+1,(i-1)*6+(3*j)-1) = stimuli_test{k,10} - mean_react_time; %add the reaction time normalized to the success trials record
                    elseif stimuli_test{k,9} == phases_test(j) && stimuli_test{k,11} ~= 0 %if it's an error during this phase
                        react_times_cond_temp(end+1,(i-1)*6+(j*3)-2) = stimuli_test{k,10} - mean_react_time; %add the reaction time normalized to the all trials record
                        react_times_cond_temp(end+1, (i-1)*6+3*j) = stimuli_test{k,10} - mean_react_time; %add the reaction time normalized to the error trials record 
                    end
                end
            end
        end
    end
    
    react_times_cond_temp(react_times_cond_temp == 0) = missing; %get rid of the 0's (otherwise it would not calculate the mean properly)
    react_times_cond(k,:) = nanmean(react_times_cond_temp); %compute the mean of each reaction time and store it in the reaction times global

end

fig = figure('Position', [20 40 1200 600]); %create a figure
t = tiledlayout(2,1); %create the layout for the figure
title(t, 'Distribution of the reaction times for all participants') %add title
ax1 = nexttile; %next plot
conditions = categorical({'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'});
conditions = reordercats(conditions, {'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'});
%create the names for the different bars
b = boxplot(react_times_cond, 'PlotStyle', 'compact'); %create the barplot 
title('Distribution of the reaction times depending on the condition')


ax2 = nexttile; %next plot
colors = {[0.9290 0.6940 0.1250]; [0.9290 0.6940 0.1250];[0.9290 0.6940 0.1250];[0.8500 0.3250 0.0980]; [0.8500 0.3250 0.0980];[0.8500 0.3250 0.0980];[0 0.4470 0.7410]; [0 0.4470 0.7410];[0 0.4470 0.7410];[0.4940 0.1840 0.5560];[0.4940 0.1840 0.5560];[0.4940 0.1840 0.5560]}; 
%store the colors for the different bars
names = {'All trials'; 'Successful trials'; 'Error trials'};
names = [names;names;names;names];
%create the names of the different bars
b = boxplot(react_times, 'Labels', names); %create the barplot
h = findobj(gca,'Tag','Box'); %get the properties of the plot, to change the colors of the bars
for j=1:length(h)
    patch(get(h(length(h)-j +1),'XData'),get(h(length(h)-j+1),'YData'),colors{j},'FaceAlpha',.5);
end
%for each bar, set the right color
axis([ax2], [0 13 -500 2000])
%set the axis limits
title('Distribution of the reaction times across phases')



