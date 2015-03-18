
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
int HAUTEUR_SOL = 70; 
// La hauteur initiale du lancer
float HAUTEUR_INITIALE = 1.0;

/************ Données du jeu ************/

PImage background_img;
int temps = 0;
CommandeManuelle commande_manuelle = new CommandeManuelle();



/* Données du joueur */
float player_force = 0;
float player_angle_dattaque = 0;
float position_boule_x;
float position_boule_y;
int score;

int position_cochonnet;

/**************************************/





