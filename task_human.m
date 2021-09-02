function [C,timingfile,userdefined_trialholder] = task_human(MLConfig,TrialRecord)
C = [];
timingfile = {'step1_1_human.m','step1_2_human.m','step2_human.m','step3_human.m', 'step4_human.m', 'step5_human.m', 'step6_human.m', 'step7_human.m', 'step_end_human.m'}; %the scripts for the different TrialRecord.User.steps
userdefined_trialholder = '';

persistent timing_filenames_retrieved
if isempty(timing_filenames_retrieved) %Only if it is the first time the function is called
    TrialRecord.User.number_of_coins = 0; %initialisation of the number of coins the participant has
    TrialRecord.User.initialisation = 0; %initialisation of the number of presentation of the initialisation step (only triangle shown)
    TrialRecord.User.nb_of_conditions = 3; %set the number of conditions to be runned
    TrialRecord.User.success_count = 0; %the total number of successful attempts
    TrialRecord.User.min_success = 5; %min of successfull trials to reach the next step
    TrialRecord.User.list_behaviors = {'ind_alone','ind_no_interaction','kinship_holding','kinship_grooming', 'kinship_observing','friendship_grooming', 'friendship_sitting_close', 'friendship_foraging','hierarchy_mounting','hierarchy_fighting','hierarchy_chasing'}; %all the behaviors shown
    TrialRecord.User.relationships = {'kinship', 'friendship', 'hierarchy'}; %the 3 kinds of relationships shown
    TrialRecord.User.behaviors_choosen = {}; %initialisation of which behaviors will be shown 
    TrialRecord.User.step = 1.1; %initialisation of the step the subject is at in the current condition
    TrialRecord.User.pictures_left4 = []; %initialisation of the pictures to show in step 4
    TrialRecord.User.pictures_left5 = []; %initialisation of the pictures to show in step 5 
    TrialRecord.User.pictures_left7 = []; %initialisation of the pictures to show in the last step
    TrialRecord.User.condition = 1; %initialisation of the current condition 
    
    TrialRecord.User.behaviors_choosen = TrialRecord.User.list_behaviors(randperm(9, TrialRecord.User.nb_of_conditions) + 2); %select n behaviors at random in the behaviors possible without the 2 first ones
    TrialRecord.User.current_behavior = TrialRecord.User.behaviors_choosen(TrialRecord.User.condition); %set which is the behavior for this condition
    TrialRecord.User.other_unrelated_behaviors = {}; %initialisation of the behaviors belonging to the other relationships than the one choosen
    
    cd Test1 %go to the Test1 folder to get the image of the behavior
    cd(char(TrialRecord.User.current_behavior)); %go the folder of the behavior choosen
    list_images = dir('*.bmp*');
    size_im = size(list_images,1);
    TrialRecord.User.pictures_left4 = linspace(1, size_im, size_im);
    TrialRecord.User.pictures_left5 = linspace(1, size_im, size_im);
    cd ../..
    
    
    cd Test2 %go to the Test2 folder to get the image of the behavior
    cd(char(TrialRecord.User.current_behavior)); %go the folder of the behavior choosen
    list_images = dir('*.bmp*');
    size_im = size(list_images,1);
    TrialRecord.User.pictures_left7 = linspace(1, size_im, size_im);
    cd ../..
    
    for i = 1:3
        if contains(char(TrialRecord.User.current_behavior), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
            TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
            break %stops once the relationship has been found 
        end
    end
    
    for i = 1:11 %for all behaviors except the one choosen
        if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
            TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
        end
    end  
    
    timing_filenames_retrieved = true;
    return
end

switch TrialRecord.User.step %switch to the different steps according to the number of successful trials 
    case 1.1
        timingfile = 'step1_1_human.m';
        if isempty(TrialRecord.TrialErrors) %if it is the first attempt
            TrialRecord.User.initialisation = TrialRecord.User.initialisation + 1;
        elseif 0==TrialRecord.TrialErrors(end) %if the last attempt is successful
            TrialRecord.User.initialisation = TrialRecord.User.initialisation + 1; %add one to the count of successful attempts
        end
        if TrialRecord.User.initialisation > 1 %if the number of successful events is superior to 4
            TrialRecord.User.step = 2; %go to the next step
            TrialRecord.User.initialisation = 0; %re-initialise the initialisation
        end
        
    case 2
        timingfile = 'step2_human.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success
            TrialRecord.User.step = 3; 
        end
        
    case 3
        timingfile = 'step3_human.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*2
            TrialRecord.User.step = 4; 
        end
    
    case 4 
        if isempty(TrialRecord.User.pictures_left4) %if all test pictures have been presented
            
            if TrialRecord.User.condition == TrialRecord.User.nb_of_conditions %if all the conditions have been made for generalisation 1
                TrialRecord.User.step = 1.2; %go to the initialisation step of generalisation 2 
                TrialRecord.User.condition = 1; %re-initialise the condition we're in 
                TrialRecord.User.behaviors_choosen = TrialRecord.User.behaviors_choosen(randperm(TrialRecord.User.nb_of_conditions)); %randomize the order of presentation of the behaviors for generalisation 2
                TrialRecord.User.current_behavior = TrialRecord.User.behaviors_choosen(TrialRecord.User.condition);
                TrialRecord.User.success_count = 0;
                TrialRecord.User.other_unrelated_behaviors = {};
                
                for i = 1:3
                    if contains(char(TrialRecord.User.current_behavior), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
                        TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
                        break %stops once the relationship has been found 
                    end
                end

                for i = 1:11 %for all behaviors except the one choosen
                    if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
                        TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
                    end
                end
                
                
            else
                TrialRecord.User.step = 1.1;
                TrialRecord.User.condition = TrialRecord.User.condition + 1;
                TrialRecord.User.current_behavior = TrialRecord.User.behaviors_choosen(TrialRecord.User.condition);
                TrialRecord.User.success_count = 0;
                TrialRecord.User.other_unrelated_behaviors = {};
                
                cd Test1 %go to the Test1 folder to get the image of the behavior
                cd(char(TrialRecord.User.current_behavior)); %go the folder of the behavior choosen
                list_images = dir('*.bmp*');
                size_im = size(list_images,1);
                TrialRecord.User.pictures_left4 = linspace(1, size_im, size_im);
                %bhv_variable(strcat('condition_',num2str(TrialRecord.User.condition), '_generalisation1'), TrialRecord.User.pictures_left4);
                cd ../..
                
                for i = 1:3
                    if contains(char(TrialRecord.User.current_behavior), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
                        TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
                        break %stops once the relationship has been found 
                    end
                end

                for i = 1:11 %for all behaviors except the one choosen
                    if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
                        TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
                    end
                end
            end
            
        else
            proba = rand; %test step: on 50 pourcents of the trials, it is a test, the other 50 pourcents are learning trials
            if proba > 0.5 %pick a random number and see if it is above 0.5 or not (simulation of probabilities) 
                timingfile = 'step4_human.m'; %if it is above 0.5, test trial
            else
                timingfile = 'step3_human.m';
            end
        end
        
    case 1.2
        timingfile = 'step1_2_human.m';
        if 0==TrialRecord.TrialErrors(end) %if the last attempt is successful
            TrialRecord.User.initialisation = TrialRecord.User.initialisation + 1; %add one to the count of successful attempts
        end
        if TrialRecord.User.initialisation > 1 %if the number of successful events is superior to 4
            TrialRecord.User.step = 5; %go to the next step
            TrialRecord.User.initialisation = 0; %re-initialise the initialisation
        end
        
     
    case 5
        if isempty(TrialRecord.User.pictures_left5)
             TrialRecord.User.step = 6;
        else
            timingfile = 'step5_human.m';
        end
        
        
        
    case 6
        timingfile = 'step6_human.m';
        if 0==TrialRecord.TrialErrors(end)
            TrialRecord.User.success_count = TrialRecord.User.success_count + 1;
        end
        if TrialRecord.User.success_count > TrialRecord.User.min_success*4
             TrialRecord.User.step = 7;
        end
        
    case 7
        if isempty(TrialRecord.User.pictures_left7) %if all test pictures have been presented
            if TrialRecord.User.condition == TrialRecord.User.nb_of_conditions
                timingfile = 'step_end_human.m';
                TrialRecord.Quit = true; %quit the session
            else
                TrialRecord.User.condition = TrialRecord.User.condition + 1;
                TrialRecord.User.step = 1.2;
                TrialRecord.User.current_behavior = TrialRecord.User.behaviors_choosen(TrialRecord.User.condition);
                TrialRecord.User.success_count = 0;
                TrialRecord.User.other_unrelated_behaviors = {};
                
                cd Test2 %go to the Test2 folder to get the image of the behavior
                cd(char(TrialRecord.User.current_behavior)); %go the folder of the behavior choosen
                list_images = dir('*.bmp*');
                size_im = size(list_images,1);
                TrialRecord.User.pictures_left5 = linspace(1, size_im, size_im);
                cd ../..
                
                cd Test2 %go to the Test2 folder to get the image of the behavior
                cd(char(TrialRecord.User.current_behavior)); %go the folder of the behavior choosen
                list_images = dir('*.bmp*');
                size_im = size(list_images,1);
                TrialRecord.User.pictures_left7 = linspace(1, size_im, size_im);
                cd ../..
                
                for i = 1:3
                    if contains(char(TrialRecord.User.current_behavior), TrialRecord.User.relationships(i)) %look which kind of relationship the behavior choosen is part of
                        TrialRecord.User.relationship_choosen = TrialRecord.User.relationships(i); %store the relationship choosen
                        break %stops once the relationship has been found 
                    end
                end

                for i = 1:11 %for all behaviors except the one choosen
                    if ~contains(TrialRecord.User.list_behaviors(i), TrialRecord.User.relationship_choosen) %if the behavior is part of the relationship choosen
                        TrialRecord.User.other_unrelated_behaviors{end+1} = char(TrialRecord.User.list_behaviors(i)); %add the others to the list of unrelated behaviors
                    end
                end
            end
        else
            proba = rand;
            if proba > 0.7
                timingfile = 'step7_human.m';
            else
                timingfile = 'step6_human.m';
            end
        end
        
end

end
