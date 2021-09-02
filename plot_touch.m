function[fig] = plot_touch(stimuli)
touched = stimuli(~any(cellfun('isempty', stimuli(:,2)), 2), :);
%take only the trials where 3 pictures were presented

fig = figure('Position', [20 40 1200 600]);
%create the figure
plot(touched{1,7}(1), touched{1,7}(2), '*','MarkerEdgeColor', [0.9290 0.6940 0.1250])
%create a point where the screen was touched on the first trial, with the
%learning 1 color
hold on
for i=2:length(touched)
    %for each trial, create another point where the screen was touched, of
    %the color of the phase (learning 1, 2 or test 1, 2)
    p = plot(touched{i,7}(1), touched{i,7}(2), '*');
    if touched{i,9} == 30 %to know which phase it was
        p.MarkerEdgeColor = [0.9290 0.6940 0.1250];
    elseif touched{i,9} == 40
        p.MarkerEdgeColor = [0 0.4470 0.7410];
    elseif touched{i,9} == 60
        p.MarkerEdgeColor = [0.8500 0.3250 0.0980];
    elseif touched{i,9} == 70
        p.MarkerEdgeColor = [0.4940 0.1840 0.5560];
    end
end
title('Position of touches on the screen')
axis padded %add a margin around the plot
hold off