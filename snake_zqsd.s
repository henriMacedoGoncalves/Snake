# java -jar Mars4_5.jar
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
#                     Keyboard display and input functions                     #
################################################################################

# These functions handle display and keyboard inputs.
# It is not mandatory to understand what they do.

.data

# 256*256 set display buffer linearly.

frameBuffer: .word 0 : 1024  # Frame buffer

# Color code for display
# Color coding 0xwwxxyyzz where
# ww = 00
# 00 <= xx <= ff is the red color in hexadecimal
# 00 <= yy <= ff is the green color in hexadecimal
# 00 <= zz <= ff is the blue color in hexadecimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Last known position of snake tail.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Parameters: $a0 The color value
#             $a1 The position in X
#             $a2 The position in Y
# Return: None
# Side Effect: Changes the game display
################################################################################

printColorAtPosition:
lw $t0 gridSize
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetDisplay ##################################
# Parameters: None
# Return: None
# Side Effect: Resets all display with black color
################################################################################

resetDisplay:
lw $t1 gridSize
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
# Parameters: None
# Return: None
# Side Effect:   Changes the color of the display to the location
#                where the snake is located and saves the last known position
#                of the snake's tail.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 snakeSize
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
# Parameters: None
# Return: None
# Side Effect: Changes the color of the display to the location of obstacles.
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
# Parameters: None
# Return: None
# Side Effect: Changes the color of the display to the candy location.
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
# Parameters: None
# Return: None
# Side Effect: Displays all elements of the game.
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
# Parameters: $a0 An integer x | 0 <= x < gridSize
# Return: $v0 An integer y | 0 <= y < gridSize, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 gridSize
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Returns a random position on an unused location that is not
#              in front of the snake.
# Parameters: None
# Return: $v0 Position X of the new object
#         $v1 Position Y of the new object
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 gridSize
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
lw $a1 gridSize
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 snakeSize
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
# Parameters: None
# Return: $v0 The value 0 (up), 1 (right), 2 (down), 3 (left), 4 error
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 122
beq $t0 $t1 GIup
li $t1 115
beq $t0 $t1 GIdown
li $t1 113
beq $t0 $t1 GIleft
li $t1 100
beq $t0 $t1 GIright
li $v0 4
j GIend

GIup:
li $v0 0
j GIend

GIright:
li $v0 1
j GIend

GIdown:
li $v0 2
j GIend

GIleft:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Parameters: None
# Return: None
################################################################################

#By default takes 0.5 seconds, for each eaten candy, decrease of 0.01 seconds
sleepMillisec:
li $t0 500
li $t2 10
lw $t1 gameScore
mul $t1 $t1 $t2 # $t1 = gameScore*10
sub $a0 $t0 $t1 # $a0 == 500 - (gameScore*10)

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
# Description: Main game loop
# Parameters: None
# Return: None
################################################################################

main:

# Game initialization

jal resetDisplay
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Game loop

mainloop:

jal getInputVal
move $a0 $v0
jal updateDirection
jal updateGameStatus
jal conditionEndGame
bnez $v0 gameOver
jal printGame
#li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal displayEndGame
li $v0 10
syscall

################################################################################
#                                   Project                                    #
################################################################################

# It’s up to you!

.data

gridSize:  .word 16        # Number of squares in a dimension.

# The head of the snake is (snakePosX[0], snakePosY[0]) and the tail is
# (snakePosX[snakeSize - 1], snakePosY[snakeSize - 1])
snakeSize:   .word 1         # Current size of the snake.
snakePosX:     .word 0 : 1024  # Position X of the snake ordered from head to tail.
snakePosY:     .word 0 : 1024  # Position Y of the snake ordered from head to tail.

# Directions are represented as integers ranging from 0 to 3:
snakeDir:      .word 1         # Direction of the snake: 0 (up), 1 (right)
                               #                         2 (down), 3 (left)
numObstacles:  .word 0         # Current number of obstacles present in the game.
obstaclesPosX: .word  0: 1024  # Position X of the obstacles
obstaclesPosY: .word  0: 1024  # Position Y of the obstacles
candy:         .word 0, 0      # Position of the candy (X,Y)
gameScore:      .word 0         # Score obtained by the player
messageLoser:  .asciiz "You lost! The game is finished. \nYour score is:" #printed message when we lose

