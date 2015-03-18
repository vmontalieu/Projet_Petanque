/* Ce fichier contient toute l'intelligence du jeu */


/*
* Création du jeu
*/
void setup_game()
{
  init_player_data();
  setup_sound();
  play_music(); 
  temps = 0;
  GAME_STATE = START_MENU;
}

/*
 * Initialiser les variables pour une nouvelle partie
 */
void init_game() {
  // Chargement du background
  background_img = loadImage("Background.jpg");


  temps = 0;
  
  // On réinitialise pas les paramètres du joueur (force et angle d'attaque)
  score = 0;
  init_cochonnet();
  init_boule();
  
  GAME_STATE = INIT_LANCER; // On enchaine sur l'init lancer
}


/*
Initialise les données liées au joueur
*/
void init_player_data()
{
  player_force = 5;
  player_angle_dattaque = 45;
  

}

void init_boule()
{
    position_boule_x = 0;
    position_boule_y = HAUTEUR_INITIALE;
}

void init_cochonnet()
{
  position_cochonnet = int(random( window_size_x/5, window_size_x - window_size_x/5));
}

void update_game()
{
  // Le départ de lancement de la boule
  if (GAME_STATE == INIT_LANCER)
  {
    
  }
  //
  else if (GAME_STATE == LANCER_BOULE)
  {
    // On avance dans le déplacement
    temps++;
    // Update de la position courante de la boule
    position_boule_x = commande_manuelle.coordonnees_trajectoire_x[temps];
    position_boule_y = commande_manuelle.coordonnees_trajectoire_y[temps];
    // Normalisation de position_boule
    
    
    
    if (position_boule_y <= 0 ) // Si fin de la trajectoire, fin de la partie
    {
      
      
      // Update the score
      score =  int(100* (1 - ( abs(position_cochonnet - position_boule_x*SCALE)/window_size_x )));
      play_score_fx();
      GAME_STATE = END_GAME;
    }
  }
  else if (GAME_STATE == END_GAME)
  {
  
  }
  
}
