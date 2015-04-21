/*
Gestion de la commande manuelle et de la commande par boucle ouverte (le mode triche)
  * 18/04/2015
  * Maxime Touroute
 */
class Commande
{

  // Variables de conditions initiales
  float masse = 0.8;
  float gterre = 9.81;
  
  // L'horizon pour la boucle ouverte
  int valeur_h = 50;
  
  // Stockage du nombre d'echantillons traites dans chaque cas
  int instant_fin_commande_manuelle;
  int instant_fin_commande_triche;
  
  // Stockage des donnees de trajectoire: coordonnees x et y, vitesse x et y
  // Stockees dans des tableaux a taille fixe. Limite imposee a 2000
  
  // Les deux vecteurs qui stockent les coordonnees de la trajectoire 
  float[] coordonnees_trajectoire_x = new float[2000];
  float[] coordonnees_trajectoire_y = new float[2000];

  // Mêmes vecteurs, pour le mode triche (La boucle ouverte)
  float[] coordonnees_trajectoire_x_triche = new float[2000];
  float[] coordonnees_trajectoire_y_triche = new float[2000];
  
  // On stocke la vitesse de la boule a chaque instant
  float[] vitesse_trajectoire_x = new float[2000];
  float[] vitesse_trajectoire_y = new float[2000];
  
  // L'instant t d'execution
  int instant_t = 0;


  // Nos equations discretes 

  // MAtrice 4x4
  float[][] Ad = { 
    {
      1.0, 0.03, 0, 0
    }
    , 
    {
      0.0, 1.0, 0.0, 0.0
    }
    , 
    {
      0.0, 0.0, 1.0, 0.03
    }
    , 
    {
      0.0, 0.0, 0.0, 1.0
    }
  }; 

  // MAtrice 2x'4
  float[][] Bd = { 
    {
      0.00045, 0
    }
    , {
      0.03, 0
    }
    , {
      0, 0.00045
    }
    , {
      0, 0.03
    }
  }; 

  // Le vecteur de commande
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
    X0[2][0] = HAUTEUR_INITIALE;
    X0[3][0] = v0y;
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

    // Le X précédent, qui est une copie du vecteur initial X0
    float[][] X = new float[4][1];    
    X[0][0] = X0[0][0];
    X[1][0] = X0[1][0];
    X[2][0] = X0[2][0];
    X[3][0] = X0[3][0];
      
    // Stockage des premières valeurs
    coordonnees_trajectoire_x[0] = X[0][0]; // x
    coordonnees_trajectoire_y[0] = X[2][0]; // y

