function[fig] = comparison_errors(stimuli)
touched = stimuli(~any(cellfun('isempty', stimuli(:,8)), 2), :);
%only take the trials where 3 pictures were presented and 1 was clicked on
touched_all = touched(find(cellfun('isempty',strfind(touched(:,12), 'Learning'))),:);
%only take the trials in the test phases
touched_no_error = touched_all(find([touched_all{:,11}] == 0),:);
%only take the trials where the subject touched the correct picture
touched_error = touched_all(find([touched_all{:,11}] ~= 0),:);
%only take the trials where the subject touched a wrong picture 

react_test1_all = [];
react_test2_all = [];
react_learning1_all = [];
react_learning2_all = [];

react_test1_error = [];
react_test2_error = [];
react_learning1_error = [];
react_learning2_error = [];

react_test1_no_error = [];
react_test2_no_error = [];
react_learning1_no_error = [];
react_learning2_no_error = [];

%initialisation of all the reaction times for the different conditions


for i=1:length(touched_all) %for all trials 
    if touched_all{i, 9} == 30
        react_learning1_all(end + 1) = touched_all{i,10};
    elseif touched_all{i, 9} == 40
        react_test1_all(end + 1) = touched_all{i,10};
    elseif touched_all{i, 9} == 60
        react_learning2_all(end + 1) = touched_all{i,10};
    elseif touched_all{i, 9} == 70
        react_test2_all(end + 1) = touched_all{i,10};
    end
    %add the reaction time in the right matrix depending on the phase
end

for i=1:length(touched_error) 
    if touched_error{i, 9} == 30
        react_learning1_error(end + 1) = touched_error{i,10};
    elseif touched_error{i, 9} == 40
        react_test1_error(end + 1) = touched_error{i,10};
    elseif touched_error{i, 9} == 60
        react_learning2_error(end + 1) = touched_error{i,10};
    elseif touched_error{i, 9} == 70
        react_test2_error(end + 1) = touched_error{i,10};
    end
end
%do the same for the error trials only

for i=1:length(touched_no_error)
    if touched_no_error{i, 9} == 30
        react_learning1_no_error(end + 1) = touched_no_error{i,10};
    elseif touched_no_error{i, 9} == 40
        react_test1_no_error(end + 1) = touched_no_error{i,10};
    elseif touched_no_error{i, 9} == 60
        react_learning2_no_error(end + 1) = touched_no_error{i,10};
    elseif touched_no_error{i, 9} == 70
        react_test2_no_error(end + 1) = touched_no_error{i,10};
    end
end
%do the same for the successful trials only

m = 1.2*max([react_learning2_all react_learning1_all react_test1_all react_test2_all]);
%store the reaction time max for display purposes on the figure

fig = figure('Position', [20 40 1200 600]);
%create new figure window
t = tiledlayout(2,2);
title(t, 'Comparison of the reaction times in the different phases of the task')

ax1 = nexttile;
h1 = histfit(react_learning1_all, [], 'kernel');
%create an histogram and the curve associated, with a kernel smoothing
%function fit
h1(2).Color = [0.9290 0.6940 0.1250];
h1(2).LineStyle = ':';
%change the color and the line style of the curve depending on the phase
n = max(get(h1(1), 'YData'));
%store the max number of time reactions in one bin for display purpose
delete(h1(1))
%delete the histogram and keep only the curve
hold on
%add the error trials only and successful trials only on the same subpanel
h3 = histfit(react_learning1_no_error, [],'kernel');
h3(2).Color = [0.9290 0.6940 0.1250];
n = max([n get(h3(1), 'YData')]);
delete(h3(1))
if ~isempty(react_learning1_error) 
    %only plot this if there were error trials 
    h2 = histfit(react_learning1_error,[], 'kernel');
    h2(2).Color = [0.9290 0.6940 0.1250];
    h2(2).LineStyle = '--';
    n = max([n get(h2(1), 'YData')]);
    delete(h2(1))
    xline(mean(react_learning1_error), '--', 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1)
