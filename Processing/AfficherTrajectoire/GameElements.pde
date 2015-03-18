
/************* Constantes de jeu ****************/

// Etats du programme

int GAME_STATE;
int START_MENU = 1;
int INIT_LANCER = 3; // Moment où on choisit la vitesse et l'angle d'attaque
int LANCER_BOULE = 4; // Moment où la boule est lancée
int END_GAME = 10; // Moment où la boule est lancée

// Valeur d'échelle pour mieux voir la trajectoire
int SCALE = 100;
// La hauteur du sol
int HAUTEUR_SOL = 85; 

/************ Données du jeu ************/

PImage background_img;
int index = 0;
CommandeManuelle commande_manuelle = new CommandeManuelle();
float player_force = 0;
float player_angle_dattaque = 0;

/**************************************/


/*
* Création du jeu
*/
void setup_game()
{
  init_player_data();
  setup_sound();
  play_music();
  index = 0;
  GAME_STATE = START_MENU;
}

/**
 * Initialiser les variables pour une nouvelle partie
 */
void init_game() {
  // Chargement du background
  background_img = loadImage("Background.jpg");

  index = 0;
  init_player_data();
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


