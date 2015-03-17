
float hauteur_initiale = 1.0;

class CommandeManuelle
{

  float masse = 0.8;
  float gterre = 9.81;


  // Les deux vecteurs qui stockent les coordonnées de la trajectoire
  float[] coordonnees_trajectoire_x = new float[2000];
  float[] coordonnees_trajectoire_y = new float[2000];



  // Te : osef, déjà inclus dans les fonctions

  int instant_t = 0; // instant t


  // Nos equations discretes 
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
  }; // MAtrice 4x4


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
  }; // MAtrice 2x'4


    float[][] a = { 
    {
      0
    }
    , 
    {
      -gterre
    }
  };



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
  }; // Vecteur 


  /*
  Initialisation des conditions initiales
   */
  void set_conditions_initiales(float force, float p_angle_dattaque)
  {



    float angle_dattaque = p_angle_dattaque;
    float v0x = force * cos( radians(angle_dattaque) );
    float v0y = force * sin( radians(angle_dattaque) );

    print("v0x:" + v0x + "  v0y:" + v0y + "\n");

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


  void compute_trajectoire()
  {
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
    }; // Le nouveau X qu'on calcule

    float[][] X = X0; // Le X d'avant

    print(X[2][0]+"\n");

    coordonnees_trajectoire_x[0] = X[0][0]; // x
    coordonnees_trajectoire_y[0] = X[2][0]; // y

    print("INIT: " + coordonnees_trajectoire_x[0] + "," +  coordonnees_trajectoire_y[0] + ";\n");

    while ( X[2][0] > 0 ) // Tant que la position en y est supérieure à 0 (par encore par terre)
    {
      // on réinitialise Xsuivant
      Xsuivant[0][0] = 0;
      Xsuivant[1][0] = 0;
      Xsuivant[2][0] = 0;
      Xsuivant[3][0] = 0;


      // print("X" + instant_t + "\n" + X[0][0]  + "\n" + X[1][0] + "\n" + X[2][0] + "\n" + X[3][0] + "\n\n");

      instant_t++;
      // [rows][cols]
      float[][] temp = { 
        {
          0
        }
        , {
          0
        }
        , {
          0
        }
        , {
          0
        }
      };
      for (int i = 0; i < 4; i++) // Les 4 lignes
      {
        for (int j = 0; j < 4; j++) // les 4 colonnes
        {
          Xsuivant[i][0] += Ad[i][j]*X[j][0] ;//+ Bd*a;
          temp[i][0] += Ad[i][j]*X[j][0] ;//+ Bd*a;
        }
      }


      // print( "Temp" + instant_t + "\n" + temp[0][0]  + "\n" + temp[1][0] + "\n" + temp[2][0] + "\n" + temp[3][0] + "\n\n");
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



      //print( instant_t + "\n" + X[0][0]  + "\n" + X[1][0] + "\n" + X[2][0] + "\n" + X[3][0] + "\n\n");
      //instant_t++;
      coordonnees_trajectoire_x[instant_t] = Xsuivant[0][0];
      coordonnees_trajectoire_y[instant_t] = Xsuivant[2][0];
      //print( coordonnees_trajectoire_x[instant_t] + "," +  coordonnees_trajectoire_y[instant_t] + ";"+"\n");
    }

    print("\nArret méthode à index " + instant_t );

    // On place les nouvelles valeurs dans le tableau de coordonnées de trajectoire
    //xn = X(1,:);
    //yn = X(3,:);
    // coordonnees_trajectoire_x[temps_courant] = ;
    // coordonnees_trajectoire_y[temps_courant] = ;
  }
}

