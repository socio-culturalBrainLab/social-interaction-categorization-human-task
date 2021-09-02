function[all] = concatenate_files()
cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc\Figures_control %change directory
d = dir; %look at all folders and files in the directory
df = [d.isdir]; %look at only the folders in the directory
d = d(df); %erase everything that is not a folder from d
all = {}; %initialisation of the cell array containing all cell arrays of all subjects
for k = 3:length(d) %for all the folders except the . and .. folders (that's why it starts at 3 and not 1)
    if ~isequal(d(k).name, 'Pictures') %if it is not the Pictures folder (used for other scripts)
        cd(d(k).name) %go in the folder
        file = dir('*.mat'); %look at mat files (there should be only one, the stimuli cell array from get_stimuli_presented)
        f = load(file.name); %load this file
        f = f.stimuli; %look at the stimuli (because when loading, it gives a struct: "stimuli: cell array")
        all = [all; f]; %concatenate this file at the end of the cell array
        cd .. %go back to the main folder
    end
end
cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc\Results
save allfiles.mat all %save the concatenated cell array in the results folder
cd ..