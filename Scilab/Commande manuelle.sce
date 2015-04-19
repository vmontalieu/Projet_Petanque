// Commande Manuelle
// Maxime Touroute
// Nicolas Sintes
// Vincent Montalieu
// Avril 2015

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


