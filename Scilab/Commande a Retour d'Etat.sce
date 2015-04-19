// Projet Petanque - Commande à retour d'etat
// Maxime Touroute
// Nicolas Sintes
// Vincent Montalieu
// Avril 2015


masse = 0.8; //kg
gterre = 9.81;
Te = 0.03 // 40ms

// Conditions initiales
theta = 60; // angle du lancer
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


// Discretisation 

equation = syslin('c', A, B, C, D); 
equationdisc = dscr(equation, Te); 
Ad = equationdisc('A');
Bd = equationdisc('B'); 

X = [];
X = X0;
Xsuivant = [];
Xsuivant = X0;

t = 0; // compteur de temps

// On aura au final dans X toute la trajectoire de LunarLander
while Xsuivant(3) > 0 // Tant que la position en y est supérieure à 0 (pas encore par terre)
                                 // vecteur a
    Xsuivant = Ad*Xsuivant + Bd*[0;-gterre];
    // On ajoute la valeur à la matrice X
    X = [X, Xsuivant]; 
    t = t+1;    
end

xn = X(1,:);
yn = X(3,:);
plot2d(xn, yn, style=[color("red")]);

/////////////////////////////////////////////////////// Gouvernabilité.

// Point qu'on veut atteindre
// x , vx , y , vy
//Xh  = [20;v0x;0;-10];
Xh = [20;0;0;0];

// le choix du nombre de périodes d'échantillonnage
h=100;

// La matrice de gouvernabilité
G = Bd; 

// Calcul de la matrice de gouvernabilité
for k=1:h-1
    G=[(Ad^k)*Bd,G];
    end

// On a l'équiation y = G*U // G 4x300, U 300x1.
// U c'est la liste des commandes qu'on applique successivement à l'entrée de la boule de pétanque
// Il faut trouver U

    // Calcul de la solution
    y = Xh - (Ad^h) * X0; 
    Gt = G'; // G' donne la transposée de G
    u = (Gt * inv(G * Gt)) * y; 
    // Size(G*Gt) renvoit 4x4

    // Creation d'un nouveau vecteur des commandes des réacteurs
    a = u;
    //calcul de ay(n) = u(2*n)+glune/erg
    for n=1:h do
        //a(2*n) = a(2*n) - (gterre);
    end


X = []; //
X = X0; // conditions initiales.

Xsuivant = [];
Xsuivant = X0;


// On calcule les nouvelles coordonnées de la trajectoire
for k=1:h 
    Xsuivant = Ad*Xsuivant + Bd*[a(k);a(2*k)];
    // On ajoute la valeur à la matrice X
    X = [X, Xsuivant];    
end

xn2 = X(1,:);
yn2 = X(3,:);

plot2d(xn2, yn2,style=[color("green")]);
