// Ici, on va simuler une chute libre sans puis avec vitesse initiale et angle

masse = 0.8; //kg
gterre = 9.81;
Te = 0.03 // 40ms


// Conditions initiales
theta = 60; // angle d'attaque. 
pi = 3.14
theta = pi * (theta) / 180 
hauteur = 2; // hauteur initiale de la boule (m)
v0 = 5; // m/s²
epsilon = 1; // Epsilon, le coefficient des "reacteurs"

v0x = v0*cos(theta);
v0y = v0*sin(theta);

//Vecteur d'état initial X0
// x , vx , y , vy
X0 = [0; v0x; hauteur; v0y]; // Position initiale de la boule à l'instant 0


// Définition de A;B;C;D de l'équation, 
A= [0,1,0,0 ; 0,0,0,0 ; 0,0,0,1 ; 0,0,0,0]; 

B= [0,0 ; epsilon,0 ; 0,0 ; 0,epsilon];

C=  eye(4,4); // La matrice identité 4x4.
D= zeros(4,2);



equation = syslin('c', A, B, C, D); //  
equationdisc = dscr(equation, Te); // On discretise..

Ad = equationdisc('A'); // On récupère A discrétisé pour l'équation
Bd = equationdisc('B'); // Idem pour B.

X = []; //
X = X0; // conditions initiales.

Xsuivant = [];
Xsuivant = X0;

t = 0; // compteur de temps

// On aura au final dans X toute la trajectoire de LunarLander
//while Xsuivant(3) > 0 // Tant que la position en y est supérieure à 0 (pas encore par terre)
                                 // vecteur a
//    Xsuivant = Ad*Xsuivant + Bd*[0;-gterre];
//    X = [X, Xsuivant]; // On ajoute la valeur à la matrice X
//    t = t+1;    
//end

/////////////////////////////////////////////////////// Gouvernabilité.

X0=[0; v0x; hauteur; v0y];
// Faut trouver le bon V0x et le bon V0y pour bien partir

// Point qu'on veut atteindre
// x , vx , y , vy
Xh  = [50;v0x;0;0]; 

// MAtrice de gouvernabilité (de taille 1)
h=30;
// La différence sera dans Bd, matrice pour l'instant vide. 
//On va changer les epsilon, et donc l'acceleration y
G = Bd; 

// Calcul de la matrice de gouvernabilité
// On calcule la trajectoire en fait si on touche à rien?
for k=1:h-1
    G=[(Ad^k)*Bd,G]; // On 
    end

rank(G); // = 4 lignes. Si c'est différent de 4, alors pas de solution.

size(G); // = 4x300


// On a l'équiation y = G*U // G 4x300, U 300x1.
// U c'est la liste des commandes qu'on applique successivement à l'entrée de la boule de pétanque (au niveau de la gravité quoi)
// Il faut trouver U

    // Calcul de la solution
    y = Xh - (Ad^h) * X0; // y, le vecteur final qu'on veut atteindre ?
    Gt = G'; // G' donne la transposée de G
    u = (Gt * inv(G * Gt)) * y; 
    // Size(G*Gt) renvoit 4x4

    // vecteur des commandes des réacteurs
    a = u;
    //calcul de ay(n) = u(2*n)+glune/erg
    for n=1:h do
        a(2*n) = a(2*n) - (gterre);
        //a(n) = a(n)-gterre;
    end


X = []; //
X = X0; // conditions initiales.

Xsuivant = [];
Xsuivant = X0;

t=1
// On calcule les nouvelles coordonnées du truc
for k=1:h-1 // Tant que la position en y est supérieure à 0 (pas encore par terre)
                                 // vecteur U + a
    Xsuivant = Ad*Xsuivant + Bd*[a(k);a(2*k)];
    X = [X, Xsuivant]; // On ajoute la valeur à la matrice X
   // t = t+1;    
end

xn = X(1,:);
yn = X(3,:);
//plot2d(xn, yn);
plot2d(xn,yn);
