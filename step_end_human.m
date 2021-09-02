hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
%This hotkey allows the experimentator to escape the experiment when they
%want

bhv_code(80,'Step_end'); 
%Keep record of the events happening in the metadata

e = TextGraphic(null_);
e.Text = 'Fin de la tâche, merci de votre participation !';
%create a screen at the end of the task telling that it's the end of it
e.Position = EyeCal.norm2deg([0.5 0.4]);
e.FontSize = 20;
e.FontColor = [1 1 1];
e.HorizontalAlignment = 'center';
e.VerticalAlignment = 'middle';
tc = TimeCounter(e);
tc.Duration = 10000;

txt_coins = TextGraphic(null_);
txt_coins.Text = 'Votre nombre total de pièces amassées est de :';
%add a text to display the total number of coins the subject gained during
%the task
txt_coins.Position = EyeCal.norm2deg([0.5 0.6]);
txt_coins.FontSize = 20;
txt_coins.FontColor = [1 1 1];
txt_coins.HorizontalAlignment = 'center';
txt_coins.VerticalAlignment = 'middle';

nb_of_coins = TextGraphic(null_);
nb_of_coins.Text = num2str(TrialRecord.User.number_of_coins);
%display the total number of coins
nb_of_coins.Position = EyeCal.norm2deg([0.48 0.8]);
nb_of_coins.FontColor = [1 1 1];
nb_of_coins.FontSize = 17;

coins = ImageGraphic(null_);
coins.List = {'coin.jpg', EyeCal.norm2deg([0.52 0.8]), 0.05};
%display the picture of the coins 

conc = Concurrent(tc);
conc.add(txt_coins)
conc.add(nb_of_coins)
conc.add(coins)
%display all the texts and the number of coins and the picture of the coins
%on the same screen
scene = create_scene(conc);
run_scene(scene);
idle(0);