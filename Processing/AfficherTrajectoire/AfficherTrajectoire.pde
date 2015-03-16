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
int hauteur_du_sol = 50; // La hauteur du sol
// Stockage des coordonnées du point d'avant (pour dessiner une ligne)
float previous_x = 0;
float previous_y = 0;

// Valeur d'échelle pour mieux voir la trajectoire
int scale = 150;

void setup() {
  size(window_size_x, window_size_y);
  background(0);
  stroke(255);
  frameRate(12);
  // Stockage de la trajectoire sur une ligne
  String[] temp = loadStrings("trajectoire.txt");
  // Découpage par composantes
  lines = split(temp[0], ';');
}

void draw() {
  
  // Dessin du sol #SWAG
  line(0, window_size_y-hauteur_du_sol, window_size_x, window_size_y-hauteur_du_sol);
  line(0, window_size_y-hauteur_du_sol+1, window_size_x, window_size_y-hauteur_du_sol+1);
   line(0, window_size_y-hauteur_du_sol+2, window_size_x, window_size_y-hauteur_du_sol+2);
  for(int i = -40 ; i < window_size_x ; i+=20)
  {
     line(i, window_size_y-hauteur_du_sol, i+50, window_size_y);
  }
  
  if (index < lines.length) {
    String[] pieces = split(lines[index], ',');
    if (pieces.length == 2) {
      float x = float(pieces[0]) *scale ;
      float y = float(pieces[1]) *scale;
      // Mise à l'echelle pour la fenêtre
      // On s'arrête sur le sol !
      if(y < 0) y = 0; 
      print("x : %f, y : %f\n", x, y);
     
      if(previous_x != 0 && previous_y != 0)
      { // Dessin de la ligne
        line(previous_x, window_size_y-previous_y-hauteur_du_sol, x, window_size_y-y-hauteur_du_sol);
      }
      
      previous_x = x;
      previous_y = y;
    }
    // On stocke les vielles valeurs dans les variables previous
    
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}
