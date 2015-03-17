/**
* Dessin de trajectoire
 */

String[] coordonnees_trajectoire;

/* Etats du programme */

int GAME_STATE;
int START_MENU = 1;
int INIT_GAME = 2;
int INIT_LANCER = 3; // Moment où on choisit la vitesse et l'angle d'attaque
int LANCER_BOULE = 4; // Moment où la boule est lancée
int END_GAME = 10; // Moment où la boule est lancée



// Valeur d'échelle pour mieux voir la trajectoire
int scale = 100;

int index = 0;
// Taille de la fenêtre
int window_size_x = 640;
int window_size_y = 480;
int hauteur_du_sol = 85; // La hauteur du sol


CommandeManuelle C = new CommandeManuelle();

PImage img;

float force = 0;
float angle_dattaque = 0;


void setup() 
{
  // Ouverture de la fenêtre
  size(window_size_x, window_size_y);
  background(0);
  stroke(255);
  frameRate(24);
  
  index = 0;
  force = 5;
  angle_dattaque = 45;
  
  GAME_STATE = START_MENU;
}

/*
Initialiser les variables pour une nouvelle partie
*/
void init_game()
{
  
  
  // Chargement du background
  img = loadImage("Background.jpg");
  index = 0;
  GAME_STATE = INIT_LANCER; // On enchaine sur l'init lancer
}

void draw() 
{
  
  key_events(); // gestion des évènements

  /****************** DESSIN ***********************/


  // Le Menu
  if(GAME_STATE == START_MENU) 
  {

   
    background(224,224,224);
    textSize(64);
    textAlign(CENTER,CENTER);
    text("Projet Petanque", 320, 200); 
    fill(0, 0, 0);

    textSize(32);
    textAlign(CENTER,BOTTOM);
    text("Press [X] to start", 320, 400); 
    fill(0, 0, 0);


  }

  else if(GAME_STATE == INIT_GAME)
  {
    init_game();
  }
  // Le départ de lancement de la boule
  else if (GAME_STATE == INIT_LANCER)
  {
    background(img);

    draw_texts();
    draw_boule();
  }

  else if(GAME_STATE == LANCER_BOULE)
  {
    background(img);

    draw_texts();
    draw_trajectoire();
    draw_boule();
  
  
    index++;
    
    if(C.coordonnees_trajectoire_y[index] <= 0 ) // Si fin de la trajectoire, fin de la partie
    {
      print("end game! index" + index + "instant_t" + C.instant_t);
      GAME_STATE = END_GAME;
    }

  }

  else if(GAME_STATE == END_GAME) // Fin du jeu, Afficher du texte, proposer de recommencer
  {
    
    textSize(30);
    textAlign(CENTER,CENTER);
    text("TRY AGAIN? [T]", 320, 60); 
    fill(0, 0, 0);
  }



  
  /**************************/
  
 
}

/*

* Gestion des évènements clavier

*/
void key_events()
{
  if(GAME_STATE == START_MENU)
  {
    
    if(key == 'x')
    {
      GAME_STATE = INIT_GAME;
    }
      

  }
  else if(GAME_STATE == INIT_GAME)
  {
    // rien.
  }

  else if(GAME_STATE == INIT_LANCER)
  {


    if(key == 'a') // monter l'angle
    {
      angle_dattaque += 1;
      if(angle_dattaque > 80) angle_dattaque = 80; // Limite
      // Faire tout les 
    }
    else if(key == 'z') // baisser l'angle
    {
      angle_dattaque -= 1;
      if(angle_dattaque < -80) angle_dattaque = -80; // Limite
    }
    else if(key == 'q') // Baisser force
    {
      force -= 0.1;
      if(force < 1) force = 1; // Limite
    }
    else if(key == 's') // Monter force
    {
      force += 0.1;
      if(force > 10) force = 10; // Limite
    }

    if(key == ' ') // Lancer la boule
    {
      C = new CommandeManuelle();
      C.set_conditions_initiales(force, angle_dattaque);
      C.compute_trajectoire();
      GAME_STATE = LANCER_BOULE;
      
    }
      
  }

  else if(GAME_STATE == END_GAME)
  {

    if(key == 't') // Retour au menu principal
    {
      GAME_STATE = INIT_GAME;
    }

  }

  key = 0; // Nettoyage de l'entrée sur key
}



/**********************************    Autres sous-fonctions ***********************************/



void draw_trajectoire()
{

  if(C.coordonnees_trajectoire_y[index] <= 0) C.coordonnees_trajectoire_y[index] = 0; // on arrondit le y.
  for(int i = 0 ; i < index ; i++)
  {
    // Dessin de la ligne
      
      stroke(204, 0, 0);  // Couleur du trait
      strokeWeight( 3 ); //Epaisseur du trait
      line(C.coordonnees_trajectoire_x[i]*scale,
            window_size_y-C.coordonnees_trajectoire_y[i]*scale-hauteur_du_sol,
           C.coordonnees_trajectoire_x[i+1]*scale,
             window_size_y-C.coordonnees_trajectoire_y[i+1]*scale-hauteur_du_sol); 
  
       // Points rouges
       strokeWeight(10); // Epaisseur du trait
       point(C.coordonnees_trajectoire_x[i+1]*scale, window_size_y-C.coordonnees_trajectoire_y[i+1]*scale-hauteur_du_sol); 


  }
}

/*
Dessine la boule
*/
void draw_boule()
{
  stroke(64, 64, 64);  // Couleur du trait
  strokeWeight(10);

  if(GAME_STATE == INIT_LANCER)
    ellipse(0*scale, window_size_y-hauteur_initiale*scale-hauteur_du_sol-5, 10, 10); 

  else
    ellipse(C.coordonnees_trajectoire_x[index+1]*scale, window_size_y-C.coordonnees_trajectoire_y[index+1]*scale-hauteur_du_sol-5, 10, 10); 

}

/*
Draw the texts
*/
void draw_texts()
{
  if(GAME_STATE == LANCER_BOULE || GAME_STATE == END_GAME || GAME_STATE == INIT_LANCER)
  {
    textSize(15);
    textAlign(CENTER,CENTER);
    fill(0, 0, 0);
    text("X:" + C.coordonnees_trajectoire_x[index] + "          Y:" + C.coordonnees_trajectoire_y[index], 320, 20); 
    

    textSize(15);
    textAlign(CENTER,CENTER);
    fill(0, 0, 0);
    text("Force: " + force + "\nAngle: " + angle_dattaque, 500, 20); 
    

    textSize(15);
    fill(255, 255, 255);
    textAlign(CENTER,CENTER);
    text("Controle de la force: Q-S " + "\nControle de l'angle: A-Z", 100, 450); 
    

  }

  else
  {
    textSize(15);
    textAlign(CENTER,CENTER);
    text("ERROR draw_texts()", 320, 20); 
    fill(0, 0, 0);
  }
}

