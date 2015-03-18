/* Gestion du son 
*  18/03/2015
*  Maxime Touroute
*/


import ddf.minim.*;


Minim music_minim;
Minim fx_minim;

AudioPlayer music_player;
AudioPlayer fx_player;
  
void setup_sound()
{
  music_minim = new Minim(this);
  fx_minim = new Minim(this);
  fx_player = fx_minim.loadFile("fx_choc.mp3", 1024);
}

void play_music()
{
  music_player = music_minim.loadFile("theme_music.mp3", 1024);
  music_player.play();
}

void play_fx()
{
     
    fx_player.play();
}

void stop_sound()
{
  music_player.close();
  music_minim.stop();
  
  fx_player.close();
  fx_minim.stop();
  super.stop();
  
}


