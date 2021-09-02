function[stimuli] = get_stimuli_presented(name_file,saving)
addpath 'C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic' %to get the mlread function
data = mlread(name_file); %read the .bhv2 file

s = regexp(name_file, '_');
e = regexp(name_file, '.bhv2');
name = name_file(s(end)+1:e-1); %find the subject's name from the name of the bhv2 file

stimuli = cell(length(data), 15); %create a cell array that will be filed up with all the informations needed from the bhv2 file

for i=1:length(data) %for each row of the file (ie each trial)
    stimuli{i,15} = name; %in each row, write the subject's name 
    stimuli{i,11} = data(i).TrialError ; %store the type of error of each trial 
    if ismember(data(i).BehavioralCodes.CodeNumbers(3), [20 30 40 50 60 70]) %only look at the trials where pictures are displayed
        when = round(data(i).BehavioralCodes.CodeTimes(4)); %store the time when the computer detected the subject touched an image on the screen
        stimuli{i,7} = data(i).AnalogData.Touch(1, :); %initialisation of where the subject touched (to NaN values)
        for k = when-150:when %look in a 150ms window before the time the computer detected the touch
            if ~isnan(data(i).AnalogData.Touch(k,1)) %if the subject indeed touched the screen
                stimuli{i,7} = data(i).AnalogData.Touch(k, :); %store the position of the last touch
            end
        end
        stimuli{i,9} = data(i).BehavioralCodes.CodeNumbers(3); %store the trial's phase 
        stimuli{i,10} = data(i).BehavioralCodes.CodeTimes(4)-data(i).BehavioralCodes.CodeTimes(3); %store the reaction time
        h_low = stimuli{i,7}(1) - 3; %create a square around the position of the touch
        h_high = stimuli{i,7}(1) + 3; %to know which picture was clicked on
        l_low = stimuli{i,7}(2) - 3;
        l_high = stimuli{i,7}(2) + 3;
        if ismember(data(i).BehavioralCodes.CodeNumbers(3), [30 40 60 70]) %if 3 pictures were presented in this trial
            for j=1:3 %for each of these pictures
                stimuli{i,j} = data(i).ObjectStatusRecord.SceneParam(4).AdapterArgs{1, 1}{1, 1}.AdapterArgs{1, 1}{1, j}.AdapterArgs{1, 2}{5, 2}{1}; %store the name of the picture presented
                stimuli{i,3+j} = data(i).ObjectStatusRecord.SceneParam(4).AdapterArgs{1, 1}{1, 1}.AdapterArgs{1, 1}{1, j}.AdapterArgs{1, 2}{5, 2}{2}; %store the position where the picture was presented
                if (h_low<stimuli{i,3+j}(1)&&stimuli{i,3+j}(1)<h_high)&&(l_low<stimuli{i,3+j}(2)&&stimuli{i,3+j}(2)<l_high) %if the picture is the only clicked on
                    stimuli{i,8} = stimuli{i,j}; %store the name of this picture 
                end
            end
        else %if there's only 1 picture presented (first step of the learning)
            stimuli{i,1} = data(i).ObjectStatusRecord.SceneParam(4).AdapterArgs{1, 1}{1, 1}.AdapterArgs{1, 2}{5, 2}{1};  
            stimuli{i,4} = data(i).ObjectStatusRecord.SceneParam(4).AdapterArgs{1, 1}{1, 1}.AdapterArgs{1, 2}{5, 2}{2}; 
        end
    end
end

stimuli = stimuli(~any(cellfun('isempty', stimuli(:,1)), 2), :); %erase the trials where there was only the fixation presented (start of a condition)
start_new_cond = find(cellfun('isempty', stimuli(:,2))); %find where there's a new condition (only 1 picture presented, so the 2nd column is empty)
start_test1 = find([stimuli{:,9}] == 40); %find all the rows where it's a test1 trial
start_test2 = find([stimuli{:,9}] == 70); %find all the rows where it's a test2 trial

while ~isempty(start_test1) %as long as there are rows of test1
    start_new_cond = start_new_cond(start_new_cond > start_test1(1)); %only look at the start of new conditions after the first test1 trial of the current condition 
    for i = start_test1(1):start_new_cond(1)-1 %all the trials between the first test1 trial and the first new condition are test1 trials
        stimuli{i,12} = 'Test1';
    end
    start_test1 = start_test1(start_test1 > start_new_cond(1)); %then look only at the test1 trials that are after the start of the new condition
end

while ~isempty(start_test2) %as long as there are rows of test2
    start_new_cond = start_new_cond(start_new_cond > start_test2(1));
    if isempty(start_new_cond) %if there are no start of new condition left 
        start_new_cond = length(stimuli); %it means it is the last condition so the end is the last trial
    end
    for i = start_test2(1):start_new_cond(1)-1 
        stimuli{i,12} = 'Test2';
    end
    start_test2 = start_test2(start_test2 > start_new_cond(1));
end

stimuli{end,12} = 'Test2'; %the last trial is necessarily a test2 trial
stimuli(any(cellfun('isempty', stimuli(:,12)), 2), 12) = {'Learning'}; %all the trials not test1 or test2 are learning trials

change=[1]; %initialisation of all the changes from learning to test 
for i=1:length(stimuli)-1 %for each trial
    if ~isequal(stimuli{i,12}, stimuli{i+1,12}) %if there's a change
        change(end+1) = i+1; %store the index where it is
    end
end
change(end+1) = length(stimuli); %store the last trial as a change
nb_conditions = (length(change)-1)/4; %divided by 4 because 2 test phases, and there are 2 changes by phases (the start and the end)

for i = 1:nb_conditions %for the number of conditions 
    for j = change(i*2-1):change(i*2+1)-1 %between the start and the end of the condition for the first test phase
        stimuli{j,14} = i; %write the condition number
    end
    for k = change(nb_conditions*2 + i*2-1):change(nb_conditions*2 + i*2+1)-1 %between the start and the end of the condition for the second test phase
        stimuli{k,14} = nb_conditions - i + 1; %write the condition number
    end
end

conditions = {'kinship holding';'kinship grooming';'kinship observing';'friendship grooming';'friendship sitting close';'friendship foraging';'hierarchy mounting';'hierarchy fighting';'hierarchy chasing'};
%names of all the different conditions possible
cond = {'hold' ; 'groomkin' ; 'foragekin' ; 'friendsgroom' ; 'friendsclose' ; 'friendsforaging' ; 'mount' ; 'fight' ; 'chase'};
%names of the pictures for each condition

for j=1:2:length(change)-2 %for all the changes of phase
    for k=1:length(cond)
        if contains(stimuli{change(j),1},cond(k)) %look which kind of condition it is
            stimuli(change(j):change(j+2)-1,13)=conditions(k); %store the kind of condition
            break
        end
    end
end

stimuli{end,14} = stimuli{end-1,14};
stimuli{end,13} = stimuli{end-1,13};
%add the information in the last row as it is not done through the loops
        
if saving
    save(strcat('stimuli_', name, '.mat'), 'stimuli')
end