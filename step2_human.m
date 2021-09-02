hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
%This hotkey allows the experimentator to escape the experiment when they want 

bhv_code(10,'Fix',20, 'Step2',100,'Reward'); 
%Keep record of the events happening in the metadata

behavior_choosen = TrialRecord.User.current_behavior;
%store the behavior choosen for this condition 

pos = EyeCal.norm2deg([0.2 0.2; 0.8 0.2; 0.5 0.5; 0.2 0.75; 0.8 0.75]);
%list of the 5 possible positions for the pictures

m = randi(5);
%pick a random number between 1 and 5 (will be the number of the position
%choosen for displaying the picture)

triangle = PolygonGraphic(touch_);
triangle.EdgeColor = [1 1 0];
triangle.FaceColor = [1 1 0];
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

cd Learning1 %go to the Learning folder to get the image of the behavior
cd(char(behavior_choosen));
list_images = dir('*.bmp*');
im = ImageGraphic(touch_);
im.List = {char(list_images(1).name), pos(m,:), 1.1}; 
%take the last image of the subfolder of the behavior choosen and present
%it in the random position choosen from the 5 positions possible

cd ..\.. %go back to the main folder of the task
snd = AudioSound(null_);
snd.List = 'sound1.wav';  
scene_sound1 = create_scene(snd);

snd = AudioSound(null_);
snd.List = 'sound2.wav';  
scene_sound2 = create_scene(snd);
%create the sound played when the subject successes at the trial

max_reaction_time = 7000;

% create scenes: fixation and presentation of the choosen behavior in a
% random position of the screen
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

fix2 = SingleTarget(im);
fix2.Target = im.Position;
fix2.Threshold = im.Size*1.3;
wth2 = WaitThenHold(fix2);
wth2.WaitTime = max_reaction_time;
wth2.HoldTime = 0; %no need to hold the click for a certain time
con = Concurrent(wth2);
con.add(coins);
con.add(nb_of_coins);
scene_step2 = create_scene(con);

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
    run_scene(scene_step2,20);
    rt = wth2.AcquiredTime;
    if wth2.Waiting %if the time waited is superior to the max reaction time  
        error_type = 2; %return error type 2 (waited time exceded in trial)      
    end
end
idle(0)

% reward
if 0==error_type %if the trial is a success
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
    idle(0);
else
    idle(700); %otherwise, wait 0.7s before the next trial               
end

trialerror(error_type); %record the error type in the metadata 
 