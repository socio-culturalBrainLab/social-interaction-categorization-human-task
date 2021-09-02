hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
%This hotkey allows the experimentator to escape the experiment when they want 

bhv_code(10,'Step1',100,'Reward'); 
%Keep record of the events happening in the metadata

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

max_reaction_time = 7000;

% scene: fixation
fix1 = SingleTarget(triangle);  
fix1.Target = triangle.Position;  
fix1.Threshold = triangle.Size*1.3; 
wth1 = WaitThenHold(fix1);     
wth1.WaitTime = max_reaction_time;
wth1.HoldTime = 0; %no need to hold the click for a certain time 
con = Concurrent(wth1);
con.add(coins);
con.add(nb_of_coins);
scene = create_scene(con);  

% TASK:
error_type = 0; %initialisation of the error type recorded in the metadata

run_scene(scene,10);        
rt = wth1.AcquiredTime;      
if wth1.Waiting %if the time waited is superior to the max reaction time          
    error_type = 1; %return error type 1 (waited time exceded in fixation)
end

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
