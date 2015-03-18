

/* Etats du programme */

int GAME_STATE;
int START_MENU = 1;
int INIT_GAME = 2;
int INIT_LANCER = 3; // Moment où on choisit la vitesse et l'angle d'attaque
int LANCER_BOULE = 4; // Moment où la boule est lancée
int END_GAME = 10; // Moment où la boule est lancée


// Valeur d'échelle pour mieux voir la trajectoire
int scale = 100;
// La hauteur du sol
int hauteur_du_sol = 85; 

PImage background_img;



int index = 0;


CommandeManuelle commande_manuelle = new CommandeManuelle();
float player_force = 0;
float player_angle_dattaque = 0;