end
xline(mean(react_learning1_all), ':', 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1)
xline(mean(react_learning1_no_error), 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1)
%plot vertical lines for the mean of each curve
ax1.XTick= 0:500:m;
%put a tick every 500ms
lgd = legend('all trials','successful trials', 'unsuccessful trials');
lgd.Location = 'northeastoutside';
%put the legend on the right side of the subfig
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
title('Learning1')
hold off
axis([ax1], [0 m 0 1.2*n])
%define the min and max values of the x and y axis

%do the same for all 4 phases
ax2 = nexttile;
h1 = histfit(react_learning2_all,[], 'kernel');
h1(2).Color = [0.8500 0.3250 0.0980];
h1(2).LineStyle = ':';
n = max(get(h1(1), 'YData'));
delete(h1(1))
hold on
h3 = histfit(react_learning2_no_error, [],'kernel');
h3(2).Color = [0.8500 0.3250 0.0980];
n = max([n get(h3(1), 'YData')]);
delete(h3(1))
if ~isempty(react_learning2_error)
    h2 = histfit(react_learning2_error,[], 'kernel');
    h2(2).Color = [0.8500 0.3250 0.0980];
    h2(2).LineStyle = '--';
    n = max([n get(h2(1), 'YData')]);
    delete(h2(1))
    xline(mean(react_learning2_error), '--', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1)
end
xline(mean(react_learning2_all), ':', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1)
xline(mean(react_learning2_no_error), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1)
ax2.XTick= 0:500:m;
lgd = legend('all trials','successful trials', 'unsuccessful trials');
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
title('Learning2')
hold off
axis([ax2], [0 m 0 1.2*n])

ax3 = nexttile;
h1 = histfit(react_test1_all, [],'kernel');
h1(2).Color = [0 0.4470 0.7410];
h1(2).LineStyle = ':';
n = max(get(h1(1), 'YData'));
delete(h1(1))
hold on
h3 = histfit(react_test1_no_error, [],'kernel');
h3(2).Color = [0 0.4470 0.7410];
n = max([n get(h3(1), 'YData')]);
delete(h3(1))
if ~isempty(react_test1_error)
    h2 = histfit(react_test1_error, [],'kernel');
    h2(2).Color = [0 0.4470 0.7410];
    h2(2).LineStyle = '--';
    n = max([n get(h2(1), 'YData')]);
    delete(h2(1))
    xline(mean(react_test1_error), '--', 'Color', [0 0.4470 0.7410], 'LineWidth', 1)
end
xline(mean(react_test1_all), ':', 'Color', [0 0.4470 0.7410], 'LineWidth', 1)
xline(mean(react_test1_no_error), 'Color', [0 0.4470 0.7410], 'LineWidth', 1)
ax3.XTick= 0:500:m;
lgd = legend('all trials','successful trials', 'unsuccessful trials');
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
title('Test1')
hold off
axis([ax3], [0 m 0 1.2*n])

ax4 = nexttile;
h1 = histfit(react_test2_all, [],'kernel');
h1(2).Color = [0.4940 0.1840 0.5560];
h1(2).LineStyle = ':';
n = max(get(h1(1), 'YData'));
delete(h1(1))
hold on
h3 = histfit(react_test2_no_error, [],'kernel');
h3(2).Color = [0.4940 0.1840 0.5560];
n = max([n get(h3(1), 'YData')]);
delete(h3(1))
if ~isempty(react_test2_error)
    h2 = histfit(react_test2_error, [],'kernel');
    h2(2).Color = [0.4940 0.1840 0.5560];
    h2(2).LineStyle = '--';
    n = max([n get(h2(1), 'YData')]);
    delete(h2(1))
    xline(mean(react_test2_error), '--', 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 1)
end
xline(mean(react_test2_all), ':', 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 1)
xline(mean(react_test2_no_error), 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 1)
ax4.XTick= 0:500:m;
lgd = legend('all trials', 'successful trials', 'unsuccessful trials');
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
title('Test2')
hold off
axis([ax4], [0 m 0 1.2*n])


