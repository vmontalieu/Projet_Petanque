/* Toutes les méthodes de dessin sont réunies ici
 */

float compteur = 1;


  
  
void draw_menu()
{

  float cl = sin(compteur);
  compteur+=0.01;
  
  background(200+cl*50,200+cl*50,200+cl*100);
  
  image(menu_img, 0, 0);
  noFill(); 
  stroke(255,255,255);
  fill(255);
  stroke(4);

/*
    for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }*/
  
 /* for(int i = 0 ; i < compteur ; i++)
  {
    ellipse(window_size_x/2, window_size_y/2, i*10, i*10); 
  }
  compteur++;
  */ 
  

/*

  fill(0,0,0);
  textSize(64);
  textAlign(CENTER, CENTER);
  text("Petanque Project", 400, 200); 

  textSize(32);
  textAlign(CENTER, BOTTOM);
  text("Press [X] to start", 400, 400); 


  textSize(15);
  fill(100, 100, 100);
  textAlign(CENTER, BOTTOM);
  text("Nicolas Sintes, Maxime Touroute and Vincent Montalieu", 400, 30);
  textSize(20);
  text("presents", 400, 55); 
  fill(0, 0, 0);*/
  

}

void draw_game()
{
  // Le départ de lancement de la boule
  if (GAME_STATE == INIT_LANCER)
  {

    background(background_img);

    
    drawSpeedVector();
    draw_cochonnet();
    draw_boule();
    
    draw_legende();
    draw_texts();
  }

  // La boule est lancée
  else if (GAME_STATE == LANCER_BOULE)
  {
    background(background_img);

    
    draw_cochonnet();
    draw_trajectoire();

    if (CHEAT_MODE)
    {
      draw_trajectoire_triche();
      
      if(temps < commande.instant_fin_commande_triche)
      draw_reacteurs();
    }

    drawSpeedVector();
    draw_boule();
    
    draw_legende();
    draw_texts();
    
  } else if (GAME_STATE == END_GAME) // Fin du jeu, Afficher du texte, proposer de recommencer
  { 
    
    //draw_legende();
    
    textSize(60);
    textAlign(CENTER, CENTER);
    // TODO : affiner le réglage du out of bounds : apparait même si la boule est encore un peu à l'écran
    if (position_boule_x*SCALE < window_size_x)
    {
      text("SCORE:" + nf(score,1,0) + "%", 400, 120);
    } else
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


   //TODO bug
  for (int i = 0; (!CHEAT_MODE && i < temps) || (CHEAT_MODE && i < temps && i < commande.instant_fin_commande_manuelle-1); i++)
  {
    // Dessin de la ligne
    stroke(204, 0, 0);  // Couleur du trait
    strokeWeight( 2 ); //Epaisseur du trait
    line(commande.coordonnees_trajectoire_x[i]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y[i]*SCALE-HAUTEUR_SOL, 
    commande.coordonnees_trajectoire_x[i+1]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL); 

    // Points rouges
    strokeWeight(8); // Epaisseur du trait
    point(commande.coordonnees_trajectoire_x[i+1]*SCALE, window_size_y-commande.coordonnees_trajectoire_y[i+1]*SCALE-HAUTEUR_SOL);
  }
}

void draw_trajectoire_triche()
{


  // On fait ici attention de ne pas deborder sur la fin de trajectoire
  for (int i = 0; i < temps && i < commande.instant_fin_commande_triche; i++)
  {
    // Dessin de la ligne
    stroke(0, 204, 0);  // Couleur du trait
    strokeWeight( 4 ); //Epaisseur du trait
    line(commande.coordonnees_trajectoire_x_triche[i]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y_triche[i]*SCALE-HAUTEUR_SOL, 
    commande.coordonnees_trajectoire_x_triche[i+1]*SCALE, 
    window_size_y-commande.coordonnees_trajectoire_y_triche[i+1]*SCALE-HAUTEUR_SOL); 

    // Points verts
    strokeWeight(8); // Epaisseur du trait
    point(commande.coordonnees_trajectoire_x_triche[i+1]*SCALE, window_size_y-commande.coordonnees_trajectoire_y_triche[i+1]*SCALE-HAUTEUR_SOL);
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
Dessine une flamme derriere la boule
 */
void draw_reacteurs()
{

  strokeWeight(4);
  stroke(255,150,58);
  fill(255,0,0);

  //ellipse(0*SCALE, window_size_y-HAUTEUR_INITIALE*SCALE-HAUTEUR_SOL-5, 10, 10); 
  drawArrow( (int) (position_boule_x*SCALE),(int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ),
              (int) (position_boule_x*SCALE), (int) ( (window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5)-10*commande.vitesse_trajectoire_y[temps]) );
              
               drawArrow( (int) (position_boule_x*SCALE),(int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ),
              (int) ( (position_boule_x*SCALE) + 10*commande.vitesse_trajectoire_x[temps] ), (int) ( window_size_y-position_boule_y*SCALE-HAUTEUR_SOL-5 ) );
  
/* triangle( (position_boule_x*SCALE)+2, window_size_y-position_boule_y*SCALE-HAUTEUR_SOL, 
  (position_boule_x*SCALE)-2, window_size_y-position_boule_y*SCALE-HAUTEUR_SOL, 

  (position_boule_x*SCALE) - commande.vitesse_trajectoire_x[temps], 
  (window_size_y-position_boule_y*SCALE-HAUTEUR_SOL)+commande.vitesse_trajectoire_y[temps]);*/
}


/*
* Dessine le cochonnet !
 */
void draw_cochonnet()
{
  stroke(0, 0, 0);  // Couleur du trait
  strokeWeight(2);
  fill(255, 51, 51);
  ellipse(position_cochonnet*SCALE, window_size_y-HAUTEUR_SOL-4, 8, 8);
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
    text("X: " + nf(position_boule_x, 1, 2), 750,30);
    text("Y: " + nf(position_boule_y, 1, 2), 750, 50); 
    
    text("Vx: " + nf(commande.vitesse_trajectoire_x[temps], 1, 2), 670,30);
    text("Vy: " + nf(commande.vitesse_trajectoire_y[temps], 1, 2), 670, 50); 
    
    

    fill(0,0,0);
    textAlign(LEFT);
    textSize(15);
    text("Temps:" + int(temps) + " périodes", 410, 60);
    text("Strengh : " + nf(player_force, 1, 1) + "m/s",20 , 100);
    text("Angle    : " + int(player_angle_dattaque) + "°", 20, 120); 
    text("Balls: " + int(lancers_restants), 20, 140); 
    
    
    
    
    textAlign(LEFT);
    fill(20, 20, 51);
    
    textSize(20);
        if(CHEAT_MODE) text("Boucle Ouverte", 410, 35); 
    else  text("Commande Manuelle", 410, 30); 
    



  } else
  {
    textSize(15);
    textAlign(CENTER, CENTER);
    text("ERROR draw_texts()", 400, 20); 
    fill(0, 0, 0);
  }
}


void draw_legende()
{
  image(legende_img, 0, 0);
}

