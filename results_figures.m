function[] = results_figures()
addpath 'C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic'
addpath 'C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc' %add these paths to get all the functions needed
stimuli = concatenate_files(); %produce the concatenated file

cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc\Results %change directory
%all the code below is to produce result figures using the different
%scripts written
errors = errors_global(stimuli);
saveas(errors, 'errors.png')

%go back to the main folder
cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc