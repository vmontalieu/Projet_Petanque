/**
 * LoadFile 1
 * 
 * Loads a text file that contains two numbers separated by a tab ('\t').
 * A new pair of numbers is loaded each frame and used to draw a point on the screen.
 */

String[] lines;
int index = 0;
// Taille de la fenêtre
int window_size_x = 640;
int window_size_y = 480;
int hauteur_du_sol = 70; // La hauteur du sol
// Stockage des coordonnées du point d'avant (pour dessiner une ligne)
float previous_x = 0;
float previous_y = 0;

// Valeur d'échelle pour mieux voir la trajectoire
int scale = 150;

void setup() {
  size(window_size_x, window_size_y);
  background(0);
  stroke(255);
  frameRate(24);
  // Stockage de la trajectoire sur une ligne
  String[] temp = loadStrings("trajectoire.txt");
  // Découpage par composantes
  lines = split(temp[0], ';');
  
  //Background !
  PImage img;
  img = loadImage("Background.jpg");
  background(img);
}

void draw() {
  
  
  // Dessin du sol #SWAG (plus la peine avec le background)
  /*
  stroke(102, 51, 0);
  strokeWeight( 5 ); //Epaisseur du trait
  line(0, window_size_y-hauteur_du_sol, window_size_x, window_size_y-hauteur_du_sol);
  line(0, window_size_y-hauteur_du_sol+1, window_size_x, window_size_y-hauteur_du_sol+1);
   line(0, window_size_y-hauteur_du_sol+2, window_size_x, window_size_y-hauteur_du_sol+2);
  for(int i = -40 ; i < window_size_x ; i+=20)
  {
     line(i, window_size_y-hauteur_du_sol, i+50, window_size_y);
  }
  */
  
  /**************************/
  
  // Récupération des coordonnées x,y
  if (index < lines.length) {
    String[] pieces = split(lines[index], ',');
    if (pieces.length == 2) {
      float x = float(pieces[0]) *scale;
      float y = float(pieces[1]) *scale; 


      // Correction du y très négatif causé par le facteur scale
      if(y < 0) y = 0; 
      
      // Affichage des coordonnées
      print(x ,";", y, "\n");
     

       
      // Dessin de la ligne
      if(previous_x != 0 && previous_y != 0)
      { 
        stroke(204, 0, 0);  // Couleur du trait
        strokeWeight( 3 ); //Epaisseur du trait
        line(previous_x, window_size_y-previous_y-hauteur_du_sol, x, window_size_y-y-hauteur_du_sol); 
    
         // Points rouges

         strokeWeight(10); // Epaisseur du trait
         point(x, window_size_y-y-hauteur_du_sol);    
      }
      
      // On stocke les coordonnées dans les variables previous (pour dessiner le trait)
      previous_x = x;
      previous_y = y;
    }
    
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}
