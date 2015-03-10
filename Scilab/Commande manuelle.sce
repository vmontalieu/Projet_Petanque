xdel(winsid()) // On ferme toutes les fenêtres

masse = 0.8; //kg
gterre = 9.81;
Te = 0.04 // 40ms


// Conditions initiales
theta = 45; // angle d'attaque. 
theta = %pi * (theta) / 180 
hauteur = 1; // hauteur initiale de la boule (m)
v0 = 5; // m/s²

v0x = v0*cos(theta);
v0y = v0*sin(theta);

//Vecteur d'état initial X0
// x , vx , y , vy
X0 = [0; v0x; hauteur; v0y]; // Position initiale de la boule à l'instant 0

// Définition de la matrice accélération
a= [0;-gterre];

// Définition de A;B;C;D de l'équation, 
A= [0,1,0,0 ; 0,0,0,0 ; 0,0,0,1 ; 0,0,0,0]; 
B= [0,0 ; 1,0 ; 0,0 ; 0,1];
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
while Xsuivant(3) > 0 // Tant que la position en y est supérieure à 0 (pas encore par terre)
                                 // vecteur a
    Xsuivant = Ad*Xsuivant + Bd*a;
    X = [X, Xsuivant]; // On ajoute la valeur à la matrice X
    t = t+1;    
end

xn = X(1,:);
yn = X(3,:);
xtitle("Impact : " + string(xn($)) + " m");
plot2d(xn, yn);
