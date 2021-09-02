function[fig] = plot_reaction_time(stimuli, all_trials)
touched = stimuli(~any(cellfun('isempty', stimuli(:,3)), 2), :);
touched = touched(find(~cellfun('isempty', touched(:,12))),:);
if ~all_trials %if we only want to look at trials during the test phases
    touched = touched(find(cellfun('isempty',strfind(touched(:,12), 'Learning'))),:); %get rid of the learning trials during the learning phases
end

react_test1 = [];
react_test2 = [];
react_learning1 = [];
react_learning2 = [];
%initialisation of the different reaction times
for i=1:length(touched) %for all trials
    if touched{i, 9} == 30
        react_learning1(end + 1) = touched{i,10};
    elseif touched{i, 9} == 40
        react_test1(end + 1) = touched{i,10};
    elseif touched{i, 9} == 60
        react_learning2(end + 1) = touched{i,10};
    elseif touched{i, 9} == 70
        react_test2(end + 1) = touched{i,10};
    %add the reaction time in the good list depending on the phase
    end
end

m = 1.1*max([react_learning2 react_learning1 react_test1 react_test2]);
%store the longest reaction time across trials to set the axis of the
%figure properly

fig = figure('Position', [20 40 1200 600]);
t = tiledlayout(3,2);
%create a new figure box

if all_trials
    title(t, 'Reaction times during all phases of the task')
else
    title(t, 'Reaction times during test phases of the task')
end 
%write different title depending on the all_trials parameter

ax1 = nexttile;
h1 = histogram(react_learning1, 'NumBins', 10, 'DisplayName', 'Learning1', 'FaceColor', [0.9290 0.6940 0.1250]);
hold on
h2 = histogram(react_learning2, 'NumBins', 10, 'DisplayName', 'Learning2', 'FaceColor', [0.8500 0.3250 0.0980]);
%create the histograms of 2 phases with their correct colors 
lgd = legend();
lgd.Location = 'northeastoutside';
%write the legend on the right of the subfigure
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
%write the labels
hold off
axis([ax1], [0 m 0 1.1*max([h1.Values h2.Values])])
%set the limits of the axis depending on the values of the reaction times

%do the same with other combinations of 2 phases 
ax2 = nexttile;
h1 = histogram(react_test1, 'NumBins', 10, 'DisplayName', 'Test1', 'FaceColor', [0 0.4470 0.7410]);
hold on
h2 = histogram(react_test2, 'NumBins', 10, 'DisplayName', 'Test2', 'FaceColor',[0.4940 0.1840 0.5560]);
lgd = legend();
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
hold off
axis([ax2], [0 m 0 1.1*max([h1.Values h2.Values])])

ax3 = nexttile;
h1 = histogram(react_learning1, 'NumBins', 10, 'DisplayName', 'Learning1', 'FaceColor',[0.9290 0.6940 0.1250]);
hold on
h2 = histogram(react_test1, 'NumBins', 10, 'DisplayName', 'Test1', 'FaceColor', [0 0.4470 0.7410]);
lgd = legend();
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
hold off
axis([ax3], [0 m 0 1.1*max([h1.Values h2.Values])])

ax4= nexttile;
h1 = histogram(react_learning2, 'NumBins', 10, 'DisplayName', 'Learning2', 'FaceColor', [0.8500 0.3250 0.0980]);
hold on
h2 = histogram(react_test2, 'NumBins', 10, 'DisplayName', 'Test2', 'FaceColor', [0.4940 0.1840 0.5560]);
lgd = legend();
lgd.Location = 'northeastoutside';
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
hold off
axis([ax4], [0 m 0 1.1*max([h1.Values h2.Values])])

ax5 = nexttile([1 2]);
%create another subfigure where the curves of the reaction times for the
%different phases and their means is plotted
h1 = histfit(react_learning1);
h1(2).Color = [0.9290 0.6940 0.1250];
delete(h1(1))
%delete the histogram to keep only the curve
hold on
h2 = histfit(react_learning2);
h2(2).Color = [0.8500 0.3250 0.0980];
delete(h2(1))
h3 = histfit(react_test1);
h3(2).Color = [0 0.4470 0.7410];
delete(h3(1))
h4 = histfit(react_test2);
h4(2).Color = [0.4940 0.1840 0.5560];
delete(h4(1))
xline(mean(react_learning2), '--', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1)
xline(mean(react_learning1), '--', 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1)
xline(mean(react_test2), '--', 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 1)
xline(mean(react_test1), '--', 'Color', [0 0.4470 0.7410], 'LineWidth', 1)
%create the vertical lines for all means of the reaction times

ax5.XTick= 0:500:m;
%put a tick every 500ms on the x axis 
lgd = legend('Learning1', 'Learning2','Test1', 'Test2');
lgd.Location = 'northeastoutside';
title('Distribution of the reaction times')
xlabel('Reaction time (ms)', 'FontSize', 8)
ylabel('Number of trials', 'FontSize', 8)
hold off


