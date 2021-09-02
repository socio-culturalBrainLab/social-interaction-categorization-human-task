hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
%This hotkey allows the experimentator to escape the experiment when they want 

bhv_code(10,'Fix',50, 'Step5',100,'Reward'); 
%Keep record of the events happening in the metadata

behavior_choosen = TrialRecord.User.current_behavior;
%store the behavior choosen for this condition 
other_unrelated_behaviors = TrialRecord.User.other_unrelated_behaviors;
%store the list of all the other behaviors of the other relationships

pos = EyeCal.norm2deg([0.2 0.2; 0.8 0.2; 0.5 0.5; 0.2 0.75; 0.8 0.75]);
%list of the 5 possible positions for the pictures

m = randi(5);
%pick 3 random numbers between 1 and 5 (will be the numbers of the
%positions choosen for displaying the pictures)

triangle = PolygonGraphic(touch_);
triangle.EdgeColor = [0 1 1];
triangle.FaceColor = [0 1 1];
triangle.Size = [6 6];
triangle.Position = [0 0];
triangle.Vertex = [0.5 1; 1 0.25; 0 0.25];
%create the fixation triangle presented at the beginning of each trial

coins = ImageGraphic(null_);
coins.List = {'coin.jpg', EyeCal.norm2deg([0.52 0.95]), 0.05};

nb_of_coins = TextGraphic(null_);
nb_of_coins.Text = num2str(TrialRecord.User.number_of_coins);
nb_of_coins.Position = EyeCal.norm2deg([0.48 0.94]);
nb_of_coins.FontColor = [1 1 1];
nb_of_coins.FontSize = 17;

between = CircleGraphic(null_);
between.EdgeColor = [0 0 0];
between.FaceColor = [0 0 0];
between.Size = [3 3];
between.Position = [0 0];
%create a waiting time between the fixation and the rest of the trial

cd Learning2 %go to the Learning folder to get the image of the behavior

cd(char(behavior_choosen)); %go in the folder of the choosen behavior
list_images = dir('*.bmp*');
rank = TrialRecord.User.pictures_left5(randi(length(TrialRecord.User.pictures_left5), 1)); 
im = ImageGraphic(touch_);
im.List = {char(list_images(rank).name), pos(m,:), 1.1}; 
%take a random image of the subfolder of the behavior choosen and present
%it in the random position choosen from the 5 positions possible
cd ../.. %go back to the main folder of the task

max_reaction_time = 7000;

% create scenes: fixation and presentation of another image of the choosen 
% behavior along with 2 other unrelated behaviors in random positions 
% of the screen (second learning phase)
fix1 = SingleTarget(triangle);  
fix1.Target = triangle.Position;  
fix1.Threshold = triangle.Size*1.3; 
wth1 = WaitThenHold(fix1);     
wth1.WaitTime = max_reaction_time;
wth1.HoldTime = 0; %no need to hold the click for a certain time 
con1 = Concurrent(wth1);
con1.add(coins);
con1.add(nb_of_coins);
scene_fix = create_scene(con1);  

btw = SingleTarget(between);
btw.Threshold = 0;
wthb = TimeCounter(btw);
wthb.Duration = 500; %waiting time of 0.5s between fixation and trial
con2 = Concurrent(wthb);
con2.add(coins);
con2.add(nb_of_coins);
scene_between = create_scene(con2);

fix5 = SingleTarget(im);
fix5.Target = im.Position;
fix5.Threshold = im.Size*1.3;
wth5 = WaitThenHold(fix5);
wth5.WaitTime = max_reaction_time;
wth5.HoldTime = 0; %no need to hold the click for a certain time
con = Concurrent(wth5);
con.add(coins);
con.add(nb_of_coins);
scene_step5 = create_scene(con);

% TASK:
error_type = 0; %initialisation of the error type recorded in the metadata

run_scene(scene_fix,10);        
rt = wth1.AcquiredTime;      
if wth1.Waiting %if the time waited is superior to the max reaction time        
    error_type = 1; %return error type 1 (waited time exceded in fixation)      
end
idle(0)

if 0==error_type %if the subject clicked on the fixation dot
    run_scene(scene_between); %run the waiting time and then the trial
    run_scene(scene_step5,50);
    rt = wth5.AcquiredTime;
    if wth5.Waiting %if the time waited is superior to the max reaction time 
        error_type = 2; %return error type 2 (waited time exceded in trial)
    end
end
idle(0)

% reward
if 0==error_type %if the trial is a success
    TrialRecord.User.pictures_left5(TrialRecord.User.pictures_left5 == rank) = [];
    
    TrialRecord.User.number_of_coins = TrialRecord.User.number_of_coins + 1;
    nb_of_coins = TextGraphic(null_);
    nb_of_coins.Text = num2str(TrialRecord.User.number_of_coins);
    nb_of_coins.Position = EyeCal.norm2deg([0.48 0.94]);
    nb_of_coins.FontColor = [1 1 1];
    nb_of_coins.FontSize = 17;
    snd = AudioSound(null_);
    snd.List = 'sound1.wav';
    sound1 = Concurrent(snd);
    sound1.add(coins);
    sound1.add(nb_of_coins);
    scene_sound1 = create_scene(sound1);
    
    run_scene(scene_sound1,100); %play the sound twice
    TrialRecord.User.number_of_coins = TrialRecord.User.number_of_coins + 1;
    
    nb_of_coins = TextGraphic(null_);
    nb_of_coins.Text = num2str(TrialRecord.User.number_of_coins);
    nb_of_coins.Position = EyeCal.norm2deg([0.48 0.94]);
    nb_of_coins.FontColor = [1 1 1];
    nb_of_coins.FontSize = 17;
    snd = AudioSound(null_);
    snd.List = 'sound2.wav'; 
    sound2 = Concurrent(snd);
    sound2.add(coins);
    sound2.add(nb_of_coins);
    scene_sound2 = create_scene(sound2);
    
    run_scene(scene_sound2,100);
    idle(0)
else
    idle(700); %otherwise, wait 0.7s before the next trial                
end

trialerror(error_type); %record the error type in the metadata 
 