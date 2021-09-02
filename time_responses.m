function[fig] = time_responses(stimuli)
touched = stimuli(find(cellfun('isempty',strfind(stimuli(:,12), 'Learning'))),:);
%only take the test trials

react_times = zeros(1, 12); %initialisation of the reaction times
phases = [30 40 60 70]; %store the different phases possible

for k=1:length(touched) %for each test trial
    for j=1:length(phases) %for each phase
        if touched{k,9} == phases(j) && touched{k,11} == 0 %if it's a trial of this phase and it's a success
            react_times(end+1,(j*3)-2) = touched{k,10};
            react_times(end+1,(3*j)-1) = touched{k,10};
        elseif touched{k,9} == phases(j) && touched{k,11} ~= 0 %if it's a trial of this phase and it's an error
            react_times(end+1,(j*3)-2) = touched{k,10};
            react_times(end+1,3*j) = touched{k,10};
        end
    end
end


react_times(react_times == 0) = missing; %take out the 0's and replace it with NaN
react_times = rmoutliers(react_times); %take out the outliers

fig = figure('Position', [20 40 1200 600]); %create the figure 
colors = {[0.9290 0.6940 0.1250]; [0.9290 0.6940 0.1250];[0.9290 0.6940 0.1250];[0.8500 0.3250 0.0980]; [0.8500 0.3250 0.0980];[0.8500 0.3250 0.0980];[0 0.4470 0.7410]; [0 0.4470 0.7410];[0 0.4470 0.7410];[0.4940 0.1840 0.5560];[0.4940 0.1840 0.5560];[0.4940 0.1840 0.5560]}; 
%set the colors
names = {'All trials'; 'Successful trials'; 'Error trials'; 'All trials'; 'Successful trials'; 'Error trials'; 'All trials'; 'Successful trials'; 'Error trials'; 'All trials'; 'Successful trials'; 'Error trials'};
%set the names
b = boxplot(react_times, 'Labels', names);
%create the boxplot
h = findobj(gca,'Tag','Box');
%get the properties of the boxplot
for j=1:length(h)
    patch(get(h(length(h)-j +1),'XData'),get(h(length(h)-j+1),'YData'),colors{j},'FaceAlpha',.5);
end
%for each bar, set the color
title('Distribution of the reaction times across phases')