    while ( X[2][0] > 0 ) // Tant que la position en y est supérieure à 0 (pas encore par terre)
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
      // Stockage de la vitesse
      vitesse_trajectoire_x[instant_t] = Xsuivant[1][0];
      vitesse_trajectoire_y[instant_t] = Xsuivant[3][0];
      
    }
    
    // On stocke le nombre d'échantillons créés
    instant_fin_commande_manuelle = instant_t;
  }


  void compute_cheatmode()
  {
    // En entrée, le vecteur X0
    // 
    float[][] XDebutTriche = {
      {
        X0[0][0]
      }
      , {
        X0[1][0]
      }
      , {
        X0[2][0]
      }
      , {
        X0[3][0]
      }
    }; 
    
    
    print("potision cochonnet:", position_cochonnet, "\n");
    
    // Le vecteur à atteindre en fin de parcours
    float[][] Xh = {
      {
        position_cochonnet // TODO: trouver la bonne position du cochonnet
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

    // en h étapes TODO: euh... jouer avec ça ? Non.
    int h = valeur_h;

    // Matrice de gouvernabilité : les premières valeurs c'est Bd
    // MAtrice 2x'4

    float[][] G = new float[4][2*h]; // G est une matrice contenant une liste de vecteurs 4 (sur chaque colonne) 

    //TODO: récupérer proprement les vraies valeurs de Bd parce que là merci bien
    // Code Scilab: G = Bd
    //[ligne][colonne]
    G[0][(2*h)-2] = Bd[0][0];//0.00045;
    G[1][(2*h)-2] = Bd[1][0];//0.03;
    G[2][(2*h)-2] = Bd[2][0];//0;
    G[3][(2*h)-2] = Bd[3][0];//0;

    G[0][(2*h)-1] = Bd[0][1];//0;
    G[1][(2*h)-1] = Bd[1][1];//0;
    G[2][(2*h)-1] = Bd[2][1];//0.00045;
    G[3][(2*h)-1] = Bd[3][1];//0.03;

  
  
    //Mat.print(G,5);
    
    /**************************** Calcul de la matrice de gouvernabilité *******************************/

    // Code Scilab
    /*
    for k=1:h-1
     G=[(Ad^k)*Bd,G]; // On 
     end*/

    // Creation du Ad^k
    float[][] Adk = new float[4][4];

    // Qu'on initialise à Ad
    for (int i = 0; i < 4; i++)
      for (int j = 0; j < 4; j++)
        Adk[i][j]=Ad[i][j];

    print("Adk initial\n");
    Mat.print(Adk, 5);

    // Indice colonne où il faut écrire la valeur (on remplit G à partir de la fin)
    int indice_courant_de_G = (2*h)-3; 

    for (int k = 1; k < h; k++)
    {
      print("\n*************iteration", k, "\n");

      // On multiplie Adk par Ad voilà.
      if (k != 1)
      {
        // Le Adk d'avant.
        float[][] prev_Adk = Adk;

        // Calcul du Adk
        for (int i = 0; i < 4; i++) // Les 4 lignes
        {
          for (int j = 0; j < 4; j++) // les 4 colonnes
          {
            // calcul de la valeur en ce point
            float sum = 0;

            for (int p = 0; p < 4; p++)
            {
              // Adk ligne i colonne j est égal à la la somme des produits de prev_adk[i][j]*Ad[k]
              sum = sum + prev_Adk[i][p]*Ad[p][j] ;
            }

            Adk[i][j] = sum;
          }
        }
      }

      print("\nAdk\n");
      Mat.print(Adk, 5);

      print("\nBd\n");
      Mat.print(Bd, 5);

      // Calcul de la matrice 4x2 à ajouter dans G : Testé OK

      float[][] temp_G = new float[4][2];

      for (int i = 0; i < 4; i++) // Les 4 lignes
      {
        for (int j = 0; j < 2; j++) // les 2 colonnes
        {
          float sum = 0;
          
          for (int p = 0; p < 4; p++)
          {
            sum += Adk[i][p]*Bd[p][j];
          }
          temp_G[i][j] = sum;
        }
      }

      print("\ntemp_G\n");
      Mat.print(temp_G, 5);

      // Derniere etape: concatener la matrice temp_G à G.

      for (int i = 0; i < 4; i++)
      {
        G[i][indice_courant_de_G] = temp_G[i][1];
      }

      indice_courant_de_G--;

      for (int i = 0; i < 4; i++)
      {
        G[i][indice_courant_de_G] = temp_G[i][0];
      }

      indice_courant_de_G--;
    }

    // On a notre matrice de gouvernabilité.
    
    print("final G\n");
    Mat.print(G, 5);
    
    
    /************************************************* Calcul de y ************************************/
   // Code Scilab
     //y = Xh - (Ad^h) * X0; // y, le vecteur final qu'on veut atteindre ?
    

    float[][] y = { 
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

    // Initialisation du vecteur y avec Xh dedans
    y[0][0] = Xh[0][0];
    y[1][0] = Xh[1][0];
    y[2][0] = Xh[2][0];
    y[3][0] = Xh[3][0];

    // On reprend Adk et on le multiplie par Ad une fois de + pour obtenir Ad^h
    {

      // Le Adk d'avant.
      float[][] prev_Adk = Adk;

      // Calcul du Adk
      for (int i = 0; i < 4; i++) // Les 4 lignes
      {
        for (int j = 0; j < 4; j++) // les 4 colonnes
        {
          // calcul de la valeur en ce point
          float sum = 0;

          for (int p = 0; p < 4; p++)
          {
            // Adk ligne i colonne j est égal à la la somme des produits de prev_adk[i][j]*Ad[k]
            sum = sum + prev_Adk[i][p]*Ad[p][j] ;
          }

          Adk[i][j] = sum;
        }
      }
    }


    // Code Scilab: Ad^h*X0
    float[][] temp_result = { 
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
        temp_result[i][0] += Adk[i][j]*XDebutTriche[j][0] ;
      }
    }

    print("\ntemp_result pour y \n");
    Mat.print(temp_result, 5);

    y[0][0] -= temp_result[0][0];
    y[1][0] -= temp_result[1][0];
    y[2][0] -= temp_result[2][0];
    y[3][0] -= temp_result[3][0];

    // On a y.
    
    print("\ny\n");
    Mat.print(y, 5);
    
    /* Code Scilab 
     Gt = G'; // G' donne la transposée de G
     u = (Gt * inv(G * Gt)) * y; 
     */
     
     // La transposée
    float[][] Gt = new float[2*h][4];

    for (int i = 0; i < 2*h; i++) // 2*h lignes dans la matrice transposée
      for (int j = 0; j < 4; j++ ) // et 4 colonnes
        Gt[i][j] = G[j][i];

    print("\nGt!\n");
    Mat.print(Gt, 5);

    // Derniere etape: le vecteur de commande qui remplacera notre a: u = (Gt * inv(G * Gt)) * y; 

    // Gt * inv(G * Gt)

    float[][] GxGt = new float[4][4];

    for (int i = 0; i < 4; i++) // Les 4 lignes
    {
      for (int j = 0; j < 4; j++) // les 4 colonnes
      {
        float sum = 0.0;
        for (int p = 0; p < 2*h; p++)
        {
          sum += G[i][p]*Gt[p][j];
        }
        GxGt[i][j] = sum;
      }
    }



    print("\nGxGt!\n");
    Mat.print(GxGt, 6);
    
    // On fait l'inverse de la matrice avec une bibliotheque processing

    float[][] invGxGt = Mat.inverse(GxGt);

    print("\ninvGxGt!\n");
    Mat.print(invGxGt, 5);
    
    
    //  Gt*invGxGt
    float[][] GtxinvGxGt = new float[2*h][4];

    for (int i = 0; i < 2*h; i++) // Les 2*h lignes
    {
      for (int j = 0; j < 4; j++) // les 4 colonnes
      {
        float sum = 0;
        // à chaque étape, 
        for (int p = 0; p < 4; p++)
        {
          sum += Gt[i][p]*invGxGt[j][p];
        }
        GtxinvGxGt[i][j] = sum;
      }
    }

    print("\nGtinvGxGt!\n");
    Mat.print(GtxinvGxGt, 5);

    // Plus qu'à multiplier ce terme par le vecteur y 
    float[][] u = new float[2*h][1];

    for (int i = 0; i < 2*h; i++) // Les 2*h lignes
    {
      float sum = 0;
      // à chaque étape, 
      for (int p = 0; p < 4; p++)
      {
        sum += GtxinvGxGt[i][p]*y[p][0];
      }
      u[i][0] = sum;
    }

    // On a notre vecteur de commande
    print("\nu!\n");
    Mat.print(u, 5);



    /****************************************** Calcul de la nouvelle trajectoire ********************************************/
    
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
    
    // Le X précédent, qu'on initialise aux valeurs du premier point
    float[][] X = new float[4][1];
    
   X[0][0] = XDebutTriche[0][0]; 
   X[1][0] = XDebutTriche[1][0]; 
   X[2][0] = XDebutTriche[2][0]; 
   X[3][0] = XDebutTriche[3][0]; 

    // Stockage des premières valeurs
    coordonnees_trajectoire_x_triche[0] = X[0][0]; // x
    coordonnees_trajectoire_y_triche[0] = X[2][0]; // y

    // On commence à l'instant temps (Qui normalement est 0 hein TODO on gere ou pas?)
    instant_t = temps;
    
    for(int k = 0 ; k < 2*h ; k+=2) 
    {
      // on réinitialise Xsuivant avant de ré-itérer la boucle
      Xsuivant[0][0] = 0;
      Xsuivant[1][0] = 0;
      Xsuivant[2][0] = 0;
      Xsuivant[3][0] = 0;
      
      // On incrémente l'instant t
      instant_t++;

      // Produit matriciel inspiré de celui du code Scilab

      for (int i = 0; i < 4; i++) // Les 4 lignes
      {
        for (int j = 0; j < 4; j++) // les 4 colonnes
        {
          Xsuivant[i][0] += Ad[i][j]*X[j][0] ;//+ Bd*a;
        }
      }
      
      float[][] vecteur_commande = new float[2][1];
      
      vecteur_commande[0][0] = u[k][0];
      
      // On initialise le vecteur de commande qui remplace le vecteur a
      //if(k != 0)
      vecteur_commande[1][0] = u[k+1][0];
   
      
      for (int i = 0; i < 4; i++) // ajout du terme Bd*u;
      {
        for (int j = 0; j < 2; j++)
        {

          Xsuivant[i][0] += Bd[i][j]*vecteur_commande[j][0];
        }
      }

      // L'ancien X devient le nouveau X.
      X[0][0] = Xsuivant[0][0];
      X[1][0] = Xsuivant[1][0];
      X[2][0] = Xsuivant[2][0];
      X[3][0] = Xsuivant[3][0];
      
        
   
      // Stockage des nouvelles coordonnées de trajectoire
      coordonnees_trajectoire_x_triche[instant_t] = Xsuivant[0][0];
      coordonnees_trajectoire_y_triche[instant_t] = Xsuivant[2][0];
      
      print(coordonnees_trajectoire_x_triche[instant_t], ",");
      print(coordonnees_trajectoire_y_triche[instant_t], "\n");
      print("X a atteindre!", Xh[0][0], "\n");
      
      // Stockage de la vitesse
      vitesse_trajectoire_x[instant_t] = Xsuivant[1][0];
      vitesse_trajectoire_y[instant_t] = Xsuivant[3][0];
    
    }
    
    // On stocke l'instant de fin
    instant_fin_commande_triche = instant_t;
  }  // Fin  de méthode
  
  // TODO : convertir les X en matrices avec toutes les valeurs ? ou osef ?
}