.text

################################# updateDirection #################################
# Parameters: $a0 The new position requested by the user.
#                 The value is the return of the getInputVal function.
# Return: None
# Side Effect: The direction of the snake has been updated.
# Post-condition: The value of the snake remains intact if an illegal command
#                 is requested, i.e. the snake cannot turn around in
#                 a single turn. This is akin to cannibalism and has been outlawed
#                 by law in reptilian societies.
##################################################################################

updateDirection:

# Up, ... down, ... left, ... right, ... those nights there...


move $t0 $a0 
lw $t1 snakeDir
bgt $t0 3 endUpdateDirection # snakeDir = 1 by default, if not this condition the game waits for a new input to start the game
blt $t0 2 switch1 # getInputVal < 2 avoids a turn around
j switch2 # 2 <= getInputVal avoids a turn around

update:
sw $a0 snakeDir

endUpdateDirection:
jr $ra

switch1:
addi $t0 $t0 2 # 0(up) + 2 = 2(down), 1(left) + 2 = 3(right)
beq $t0 $t1 endUpdateDirection
j update

switch2:
subi $t0 $t0 2 # 2(down) - 2 = 0(up), 3(right) - 2 = 1(left)
beq $t0 $t1 endUpdateDirection
j update

############################### updateGameStatus ###############################
# Parameters: None
# Return: None
# Side Effect: The status of the game is updated by a time step. Therefore:
#                  - Move the snake
#                  - Test if snake eats candy
#                  - If yes, move the candy and add a new obstacle
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

# acces to the elements of the snake
lw $s2 snakeSize
subi $s2 $s2 1
sll $s2 $s2 2
li $s1 0
li $s3 4 # acces on the second element of the snake
#coordinates of the head: $t0= position X $t1=position Y
lw $t0 snakePosX#($s1)
lw $t1 snakePosY#($s1)

# move the snake
lw $s0 snakeDir
beq $s0 0 upLoopTS
beq $s0 1 rightLoopTS
beq $s0 2 downLoopTS
beq $s0 3 leftLoopTS

# endUpdateGameStatus
endUGS:
#outro:
lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp) 
lw $s3 16($sp)
addi $sp $sp 20
jr $ra

# Update the elements of the snake
upLoopTS:
bge $s1 $s2 up
lw $t2 snakePosX($s3) #t2 = SnakePosX[snakeSize-1]
lw $t3 snakePosY($s3) #t2 = SnakePosY[snakeSize-1]
sw $t0 snakePosX($s3) #SnakePosX[snakeSize-1]=SnakePosX[snakeSize]
sw $t1 snakePosY($s3) #SnakePosX[snakeSize-1]=SnakePosY[snakeSize]
move $t0 $t2 #t0=SnakePosX[snakeSize-1]
move $t1 $t3 #t1=SnakePosY[snakeSize-1] 
addu $s3 $s3 4 # increment the index
addi $s1 $s1 4 # increment the counter
j  upLoopTS

# the same as upLoopTS:
rightLoopTS:
bge $s1 $s2 right
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  rightLoopTS

# the same as upLoopTS:
downLoopTS:
bge $s1 $s2 down
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  downLoopTS

# the same as upLoopTS:
leftLoopTS:
bge $s1 $s2 left
lw $t2 snakePosX($s3)
lw $t3 snakePosY($s3)
sw $t0 snakePosX($s3)
sw $t1 snakePosY($s3)
move $t0 $t2
move $t1 $t3
addu $s3 $s3 4
addi $s1 $s1 4
j  leftLoopTS

# update the position of the snake's head
up:
lw $s0 snakePosX 
subi $s0 $s0 1 #x-1= move up
sw $s0 snakePosX
j testCandy

right:
lw $s0 snakePosY
addi $s0 $s0 1 #y+1= move right 
sw $s0 snakePosY
j testCandy

down:
lw $s0 snakePosX
addi $s0 $s0 1 #x+1= move down
sw $s0 snakePosX
j testCandy

