#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 122
beq $t0 $t1 GIhaut
li $t1 115
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: Aucun
# Retour: Aucun
################################################################################

#Par d�faut 0.5 secondes, � chaque bonbon mang� diminution de temps de 0.01 secondes
sleepMillisec:
li $t0 500
li $t2 10
lw $t1 scoreJeu
mul $t1 $t1 $t2 # $t1 = scoreJeu*10
sub $a0 $t0 $t1 # $a0 == 500 - (scoreJeu*10)

move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
#li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word  0: 1024  # Coordonnées X des obstacles
obstaclesPosY: .word  0: 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
messageLoser:  .asciiz "T'as perdu!!, la partie est finie \nTon score est:" #messsage affich� quand on perd

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:

# En haut, ... en bas, ... à gauche, ... à droite, ... ces soirées là ...


move $t0 $a0 
lw $t1 snakeDir
bgt $t0 3 endMajDirection #snakeDir = 1 par default, si pas cette condition le jeu attend un nouvelle input pour commencer le jeu
blt $t0 2 switch1 # getInputVal < 2 #�vite un demi-tour su serpent
j switch2 # 2 <= getInputVal #�vite un demi-tour su serpent

maj:
sw $a0 snakeDir

endMajDirection:
jr $ra

switch1:
addi $t0 $t0 2 # 0(haut) + 2 = 2(bas), 1(gauche) + 2 = 3(droite)
beq $t0 $t1 endMajDirection
j maj

switch2:
subi $t0 $t0 2 # 2(bas) - 2 = 0(haut), 3(droite) - 2 = 1(gauche)
beq $t0 $t1 endMajDirection
j maj

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

# jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt

#intro:
addi $sp $sp -20
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s2 12($sp) 
sw $s3 16($sp)
#acc�es aux �l�ments du serpent
lw $s2 tailleSnake
subi $s2 $s2 1
sll $s2 $s2 2
li $s1 0
li $s3 4 #acc�der au 2eme �lement du serpent
#coordon�es de la tete: $t0=coordonn�X $t1=coordon�eY
lw $t0 snakePosX#($s1)
lw $t1 snakePosY#($s1)

#fait bouger le serpent
lw $s0 snakeDir
beq $s0 0 hautLoopTS
beq $s0 1 droiteLoopTS
beq $s0 2 basLoopTS
beq $s0 3 gaucheLoopTS
#si pas de branchement effectu� passage � direct � l'outro

endUGS:
#outro:
lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp) 
lw $s3 16($sp)
addi $sp $sp 20
jr $ra

#Mise a jour des element du serpent
hautLoopTS:
bge $s1 $s2 haut
lw $t2 snakePosX($s3) #t2 = SnakePosX[TailleSnake-1]
lw $t3 snakePosY($s3) #t2 = SnakePosY[TailleSnake-1]
sw $t0 snakePosX($s3) #SnakePosX[TailleSnake-1]=SnakePosX[tailleSnake]
sw $t1 snakePosY($s3) #SnakePosX[TailleSnake-1]=SnakePosY[tailleSnake]
move $t0 $t2 #t0=SnakePosX[TailleSnake-1]
move $t1 $t3 #t1=SnakePosY[TailleSnake-1] 
addu $s3 $s3 4 #incr�mentation de l'indice
addi $s1 $s1 4 #incr�mentation du compteur
j  hautLoopTS

#meme principe que hautLoopTS:
droiteLoopTS:
bge $s1 $s2 droite
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  droiteLoopTS

#m�me principe que hautLoopTS:
basLoopTS:
bge $s1 $s2 bas
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  basLoopTS

#m�me principe que hautLoopTS:
gaucheLoopTS:
bge $s1 $s2 gauche
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  gaucheLoopTS

#mise a jour de la position de la tete du serpent
haut:
lw $s0 snakePosX 
subi $s0 $s0 1 #x-1= d�placement vers le haut 
sw $s0 snakePosX
j testCandy

droite:
lw $s0 snakePosY
addi $s0 $s0 1 #y+1= d�placement vers la droite 
sw $s0 snakePosY
j testCandy

bas:
lw $s0 snakePosX
addi $s0 $s0 1 #x+1= d�placement vers le bas
sw $s0 snakePosX
j testCandy

