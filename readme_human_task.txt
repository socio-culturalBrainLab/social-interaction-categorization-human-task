Intention
This task is designed as a tactile task for humans, for comparison with a tactile task for non-human primates. The goal is to see if the participants are able to categorize social interactions depending on the kind of relationship displayed (kinship, friendship or hierarchy). To do so, we chose 3 behaviors for each relationship, plus 2 controls (individual alone and individuals not interacting), resulting in 11 different categories. 
Participants have to click on one picture between 3 shown at the same time. 
The task is divided in two steps. The first step is composed of a learning phase where the participants learn to click on a specific picture of one of the behaviors, followed by a test phase where we evaluate if the participant is able to generalize to other pictures of that same behavior. The second step is composed of a learning phase where the participants learn to click on pictures of one of the behaviors, followed by a test phase where we evaluate if the participant is able to generalize to pictures of the other 2 behaviors of the same relationship. 
The learning phases are composed of several sub-steps, and the participant can go to the next sub-step only if she has succeed enough times. During these phases, the participant is rewarded (2 coins) is she clicks on the good picture, and nothing happens if she clicks on a wrong picture. The test phases are a mix between presentation of the test pictures, and presentation of the pictures already presented during the learning phases. During the presentation of test pictures, the participant is rewarded (1 coin) no matter which picture she clicks on, so that there is no learning during this phase. Each test picture (20 in total for each condition) is shown once.
The participant undergoes several conditions so that within-subject comparison is possible. First, all conditions are done for generalisation 1, then all conditions are done for generalisation 2 (the ordre of the conditions is shuffled between generalisation 1 and generalisation 2). Between each condition, the participant has to click several times on the fixation triangle, to indicate the she enters a new condition. 
As we want to compare with a task with non-human primates, the bare minimum of instruction is told to the participants before the beginning of the task (only that coins represent a recompense). 
The task should last around 1hour.


Files needed (all in the same folder!)
- task_human.txt 
- task_human.m
- sound1.wav
- sound2.wav
- coin.jpg
- step1_human.m
- step2_human.m
- step3_human.m
- step4_human.m
- step5_human.m
- step6_human.m
- step7_human.m
- Learning1 folder (with all the pictures in it)
- Learning2 folder
- Test1 folder
- Test2 folder 

How to run the task
Make sure monkeylogic is installed on the computer you use. Open Matlab, and then open monkeylogic. Load the task_human.txt by clicking on "to start, load a condition file". Make sure the total # of trials to run is up to 99999 so that the task doesn't end in the middle of it. File the subject name, and make sure the filename format is : yymmdd_HHMMSS_cname_sname. 
Click on the video settings, and make sure the subject screen device is the good one (if you use 2 screens) and it has the correct size. If you only use 1 screen, click on the "Forced use of fallback screen" and adjust the size of the rectangle to the size of the screen (so that it appears full screen).
Click on the input/output settings, then on other device settings, and make sure touchscreen is clicked. 
Click on the task settings, and adjust the ITI to the time you want (usually 500ms). 
(You can save these settings by clicking on "save settings" on the right bottow corner of the main menu)
Once all the above is done, you can click on run. It will load all the stimuli necessary, then click on "start" to start the task. The window should close by itself once the task is finished. 
A .bhv2 file is created with all the informations about how the task went. To load it, you can use the function mlread("[name_of_the_file]") in matlab 


Adjustable parameters 
- min number of success to go from one sub-step to another : TrialRecord.User.min_success (in task_human.m)

- number of conditions the participant sees : TrialRecord.User.success_count (in task_human.m)

- min number of success to go from fixation only to fixation and picture (the step between each condition) : in case 1.1 and case 1.2, "if TrialRecord.User.initialisation > [number]" (in task_human.m) be careful it is in 2 cases, change both if you change it!

- the ratio of presentation of test pictures vs learning pictures in the test phases : in case 4 and case 7, "if proba > [number]" (in task_human.m), be careful it is in 2 cases, change both if you change it!

- the reaction time (if the participant doesn't answer within this time, the pictures disapear and fixation comes back) : max_reaction_time (in all step[number]_human.m)

- in all steps, you can change the size of the stimuli, their positions, colors...