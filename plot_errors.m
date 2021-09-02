function[fig] = plot_errors(stimuli)

change=[]; %to store the index where it changes from learning to test phase
for i=1:length(stimuli)-1 %for all the trials
    if ~isequal(stimuli{i,12}, stimuli{i+1,12}) %in 12th column, there is written 'Test1', 'Test2' or nothing
        change(end+1) = i+1;
    end
end
change(end+1) = length(stimuli); %add the last trial in the change indexes

m = max(cellfun(@max, stimuli(:,14))); %store the number of conditions seen 
phases = [20 30 40 50 60 70]; %the number stored in the bhv2 file for each phase of the task
  
errors =zeros(1,6); %initialisation of the number of errors of each type
err_time = zeros(1, length(stimuli)); %initialisation of the errors across trials, 4 possibilities : success (0), no touch during trial (1), wrong touch during learning (2), or wrong touch during test (3)
err_cond = zeros(1, m*2); %initialisation of the number of errors for each condition (m is the number of cond, *2 because there are 2 test phases)
nb_cond = zeros(1,m); %initialisation of the number of condition number
nb_trials = zeros(1,6); %initialisation of the total number of trials per type

for j = 1:2:length(change)-1 %for all the new condition
    nb_cond(1, stimuli{change(j),14}) = nb_cond(1, stimuli{change(j),14}) + 1; %store the condition number
end

for i=1:length(stimuli) %for each trial
    nb_trials(find(stimuli{i,9}==phases)) = nb_trials(find(stimuli{i,9}==phases)) + 1; %store which kind of trial it was
    errors(1, stimuli{i,11} + 1) = errors(1, stimuli{i,11} + 1) + 1; %store which kind of error it was 
    if stimuli{i,11} == 4 %if it is a wrong touch during test1
        err_time(1, i) = 3; 
        err_cond(1, stimuli{i,14}) = err_cond(1, stimuli{i,14}) + 1; %add one to the count of test1 errors by condition (one of the first 3 elements of the matrix)
    elseif stimuli{i,11} == 5 %if it is a wrong touch during test2
        err_time(1, i) = 3;
        err_cond(1, m + stimuli{i,14}) = err_cond(1, m + stimuli{i,14}) + 1; %add one to the count of test2 errors by condition (one of the last 3 elements of the matrix)
    elseif stimuli{i,11} == 3 %if it is a wrong touch during a learning trial
        err_time(1, i) = 2;
    elseif stimuli{i,11} == 2 %if there was no touch during the trial 
        err_time(1, i) = 1;
    end
end
errors(1) = []; %erase the success trials
nb_learning = nb_trials(1) + nb_trials(2) + nb_trials(4) + nb_trials(5); %the learning phase numbers are 20, 30, 50, 60, so the total number of learning trials is the sum of the numbers of these 4 phases
errors(1) = errors(1)/sum(nb_trials); %transform from absolute numbers of errors to proportions by dividing by the total number of each phase
errors(2) = errors(2)/sum(nb_trials);
errors(3) = errors(3)/nb_learning;
errors(4) = errors(4)/nb_trials(3);
errors(5) = errors(5)/nb_trials(6);

for i=1:length(nb_cond)
    err_cond(1,i) = err_cond(1,i)/(20*(nb_cond(1,i)/2));
    err_cond(1,m+ i) = err_cond(1,m + i)/(20*(nb_cond(1,i)/2));
end
%divide the total number of errors by the number of each condition number


fig = figure('Position', [20 40 1200 600]); %create the figure box
t = tiledlayout(2, 2); %create the layout for several plots
title(t, 'Repartition of the errors during the task')
ax = nexttile([1 2]); %first plot
plot([1:length(stimuli)], err_time, '*', 'Color', [0 0 0]) %plot the kind of error across time with black stars
yticks([0 1 2 3])
yticklabels({'Success'; 'No touch during trial'; 'Wrong touch during learning'; 'Wrong touch during test'}); %change the names of the y ticks
hold on %add rectangles of different colors to know where test phases started and ended
for i=1:2:length(change)
    if isequal(stimuli{change(i),12}, 'Test1')
        rectangle('Position', [change(i) 0 change(i+1)-change(i) 4], 'FaceColor', [0 0.4470 0.7410 0.3], 'EdgeColor', [0 0.4470 0.7410 0.3])
    else 
        rectangle('Position', [change(i) 0 change(i+1)-change(i) 4], 'FaceColor', [0.4940 0.1840 0.5560 0.3], 'EdgeColor', [0.4940 0.1840 0.5560 0.3])
    end
end
title('Errors across trials')
axis([ax], [0 length(stimuli) 0 4]) %set the limits of the axis
hold off

ax1 = nexttile; %next plot
b = bar(errors); %create barplot for the proportion of the different kinds of error
b.FaceColor = 'flat'; %change the color of the bars according to the phase they correspond to
b.CData(1,:) = [0.5 0.5 0.5];
b.CData(2,:) = [0.5 0.5 0.5];
b.CData(3,:) = [0.9290 0.6940 0.1250];
b.CData(4,:) = [0 0.4470 0.7410];
b.CData(5,:) = [0.4940 0.1840 0.5560];
yl = yline(2/3, '--', 'chance level', 'LineWidth', 2); %add a horizontal line representing the chance level
yl.LabelHorizontalAlignment = 'left';

names = {'No touch in fixation'; 'No touch during trial'; 'Wrong touch during learning'; 'Wrong touch during test1'; 'Wrong touch during test2'};
%names of the different bars in the barplot

axis([ax1], [0 6 0 1]) %set the limits of the axis
set(gca, 'xticklabel', names) %change the names of the bars
title('Proportion of errors in each phase')

ax2 = nexttile; %next plot
b2 = bar(err_cond);
b2.FaceColor = 'flat';
n = {}; %initialisation of the names of the bars in the barplot
for i = 1:m %for each condition
    b2.CData(i,:) = [0 0.4470 0.7410]; %change the color of the bar depending if it's a test1 phase or a test2 phase
    b2.CData(m + i,:) = [0.4940 0.1840 0.5560];
    n{end + 1} = strcat('Condition ', num2str(i)); %add the condition number to the names of the bars
end
yl = yline(2/3, '--', 'chance level', 'LineWidth', 2); %add an horizontal line marking the chance level
yl.LabelHorizontalAlignment = 'left';

n = [n,n]; %concatenate the names of the bars twice (because there are 2 test phases)
axis([ax2], [0 m*2+1 0 1]) %change the limits of the axis
set(gca, 'xticklabel', n) %change the names of the bars
title('Proportion of errors depending on the condition number')