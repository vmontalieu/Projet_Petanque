/*
  L'intelligence du jeu
 * Maxime Touroute
 * Avril 2015
 */
/*

 
 * Création du jeu
 */
void setup_game()
{
  init_player_data();
  setup_sound();
  play_music(); 
  temps = 0;
  menu_img = loadImage("menu.png");
  menu_x = loadImage("menu_x.png");
  GAME_STATE = START_MENU;
}

/*
 * Initialiser les variables pour une nouvelle partie
 */
void init_game() {
  // Chargement du background
  background_img = loadImage("Background.jpg");
  legende_img = loadImage("tableau_de_bord.png");
  temps = 0;
  // On réinitialise pas les paramètres du joueur (force et angle d'attaque)
  score = 0;

  // On retire un lancer si necessaire
  if (lancers_restants == 0)
  {

    init_cochonnet();
    lancers_restants = nombre_lancers;
  }
  lancers_restants--;

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
  position_cochonnet = random( 3, 10);
}

void update_game()
{
  // Le départ de lancement de la boule
  if (GAME_STATE == INIT_LANCER)
  {
  } else if (GAME_STATE == LANCER_BOULE)
  {
    // On avance dans le déplacement
    temps++;

    if (commande.coordonnees_trajectoire_y[temps] <= 0) commande.coordonnees_trajectoire_y[temps] = 0; // on arrondit le y.

    // Update de la position courante de la boule
    if (CHEAT_MODE && temps <= commande.instant_fin_commande_triche)
    {

      position_boule_x = commande.coordonnees_trajectoire_x_triche[temps];
      position_boule_y = commande.coordonnees_trajectoire_y_triche[temps];
    } else if (!CHEAT_MODE)
    {
      position_boule_x = commande.coordonnees_trajectoire_x[temps];
      position_boule_y = commande.coordonnees_trajectoire_y[temps];
    }


    // Lorsque que la boule a touchee le sol
    if ( (!CHEAT_MODE && position_boule_y <= 0) || (CHEAT_MODE && temps > commande.instant_fin_commande_triche) ) // Si fin de la trajectoire, fin de la partie
    {
      // Update the score
      float distance_max = 7;
      float distance = abs(position_cochonnet - position_boule_x);
      score = 0;

      if (distance/distance_max < 1) score = 100 -  100*((distance/distance_max));
      if (score > 98) score = 100;

      print("boule", position_boule_x, "cochonnet", position_cochonnet, "score", score, "\n");
      play_score_fx();

      draw_game(); // Dessine une dernière fois la scène

        GAME_STATE = END_GAME;
      compteur_dessin = 0;
    }
  } else if (GAME_STATE == END_GAME)
  {
  }
}

