function[fig] = mean_color_picture(stimuli)
stimuli = stimuli(~any(cellfun('isempty', stimuli(:,8)), 2), :);
%only take the trials where 3 pictures were presented and a picture was clicked on 

cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc\Figures_control\Pictures
%go to the folder where all pictures are stored

means_all = zeros(length(stimuli), 6);
means_test = zeros(length(stimuli), 6);
%initialisation of the mean RGB levels for all and only test trials

for i=1:length(stimuli) %for each trial
    picture_presented = imread(stimuli{i,1});
    picture_clicked = imread(stimuli{i, 8});
    %store the RGB levels of each pixel of the target picture and the
    %picture clicked on
    for j=1:3 %for R, G and B values
        means_all(i,(j*2)-1) = mean(mean(picture_presented(:,:,j)));
        means_all(i,j*2) = mean(mean(picture_clicked(:,:,j)));
        %compute the mean of these values across pixels
    end 
end

means_test = means_all(find(cellfun('isempty',strfind(stimuli(:,12), 'Learning'))),:);
%for the mean test, only take the values of the test phases

colors ={'r'; 'r'; 'g'; 'g'; 'c'; 'c'};
names = {'Presented'; 'Clicked on'; 'Presented'; 'Clicked on'; 'Presented'; 'Clicked on'};
%store the names of the different boxes

fig = figure('Position', [20 40 1200 600]);
%create new figure window
t = tiledlayout(1,2);
title(t, 'Comparison of the colors of the pictures presented and clicked on')
nexttile
boxplot(means_all, 'Labels', names)
%create the boxes of the color means of the pictures presented and clicked
%on
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(length(h)-j +1),'XData'),get(h(length(h)-j+1),'YData'),colors{j},'FaceAlpha',.5);
end
%color the boxes in red, green and blue
title('All trials')
nexttile
boxplot(means_test, 'Labels', names)
%do the same but only with the test trials 
h2 = findobj(gca,'Tag','Box');
for j=1:length(h2)
    patch(get(h2(length(h2)-j +1),'XData'),get(h2(length(h2)-j+1),'YData'),colors{j},'FaceAlpha',.5);
end
title('Only test trials')

cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc
%go back to the main folder 