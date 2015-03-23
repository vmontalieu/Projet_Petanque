/* Toutes les méthodes de dessin sont réunies ici
*/

void draw_menu()
{
  
    background(224, 224, 224);
    textSize(64);
    textAlign(CENTER, CENTER);
    text("Projet Petanque", 400, 200); 
    fill(0, 0, 0);

    textSize(32);
    textAlign(CENTER, BOTTOM);
    text("Press [X] to start", 400, 400); 
    
    
    textSize(15);
    fill(100, 100, 100);
    textAlign(CENTER, BOTTOM);
    text("Nicolas Sintes, Maxime Touroute and Vincent Montalieu", 400, 30);
    textSize(20);
    text("presents", 400, 55); 
    fill(0, 0, 0);
    
}

void draw_game()
{
  // Le départ de lancement de la boule
  if (GAME_STATE == INIT_LANCER)
  {
    
    background(background_img);

    draw_texts();
    drawSpeedVector();
    draw_cochonnet();
    draw_boule();
  }
  
  // La boule est lancée
  else if (GAME_STATE == LANCER_BOULE)
  {
    background(background_img);

    draw_texts();
    draw_cochonnet();
    draw_trajectoire();
    drawSpeedVector();
    draw_boule();
  }
  
  else if (GAME_STATE == END_GAME) // Fin du jeu, Afficher du texte, proposer de recommencer
  {   
    textSize(60);
    textAlign(CENTER, CENTER);
    if(score > 0)
    {
      text("SCORE:" + score + "%", 400, 120); 
    }
    else
    {
      text("OUT OF BOUNDS !", 400, 120); 
    }
    
    
    
    fill(0, 0, 0);
    textSize(25);
    textAlign(CENTER, CENTER);
    text("TRY AGAIN? [T]", 400, 170); 
    fill(0, 0, 0);
  }

}


void draw_trajectoire()
{

  
  
  for (int i = 0; i < temps; i++)
  {
    // Dessin de la ligne
    stroke(204, 0, 0);  // Couleur du trait
    strokeWeight( 2 ); //Epaisseur du trait
    line(commande_manuelle.coordonnees_trajectoire_x[i]*SCALE, 
    window_size_y-commande_manuelle.coordonnees_trajectoire_y[i]*SCALE-HAUTEUR_SOL, 
    commande_manuelle.coordonnees_trajectoire_x[i+1]*SCALE, 
    window_size_y-commande_manuelle.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL); 

    // Points rouges
    strokeWeight(8); // Epaisseur du trait
    point(commande_manuelle.coordonnees_trajectoire_x[i+1]*SCALE, window_size_y-commande_manuelle.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL);
  }
}

/*
Dessine la boule
 */
void draw_boule()
{
  stroke(64, 64, 64);  // Couleur du trait
  strokeWeight(10);

  if (GAME_STATE == INIT_LANCER)
    ellipse(0*SCALE, window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-5, 10, 10); 

  else
    ellipse(position_boule_x*SCALE, window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5, 10, 10);
}

/*
* Dessine le cochonnet !
*/
void draw_cochonnet()
{
  stroke(0,0 ,0);  // Couleur du trait
  strokeWeight(2);
  fill(255,51,51);
  ellipse(position_cochonnet, window_size_y-HAUTEUR_SOL-4, 8, 8);
}

/**
 * Dessine le vecteur vitesse initiale
 */
void drawSpeedVector() {
  stroke(0, 0, 255);  // Couleur du trait
  strokeWeight(5); //Epaisseur du trait
  drawArrowPolar(0*SCALE, int(window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-5), int(player_force*20), int(player_angle_dattaque));
}

/**
 * Dessine un vecteur en coordonées polaires avec repère inversé selon les y
 */
void drawArrowPolar(int x_origine, int y_origine, int r, int theta) {
  drawArrow(x_origine, y_origine, x_origine + int(r*cos(radians(theta))), y_origine - int(r*sin(radians(theta))));
}

/**
 * Dessine un vecteur en coordonées cartésiennes
 */
void drawArrow(int x1, int y1, int x2, int y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
}

/*
Draw the texts
 */
void draw_texts()
{
  if (GAME_STATE == LANCER_BOULE || GAME_STATE == END_GAME || GAME_STATE == INIT_LANCER)
  {
    textSize(15);
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    text("X:" + nf(position_boule_x, 1, 2) + "          Y:" + nf(position_boule_y, 1, 2), 350, 20); 


    textSize(15);
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    text("Force: " + nf(player_force, 1, 1) + " m/s\nAngle: " + int(player_angle_dattaque) + "°", 500, 20); 


    textSize(15);
    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    text("Controle de la force: GAUCHE-DROITE " + "\nControle de l'angle: HAUT-BAS", 10, 420);
  } else
  {
    textSize(15);
    textAlign(CENTER, CENTER);
    text("ERROR draw_texts()", 400, 20); 
    fill(0, 0, 0);
  }
}