gauche:
lw $s0 snakePosY
subi $s0 $s0 1 #y-1= d�placement vers la gauche
sw $s0 snakePosY
j testCandy

#Tester si le serpent a manger le bonbon
testCandy:
lw $s0 candy
lw $s1 candy+4
lw $s2 snakePosX
lw $s3 snakePosY
	
bne $s0 $s2 endUGS #Si candy[x]!=SnakePosX, branchement vers EndUgs
bne $s1 $s3 endUGS #Si candy[y]!=SnakePosX, branchement vers EndUgs

#Si oui déplacer le bonbon et ajouter un nouvel obstacle
UpdateCandyPosition:
jal newRandomObjectPosition #G�n�re une nouvelle position pour le bonbon
sw $v0 candy
sw $v1 candy+4

#incr�mente le score et 
lw $s0 scoreJeu 
addi $s0 $s0 1
sw $s0 scoreJeu

#Augmente la taille du serpent
lw $s2 tailleSnake
addi $s2 $s2 1
sw $s2 tailleSnake 

#Agrandissement de la taille du serpent
subi $s2 $s2 1
mul $s2 $s2 4
lw $s1 lastSnakePiece
lw $s0 lastSnakePiece + 4
sw $s1 snakePosX($s2)
sw $s0 snakePosY($s2)

#incr�mete ne nombre d'obstacle
lw $s1 numObstacles
addi $s1 $s1 1
sw $s1 numObstacles
subi $s1 $s1 1
mul $s1 $s1 4

#g�n�re un nouvel obstacle
jal newRandomObjectPosition
sw $v0 obstaclesPosX($s1)
sw $v1 obstaclesPosY($s1)

j endUGS

		
############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################


conditionFinJeu:
#intro:
addi $sp $sp -28
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s2 12($sp) 
sw $s3 16($sp)
sw $s4 20($sp)
sw $s5 24($sp)

# Aide: Remplacer cette instruction permet d'avancer dans le projet.
li $v0 0

lw $s0 snakePosX
lw $s1 snakePosY
lw $s2 obstaclesPosX
lw $s3 obstaclesPosY
lw $s4 numObstacles

#v�rifie si le serpent et dans la grille															
beq $s0 -1 GameOverCFJ #si X<0, GameOverCFJ 
beq $s1 -1 GameOverCFJ	#si Y<0, saut a GameOverCFJ 
beq $s0 16 GameOverCFJ #si X>16, saut a GameOverCFJ 
beq $s1 16 GameOverCFJ #si Y>16, saut a GameOverCFJ 

sll $s4 $s4 2
li $s5 0

#V�rifie si le serpent n'est pas sur un obctacle
cfjObstacleLoop:
lw $s2 obstaclesPosX($s5)
lw $s3 obstaclesPosY($s5) 
beq $s5 $s4 snake 
addu $s5 $s5 4 
bne $s0 $s2 cfjObstacleLoop #si ObstaclePosX!=SnakePosX, branchement vers cfjObstacleLoop
bne $s1 $s3 cfjObstacleLoop #si ObstaclePosY!=SnakePosY, branchement vers cfjObstacleLoop
j GameOverCFJ

snake:
lw $s4 tailleSnake
sll $s4 $s4 2
li $s5 4

#v�rifie si le snake se mange pas la queue
cfjTailLoop:
lw $s2 snakePosX($s5) 
lw $s3 snakePosY($s5)
beq $s5 $s4 endCFJ
addu $s5 $s5 4
bne $s0 $s2 cfjTailLoop #si SnakePosX[0]!=SnakePosX[s5], branchmenet vers cfjTailLoop
bne $s1 $s3 cfjTailLoop #si SnakePosX[0]!=SnakePosX[s5], branchement vers cfjTailLoop
j GameOverCFJ

endCFJ:
#outro
lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp) 
lw $s3 16($sp)
lw $s4 20($sp)
lw $s5 24($sp)
addi $sp $sp 28
jr $ra

GameOverCFJ:
li $v0 1 #1 dans $v0 am�ne vers affichageFinJeu
j endCFJ

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

# Fin.
la $a0 messageLoser #affiche massage de fin
li $v0 4
syscall

lw $a0 scoreJeu #affiche le score
li $v0 1
syscall
jr $ra