left:
lw $s0 snakePosY
subi $s0 $s0 1 #y-1= move left
sw $s0 snakePosY
j testCandy

# Test if the snake ate the candy
testCandy:
lw $s0 candy
lw $s1 candy+4
lw $s2 snakePosX
lw $s3 snakePosY
	
bne $s0 $s2 endUGS # If candy[x]!=SnakePosX, connection to EndUgs
bne $s1 $s3 endUGS # Si candy[y]!=SnakePosX, connection to EndUgs

#Si oui déplacer le bonbon et ajouter un nouvel obstacle
# If yes, move the candy elsewhere and add a new obstacle
UpdateCandyPosition:
jal newRandomObjectPosition # generate a new position for the candy
sw $v0 candy
sw $v1 candy+4

# increment the score
lw $s0 gameScore
addi $s0 $s0 1
sw $s0 gameScore

# increase the size of the snake
lw $s2 snakeSize
addi $s2 $s2 1
sw $s2 snakeSize 

# enlarge the snake
subi $s2 $s2 1
mul $s2 $s2 4
lw $s1 lastSnakePiece
lw $s0 lastSnakePiece + 4
sw $s1 snakePosX($s2)
sw $s0 snakePosY($s2)

# increment the number of obstacles
lw $s1 numObstacles
addi $s1 $s1 1
sw $s1 numObstacles
subi $s1 $s1 1
mul $s1 $s1 4

# generate a new obstacle
jal newRandomObjectPosition
sw $v0 obstaclesPosX($s1)
sw $v1 obstaclesPosY($s1)

j endUGS

		
############################### conditionEndGame ###############################
# Parameters: None
# Return: $v0 The value 0 if the game should continue or any other value if not.
################################################################################


conditionEndGame:
#intro:
addi $sp $sp -28
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s2 12($sp) 
sw $s3 16($sp)
sw $s4 20($sp)
sw $s5 24($sp)

li $v0 0

lw $s0 snakePosX
lw $s1 snakePosY
lw $s2 obstaclesPosX
lw $s3 obstaclesPosY
lw $s4 numObstacles

# verify if the snake is inside of the grid														
beq $s0 -1 GameOverCFJ #si X<0, GameOverCFJ 
beq $s1 -1 GameOverCFJ	#si Y<0, saut a GameOverCFJ 
beq $s0 16 GameOverCFJ #si X>16, saut a GameOverCFJ 
beq $s1 16 GameOverCFJ #si Y>16, saut a GameOverCFJ 

sll $s4 $s4 2
li $s5 0

# verify if the snake doesn't hit an obstacle
cfjObstacleLoop:
lw $s2 obstaclesPosX($s5)
lw $s3 obstaclesPosY($s5) 
beq $s5 $s4 snake 
addu $s5 $s5 4 
bne $s0 $s2 cfjObstacleLoop #if ObstaclePosX!=SnakePosX, connection to cfjObstacleLoop
bne $s1 $s3 cfjObstacleLoop #if ObstaclePosY!=SnakePosY, connection to cfjObstacleLoop
j GameOverCFJ

snake:
lw $s4 snakeSize
sll $s4 $s4 2
li $s5 4

# verify if the snake doesn't eat his tail
cfjTailLoop:
lw $s2 snakePosX($s5) 
lw $s3 snakePosY($s5)
beq $s5 $s4 endCFJ
addu $s5 $s5 4
bne $s0 $s2 cfjTailLoop # if SnakePosX[0]!=SnakePosX[s5], connection to cfjTailLoop
bne $s1 $s3 cfjTailLoop # if SnakePosX[0]!=SnakePosX[s5], connection to cfjTailLoop
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
li $v0 1 #1 in $v0 connects to displayEndGame
j endCFJ

############################### displayEndGame #################################
# Parameters: None
# Return: None
# Side Effect: Displays the player's score in the terminal followed by a
#              nice message (Example: "What a pitiful performance!").
# Bonus: Display the score in overprint of the game.
################################################################################

displayEndGame:

# End
la $a0 messageLoser # displays message at the end
li $v0 4
syscall

lw $a0 gameScore # prints the score
li $v0 1
syscall
jr $ra