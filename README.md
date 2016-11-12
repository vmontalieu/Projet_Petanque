# Projet_Petanque 

This is a 2D Game project developped to illustrate control theory: Manual Command and Open Loop. 

Physic calculations has been made through scilab first, then used for the 2D Game developped in Processing.

# How does it look

## The start screen

![](https://github.com/VincentMontalieu/Projet_Petanque/blob/master/readme_imgs/1.jpg)

## In game

Your goal is to throw the gray ball and hit the small red ball on the ground. When playing in normal mode, the game uses manual command to estimate where the ball will land. Your trajectory is shown in red.

![](https://github.com/VincentMontalieu/Projet_Petanque/blob/master/readme_imgs/2.jpg)
![](https://github.com/VincentMontalieu/Projet_Petanque/blob/master/readme_imgs/3.jpg)
![](https://github.com/VincentMontalieu/Projet_Petanque/blob/master/readme_imgs/4.jpg)

If you're too lazy, you can press `C` to switch to cheat mode. Then, the game uses an Open Loop calculation to correct your trajectory. The corrected trajectory is shown in green. 

![](https://github.com/VincentMontalieu/Projet_Petanque/blob/master/readme_imgs/5.jpg)


# How to use it 

* On Windows
  * A windows executable is included in this repo. simply unzip it and run the .exe to test the game.
* On OSX or Linux
  * You'll have to install processing 2 and run it from the source code. You'll also need to import the papaya library (accessible inside the windows archive)


# Credits

Game music was borrowed from the awesome [Soccer Physics](http://www.miniclip.com/games/soccer-physics/)
