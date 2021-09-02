function[fig] = errors_global(stimuli)

subjects = unique(stimuli(:,15)); %store the participants' names
nb_subjects = length(subjects); %store the number of participants

change=[]; %to store the index where it changes from learning to test phase
for i=1:length(stimuli)-1 %for all the trials
    if ~isequal(stimuli{i,12}, stimuli{i+1,12}) %in 12th column, there is written 'Test1', 'Test2' or nothing
        change(end+1) = i+1;
    end
end
change(end+1) = length(stimuli); %add the last trial in the change indexes

phases = [20 30 40 50 60 70]; %the number stored in the bhv2 file for each phase of the task
m = max(cellfun(@max, stimuli(:,14))); %store the max number of conditions seen 
conditions = {'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'};

errors =zeros(1,6); %initialisation of the number of errors of each type
err_cond = zeros(1, m*2); %initialisation of the number of errors for each condition number (m is the number of cond, *2 because there are 2 test phases)
err_kind_cond = zeros(2, length(conditions)); %initialisation of the number of errors for each kind of condition (*2 because there are 2 test phases))

nb_trials = zeros(1,6); %initialisation of the total number of trials per type
nb_cond = zeros(1,m); %initialisation of the number of condition number
nb_kind_cond = zeros(1,length(conditions)); %initialisation of the number of each condition

for j = 1:2:length(change)-1 %for all the new condition
    nb_cond(1, stimuli{change(j),14}) = nb_cond(1, stimuli{change(j),14}) + 1; %store the condition number
    if stimuli{change(j),9} == 40 %if it's during generalisation 1 (because the pictures shown during generalisation 2 are pictures of the other behaviors of the same category, but not the behavior in itself)
        for k=1:length(conditions) %find which kind of condition it was
            if contains(stimuli{change(j),13}, conditions(k))
                nb_kind_cond(1,k) = nb_kind_cond(1,k) + 1; %and store the number of presentation of each kind of condition
            end
        end
    end
end

for i=1:length(stimuli) %for each trial
    nb_trials(find(stimuli{i,9}==phases)) = nb_trials(find(stimuli{i,9}==phases)) + 1; %store which kind of trial it was
    errors(1, stimuli{i,11} + 1) = errors(1, stimuli{i,11} + 1) + 1; %store which kind of error it was 
    if stimuli{i,11} ~= 0 %if there's an error
        for k=1:length(conditions) %find which kind of condition it was
            if contains(stimuli{i,13}, conditions(k))
                if stimuli{i,11} == 4 %if it is a wrong touch during test1
                    err_cond(1, stimuli{i,14}) = err_cond(1, stimuli{i,14}) + 1; %add one to the count of test1 errors by condition (one of the first 3 elements of the matrix)
                    err_kind_cond(1,k) = err_kind_cond(1,k) + 1;
                elseif stimuli{i,11} == 5 %if it is a wrong touch during test2
                    err_cond(1, m + stimuli{i,14}) = err_cond(1, m + stimuli{i,14}) + 1; %add one to the count of test2 errors by condition (one of the last 3 elements of the matrix)
                    err_kind_cond(2,k) = err_kind_cond(2,k) + 1;
                end
            end
        end
    end
    
    
end

errors(1) = []; %erase the success trials
nb_learning = nb_trials(1) + nb_trials(2) + nb_trials(4) + nb_trials(5); %the learning phase numbers are 20, 30, 50, 60, so the total number of learning trials is the sum of the numbers of these 4 phases
errors(1) = (sum(nb_trials)-errors(1))/sum(nb_trials); %transform from absolute numbers of errors to proportions of success by dividing by the total number of each phase
errors(2) = (sum(nb_trials)-errors(2))/sum(nb_trials);
errors(3) = (nb_learning-errors(3))/nb_learning;
errors(4) = (nb_trials(3)-errors(4))/nb_trials(3);
errors(5) = (nb_trials(6)-errors(5))/nb_trials(6);

for i=1:length(nb_cond)
    err_cond(1,i) = (20*(nb_cond(1,i)/2)-err_cond(1,i))/(20*(nb_cond(1,i)/2));
    err_cond(1,m+ i) = (20*(nb_cond(1,i)/2)-err_cond(1,m + i))/(20*(nb_cond(1,i)/2));
end
%divide the total number of errors by the number of each condition number

for i=1:length(nb_kind_cond)
    err_kind_cond(1,i) = (20*nb_kind_cond(1,i)-err_kind_cond(1,i))/(20*nb_kind_cond(1,i));
    err_kind_cond(2,i) = (20*nb_kind_cond(1,i)-err_kind_cond(2,i))/(20*nb_kind_cond(1,i));
end
%divide the total number of errors by the number of each condition kind

fig = figure('Position', [20 40 1200 600]); %create the figure box
t = tiledlayout(2, 2); %create the layout for several plots
ax = nexttile([1 2]); %first plot
conditions = categorical({'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'});
conditions = reordercats(conditions, {'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'});
b = bar(conditions,err_kind_cond, 'FaceColor', 'flat');
b(1).CData = [0 0.4470 0.7410]; %change the color of the bar depending if it's a test1 phase or a test2 phase
b(2).CData = [0.4940 0.1840 0.5560];
yl = yline(1/3, '--', 'chance level', 'LineWidth', 2); %add a horizontal line representing the chance level
yl.LabelHorizontalAlignment = 'left';
title('Proportion of success depending on the condition')

ax1 = nexttile; %next plot
b = bar(errors); %create barplot for the proportion of the different kinds of error
b.FaceColor = 'flat'; %change the color of the bars according to the phase they correspond to
b.CData(1,:) = [0.5 0.5 0.5];
b.CData(2,:) = [0.5 0.5 0.5];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0 0.4470 0.7410];
b.CData(5,:) = [0.4940 0.1840 0.5560];
yl = yline(1/3, '--', 'chance level', 'LineWidth', 2); %add a horizontal line representing the chance level
yl.LabelHorizontalAlignment = 'left';

names = {'Touch in fixation'; 'Touch during trial'; 'Right touch during learning'; 'Right touch during test1'; 'Right touch during test2'};
%names of the different bars in the barplot

axis([ax1], [0 6 0 1.2]) %set the limits of the axis
set(gca, 'xticklabel', names) %change the names of the bars
title('Proportion of success in each phase')

ax2 = nexttile; %next plot
b2 = bar(err_cond);
b2.FaceColor = 'flat';
n = {}; %initialisation of the names of the bars in the barplot
for i = 1:m %for each condition
    b2.CData(i,:) = [0 0.4470 0.7410]; %change the color of the bar depending if it's a test1 phase or a test2 phase
    b2.CData(m + i,:) = [0.4940 0.1840 0.5560];
    n{end + 1} = strcat('Condition ', num2str(i)); %add the condition number to the names of the bars
end
yl = yline(1/3, '--', 'chance level', 'LineWidth', 2); %add an horizontal line marking the chance level
yl.LabelHorizontalAlignment = 'left';

n = [n,n]; %concatenate the names of the bars twice (because there are 2 test phases)
axis([ax2], [0 7 0 1]) %change the limits of the axis
set(gca, 'xticklabel', n) %change the names of the bars
title('Proportion of success depending on the condition number')