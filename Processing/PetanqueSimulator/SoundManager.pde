/* Gestion du son 
 *  Maxime Touroute
 * Avril 2015
 */
import ddf.minim.*;


Minim music_minim;
Minim roll_fx_minim;
Minim score_fx_minim;

AudioPlayer music_player;
AudioPlayer roll_fx_player;
AudioPlayer score_fx_player;


void setup_sound()
{
  music_minim = new Minim(this);
  roll_fx_minim = new Minim(this);
  score_fx_minim = new Minim(this);

  roll_fx_player = roll_fx_minim.loadFile("fx_choc.mp3", 1024);
}

void play_music()
{
  music_player = music_minim.loadFile("theme_music.mp3", 1024);
  music_player.play();
}

void play_roll_fx()
{  
  roll_fx_player.play();
}
void play_score_fx()
{
  // Son différent selon le score
  if(CHEAT_MODE) score_fx_player = music_minim.loadFile("fx_score_cheat.mp3", 1024);
  else if (position_boule_x*SCALE > window_size_x+10) score_fx_player = music_minim.loadFile("fx_score_outofbounds.mp3", 1024);
  else if (score < 65)
    score_fx_player = music_minim.loadFile("fx_score_1.mp3", 1024);
  else if (score < 95)
    score_fx_player = music_minim.loadFile("fx_score_2.mp3", 1024);
  else
    score_fx_player = music_minim.loadFile("fx_score_3.mp3", 1024);

  score_fx_player.play();
}

void stop_sound()
{ 
  music_player.close();
  music_minim.stop();

  roll_fx_player.close();
  roll_fx_minim.stop();

  score_fx_player.close();
  score_fx_minim.stop();
  super.stop();
}

