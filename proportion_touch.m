function[fig] = proportion_touch(data, all_trials)
positions=zeros(4,5); %initialisation of the positions where the right pictures were presented and where the subject clicked
positions_normalised = zeros(2,5); %initialisation of the positions normalised (touched/presented)
data = data(~any(cellfun('isempty', data(:,2)), 2), :); %only look at the trials where 3 pictures were presented
if ~all_trials %if we only want to look at trials during the test phases
    data = data(find(cellfun('isempty',strfind(data(:,12), 'Learning'))),:); %get rid of the learning trials during the learning phases
end
test = data(find([data{:,9}] == 40 |[data{:,9}] == 70),:); %store only the test trials 

squares = [8 15 5 9 ; 8 15 -8 -3; -15 -8 -8 -3; -15 -8 5 9; -3 3 -3 3]; %the different positions possible

for i=1:length(data) %for each trial 
    for j=1:5 %for each position
        if squares(j,1)<data{i,7}(1) && data{i,7}(1)<squares(j,2) && squares(j,3)<data{i,7}(2) && data{i,7}(2)<squares(j,4)
            %if the position of the click is within the square around the
            %position
            positions(1,j) = positions(1,j) + 1; %the subject clicked in this square
        end
        if squares(j,1)<data{i,4}(1) && data{i,4}(1)<squares(j,2) && squares(j,3)<data{i,4}(2) && data{i,4}(2)<squares(j,4)
            %if the position of the presentation is within the square 
            %around the position
            positions(2,j) = positions(2,j) + 1; %the image was presented in this square
        end 
    end
end 

for i=1:length(test) %for each test trial, the same thing as above
    for j=1:5
        if squares(j,1)<test{i,7}(1) && test{i,7}(1)<squares(j,2) && squares(j,3)<test{i,7}(2) && test{i,7}(2)<squares(j,4)
            positions(3,j) = positions(3,j) + 1;
        end
        if squares(j,1)<test{i,4}(1) && test{i,4}(1)<squares(j,2) && squares(j,3)<test{i,4}(2) && test{i,4}(2)<squares(j,4)
            positions(4,j) = positions(4,j) + 1;
        end
    end
end

fig = figure('Position', [20 40 1200 600]); %create a new figure box
t = tiledlayout(2,1); %create a layout for several plots

if all_trials
    title(t, 'Positions of touches and presentations during all phases of the task')
else
    title(t, 'Positions of touches and presentations during test phases of the task')
end 
%write different title depending on the all_trials parameter

nexttile %next plot
names = categorical({'top right', 'bottom right', 'bottom left', 'top left','middle'});
names = reordercats(names, {'top right', 'bottom right', 'bottom left', 'top left','middle'});
%create the names of the different groups of bars, and order them

prop = bar(names,positions, 'FaceColor', 'flat'); %create the bar plot
prop(1).CData = [0.86 0.5 0.11];
prop(2).CData = [0.86 0.5 0.11];
prop(2).FaceAlpha = 0.5;
prop(3).CData = [0.25 0.3 0.65];
prop(4).CData = [0.25 0.3 0.65];
prop(4).FaceAlpha = 0.5;
%change the color of the bars 
lgd = legend('Learning touch', 'Learning presentation', 'Test touch', 'Test presentation');
%add a legend of the different colors
lgd.Location = 'northeastoutside';
title('Number of presentations and touches at each position')


for i = 1:5
    positions_normalised(1,i) = positions(1, i)/positions(2,i);
    positions_normalised(2,i) = positions(3, i)/positions(4,i);
end
%normalise positions by dividing the touch by the presentation 

nexttile %next plot
prop_normalised = bar(names,positions_normalised, 'FaceColor', 'flat');
%create the bar plot
prop_normalised(1).CData = [0.86 0.5 0.11];
prop_normalised(2).CData = [0.25 0.3 0.65];
%change the colors of the bars
lgd = legend('Learning', 'Test');
lgd.Location = 'northeastoutside';
%add a legend of the different colors 
title('Proportion of touches compared to presentations at each position')

    
    