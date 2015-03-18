
// La hauteur initiale du lancer
float hauteur_initiale = 1.0;

/*
Gestion de la commande manuelle
*/
class CommandeManuelle
{

  // Variables de conditions initiales
  float masse = 0.8;
  float gterre = 9.81;


  // Les deux vecteurs qui stockent les coordonnées de la trajectoire : limite de points imposée à 2000.
  float[] coordonnees_trajectoire_x = new float[2000];
  float[] coordonnees_trajectoire_y = new float[2000];



  // L'instant t d'execution
  int instant_t = 0;


  // Nos equations discretes 

  // MAtrice 4x4
  float[][] Ad = { 
    {
      1.0, 0.04, 0, 0
    }
    , 
    {
      0.0, 1.0, 0.0, 0.0
    }
    , 
    {
      0.0, 0.0, 1.0, 0.04
    }
    , 
    {
      0.0, 0.0, 0.0, 1.0
    }
  }; 

  // MAtrice 2x'4
  float[][] Bd = { 
    {
      0.0008, 0
    }
    , 
    {
      0.04, 0
    }
    , 
    {
      0, 0.0008
    }
    , 
    { 
      0, 0.04
    }
  }; 

    // Vecteur a
    float[][] a = { 
    {
      0
    }
    , 
    {
      -gterre
    }
  };


  // Vecteur initial
  float[][] X0 = {  
    {
      0
    }
    , 
    {
      0
    }
    , 
    {
      0
    }
    , 
    {
      0
    }
  }; 


  /*
  Initialisation des conditions initiales
  @params force, la force du lancer
  @p_angle_dattaque l'angle d'attaque du lancer
   */
  void set_conditions_initiales(float force, float p_angle_dattaque)
  {



    float angle_dattaque = p_angle_dattaque;

    // Calcul de la vitesse d'attaque
    float v0x = force * cos( radians(angle_dattaque) );
    float v0y = force * sin( radians(angle_dattaque) );

    // Vecteur de conditions initiales
    X0[0][0] = 0;
    X0[1][0] = v0x;
    X0[2][0] = hauteur_initiale;
    X0[3][0] = v0y;
  }



  float get_hauteur_initiale()
  {
    return hauteur_initiale;
  }

  /*
  * Calcule tous les points de trajectoire, et stocke les réultats 
  * dans les tableaux coordonnees_trajectoire_x et coordonnees_trajectoire_y
  */
  void compute_trajectoire()
  {

    // Initialisation du prochain vecteur à calculer
    float[][] Xsuivant = {  
      {
        0
      }
      , 
      {
        0
      }
      , 
      {
        0
      }
      , 
      {
        0
      }
    };

    // Le X précédent
    float[][] X = X0; // Le X d'avant

    // Stockage des premières valeurs
    coordonnees_trajectoire_x[0] = X[0][0]; // x
    coordonnees_trajectoire_y[0] = X[2][0]; // y

    while ( X[2][0] > 0 ) // Tant que la position en y est supérieure à 0 (par encore par terre)
    {
      // on réinitialise Xsuivant avant de ré-itérer la boucle
      Xsuivant[0][0] = 0;
      Xsuivant[1][0] = 0;
      Xsuivant[2][0] = 0;
      Xsuivant[3][0] = 0;

      instant_t++;

      // Produit matriciel inspiré de celui du code Scilab

      for (int i = 0; i < 4; i++) // Les 4 lignes
      {
        for (int j = 0; j < 4; j++) // les 4 colonnes
        {
          Xsuivant[i][0] += Ad[i][j]*X[j][0] ;//+ Bd*a;
        }
      }

      for (int i = 0; i < 4; i++) // ajout du terme Bd*a;
      {
        for (int j = 0; j < 2; j++)
        {

          Xsuivant[i][0] += Bd[i][j]*a[j][0];
        }
      }

      // L'ancien X devient le nouveau X.
      X[0][0] = Xsuivant[0][0];
      X[1][0] = Xsuivant[1][0];
      X[2][0] = Xsuivant[2][0];
      X[3][0] = Xsuivant[3][0];

      // Stockage des nouvelles coordonnées de trajectoire
      coordonnees_trajectoire_x[instant_t] = Xsuivant[0][0];
      coordonnees_trajectoire_y[instant_t] = Xsuivant[2][0];
    }
  }
}

