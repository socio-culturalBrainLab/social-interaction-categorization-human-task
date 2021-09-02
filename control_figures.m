function[] = control_figures(name_file)
addpath 'C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic'
addpath 'C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc' %add these paths to get all the functions needed
cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc %change directory
s = regexp(name_file, '_');
e = regexp(name_file, '.bhv2');
name = name_file(s(end)+1:e-1); %find the subject's name
mkdir(strcat('Figures_control\', name)) %create a new folder for this subject
copyfile(name_file, strcat('Figures_control\', name)) %copy the bhv2 file in the new folder
cd(strcat('Figures_control\', name)) %change directory to this new folder
stimuli = get_stimuli_presented(name_file, 1); %calculate the cell array with all the informations needed
%all the code below is to produce control figures using the different
%scripts written
where_touch = plot_touch(stimuli);
saveas(where_touch, strcat('plot_touch_', name, '.png'))
touches_global = proportion_touch(stimuli,1);
saveas(touches_global, strcat('proportions_of_touch_global_', name, '.png'))
touches_test = proportion_touch(stimuli,0);
saveas(touches_test, strcat('proportions_of_touch_only_test_', name, '.png'))
reaction_times_global = plot_reaction_time(stimuli,1);
saveas(reaction_times_global, strcat('reaction_times_global_', name, '.png'))
reaction_times_test = plot_reaction_time(stimuli,0);
saveas(reaction_times_test, strcat('reaction_times_only_test_', name, '.png'))
times_errors = comparison_errors(stimuli);
saveas(times_errors, strcat('comparison_reaction_times_error_non_error_', name, '.png'))
repartition_errors = plot_errors(stimuli);
saveas(repartition_errors, strcat('errors_', name, '.png'))
whisker_times = time_responses(stimuli);
saveas(whisker_times, strcat('whisker_plot_time_response_', name, '.png'))
comparison_color = mean_color_picture(stimuli);
cd(strcat('Figures_control\', name)) %go back to the new folder, as the comparison_color script changes directory
saveas(comparison_color, strcat('comparison_mean_colors_in_pictures_', name, '.png'))

%go back to the main folder
cd C:\Users\maell\Documents\ENS\Cours\Césure\Stage_Sliwa\MonkeyLogic\human_task_mc