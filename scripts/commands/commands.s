.text
#Convention
#JavaFX convention: x points right, y points down
#$10: x-coordinate
#$11: y-coordinate
#$12: current direction
#$4 is the argument register
#$2 is the command counter register

#Direction code [0-3]

initloop:
bne $19, $0, initloop		#imem SHOULD BE BEQ!

#Initialization code
#Fix $0-$3 to Direction code for ease of comparison

#$1-$3 Freed up
###
#addi $1, $0, 1 #east
#addi $2, $0, 2 #south
#addi $3, $0, 3 #west
###


#Default $29: DMEM state pointer
addi $29, $0, 9750

#Default $30: DMEM function pointer
addi $30, $0, 4000

#Default $2: Starts off -1
addi $2, $0, -1

#Default $3: Pen down
addi $3, $0, 1


#Screen initialization (left and right white)
#Initialize temp registers
add $6, $0, $0
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0


#$6 is constant: color WHITE
addi $6, $0, 255 # 255 corresponds to WHITE in index

#$20 is constant: 80 for 80 iterations for left and right
addi $20, $0, 80

#$27 is constant: 479 for 480 iterations vertically
addi $27, $0, 479

#two startpoints (left and right)
addi $21, $0, 0
addi $22, $0, 560

#start looping
loopinit:

bne $25, $20, endouterinit #$25=80, end	imem: SHOULD BE BEQ (11101)!!!


#get the temporary left and right indices for this iteration
add $23, $21, $25
add $24, $22, $25


#color it
#left
sw $6, 0($23)	# imem: SHOULD BE SVGA (01111)!!
#right
sw $6, 0($24)	# imem: SHOULD BE SVGA (01111)!!

#increment index
addi $25, $25, 1

j loopinit


endouterinit:

#ran this outer loop 480 times? then you're done!
bne $26, $27, endloopinit   # imem: SHOULD BE BEQ (11101)!!!

#first, increment the outer loop variable
addi $26, $26, 1

#one iteration is done, so add 640 to $21 and $22
addi $21, $21, 640
addi $22, $22, 640

#now set loop var to 0 and loop again 15 times
add $25, $0, $0 #inner loop var 0
j loopinit


endloopinit:
#cell all filled, clear the variables and move down
add $6, $0, $0
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0


#Initial turtle coordinate is the center of the grid
#Starting (15, 15), North, Red
addi $10, $0, 15
addi $11, $0, 15
addi $12, $0, 0
addi $13, $0, 250 # 250 offset applied

#Draw turtle at this location

addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
nop

promptdisplay:
addi $2, $2, 1      # increment command counter

## WRITE > SYMBOL
addi $6, $0, 0
addi $26, $0, 18
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

promptstart:
add $19, $0, $0			# set $19 to $0
nop
nop
nop
nop
nop
bne $19, $0, promptstart
noop
noop
noop
noop
noop
noop
promptloop:
bne $19, $0, promptloop	#imem SHOULD BE BEQ!

## WHEN A COMMAND HAS BEEN ENTERED, MAIN LOOP WILL BE ENTERED

###MAIN LOOP###
MAINLOOP:

#initialize temp registers 6-9
add $6, $0, $0
add $7, $0, $0
add $8, $0, $0
add $9, $0, $0

#detect a command: copy the command $19->$6 and put 0 in $19
add $6, $19, $0

#get the instruction binary and store it in $7
sra $7, $6, 8
nop
nop

#get the argument and store it in $4
sll $4, $6, 24
nop
nop
sra $4, $4, 24
nop
nop
addi $8, $0, 48   # OFFSET FOR ASCII -> DECIMAL
nop
nop
sub $4, $4, $8
nop
nop

#compare the instruction binary and jal to it

#FWD

addi $8, $0, 2147
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 251
# $8 NOW CONTAINS 4609860 = FWD
bne $7, $8, fwdskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop



jal FORWARD
nop
nop
j promptdisplay
nop
nop
fwdskip:
nop
nop

#BKD
addi $8, $0, 2084
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 1588
# $8 NOW CONTAINS 4344644 = BKD
bne $7, $8, bkdskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop


jal BACKWARD
nop
nop
j promptdisplay
nop
nop
bkdskip:
nop
nop

#LRT
addi $8, $0, 2236
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 2116
# $8 NOW CONTAINS 5001812 = LRT
bne $7, $8, lrtskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop


jal LEFTROTATE
nop
nop
j promptdisplay
nop
nop
lrtskip:
nop
nop

#RRT
addi $8, $0, 2323
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, -1301
# $8 NOW CONTAINS 5395028 = RRT
bne $7, $8, rrtskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop



jal RIGHTROTATE
nop
nop
j promptdisplay
nop
nop
rrtskip:
nop
nop

#UNDO
addi $8, $0, 2364
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 2100
# $8 NOW CONTAINS 5590596 = UNDO
bne $7, $8, undoskip
nop
nop
jal UNDO
nop
nop
j promptdisplay
nop
nop
undoskip:
nop
nop

#REDO
addi $8, $0, 2322
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
# $8 NOW CONTAINS 5391684 = REDO
bne $7, $8, redoskip
nop
nop
jal REDO
nop
nop
j promptdisplay
nop
nop
redoskip:
nop
nop

#CTI--change turtle image index
addi $8, $0, 2101
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, -1712
# $8 NOW CONTAINS 4412489 = CTI
bne $7, $8, ctiskip
nop
nop

#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop


jal CHANGETURTLEINDEX
nop
nop
j promptdisplay
nop
nop
ctiskip:
nop
nop

#CLC
addi $8, $0, 2100
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 435
# $8 NOW CONTAINS 4410435 = CLC
bne $7, $8, clcskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop


add $17, $13, $0 #$13->$17
add $13, $4, $0 #$4 (new line color)->$13
#add 250 offset
addi $13, $13, 250


## WRITE C
addi $6, $0, 1
addi $26, $0, 12
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE L
addi $6, $0, 2
addi $26, $0, 23
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE C
addi $6, $0, 3
addi $26, $0, 12
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE WHITESPACE
addi $6, $0, 4
addi $26, $0, 40
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE NUMBER
addi $6, $0, 5
addi $26, $4, 0
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1


nop
nop
j promptdisplay
clcskip:
nop
nop


#PNUP
addi $8, $0, 2294
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 497
# $8 NOW CONTAINS 5262933 = PNUP
bne $7, $8, pnupskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop


jal PNUP
nop
nop
j promptdisplay
nop
nop
pnupskip:
nop
nop


#PNDN
addi $8, $0, 2294
add $28, $8, $0
add $5, $8, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $8, $28, $0
# mul $8, $8, $8
addi $8, $8, 480
# $8 NOW CONTAINS 5262916 = PNDN
bne $7, $8, pndnskip
nop
nop


#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal SAVESTATE
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop



jal PNDN
nop
nop
j promptdisplay
nop
nop
pndnskip:
nop
nop


# IF UNKNOWN COMMAND PRINT ERROR AND JUMP TO PROMPT LOOP TO PROMPT LOOP


## WRITE E (RED)
addi $6, $0, 1
addi $26, $0, 15
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE R (RED)
addi $6, $0, 2
addi $26, $0, 31
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE R (RED)
addi $6, $0, 3
addi $26, $0, 31
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE O (RED)
addi $6, $0, 4
addi $26, $0, 27
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE R (RED)
addi $6, $0, 5
addi $26, $0, 31
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1


j promptdisplay

###FORWARD: fwd x
FORWARD:


## WRITE F
addi $6, $0, 1
addi $26, $0, 16
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE W
addi $6, $0, 2
addi $26, $0, 36
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE D
addi $6, $0, 3
addi $26, $0, 13
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE WHITESPACE
addi $6, $0, 4
addi $26, $0, 40
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE NUMBER
addi $6, $0, 5
addi $26, $4, 0
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1


# #save state in DMEM
# addi $30, $30, 1
# sw $31, 0($30)
# jal SAVESTATE
# nop
# nop
# lw $31, 0($30)
# addi $30, $30, -1
# nop
# nop


#Save current state to previous state
j current_to_prevf
nop
#return address pointer for current_to_prev
endcurrent_to_prevf:

#$12 has the angle
#Determine direction it's currently facing
#and call a subroutine that moves it forward


bne $12, $0, northf     #imem SHOULD BE BEQ
#set $1=1 to check for east
addi $1, $0, 1
bne $12, $1, eastf      #imem SHOULD BE BEQ
#set $1=2 to check for east
addi $1, $0, 2
bne $12, $1, southf     #imem SHOULD BE BEQ
#set $1=3 to check for east
addi $1, $0, 3
bne $12, $1, westf      #imem SHOULD BE BEQ


northf:
#sub from y
sub $11, $11, $4
j endforward
eastf:
#add to x
add $10, $10, $4
j endforward
southf:
#add to y
add $11, $11, $4
j endforward
westf:
#sub from x
sub $10, $10, $4
j endforward


endforward:

#draw turtle at the new location
addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#delete turtle at the old location - not necessary. overriden by draw-forward
addi $30, $30, 1
sw $31, 0($30)
jal DELETE_TURTLE
noop
lw $31, 0($30)
addi $30, $30, -1
nop



#draw here: only draw if $3 == 1
bne $3, $0, DRAW_FORWARD
nop
ENDDRAW_FORWARD:

#clear the argument register
addi $4, $0, 0
jr $31 # return after forward



###BACKWARD: bkd x
BACKWARD:


## WRITE B
addi $6, $0, 1
addi $26, $0, 11
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE K
addi $6, $0, 2
addi $26, $0, 22
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE D
addi $6, $0, 3
addi $26, $0, 13
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE WHITESPACE
addi $6, $0, 4
addi $26, $0, 40
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE NUMBER
addi $6, $0, 5
addi $26, $4, 0
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1



# #save state in DMEM
# addi $30, $30, 1
# sw $31, 0($30)
# jal SAVESTATE
# nop
# nop
# lw $31, 0($30)
# addi $30, $30, -1
# nop
# nop


#Save current state to previous state
j current_to_prevb
nop
#return address pointer for current_to_prev
endcurrent_to_prevb:

#$12 has the angle
#Determine direction it's currently facing
#and call a subroutine that moves it backward

bne $12, $0, northb     #imem SHOULD BE BEQ
#set $1=1 to check for east
addi $1, $0, 1
bne $12, $1, eastb      #imem SHOULD BE BEQ
#set $1=2 to check for east
addi $1, $0, 2
bne $12, $1, southb     #imem SHOULD BE BEQ
#set $1=3 to check for east
addi $1, $0, 3
bne $12, $1, westb      #imem SHOULD BE BEQ

northb:
#add to y
add $11, $11, $4
j endbackward
eastb:
#sub from x
sub $10, $10, $4
j endbackward
southb:
#sub from y
sub $11, $11, $4
j endbackward
westb:
#add to x
add $10, $10, $4
j endbackward


endbackward:

#draw turtle at the new location
addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#delete turtle at the old location
addi $30, $30, 1
sw $31, 0($30)
jal DELETE_TURTLE
noop
lw $31, 0($30)
addi $30, $30, -1
nop


#draw here
bne $3, $0, DRAW_BACKWARD
nop
ENDDRAW_BACKWARD:


#clear the argument register
addi $4, $0, 0
jr $31 # return after backward



###SAVE CURRENT STATE TO PREVIOUS STATE
current_to_prevf:
#move $10-$13 to $14-$17
add $14, $0, $10
add $15, $0, $11
add $16, $0, $12
add $17, $0, $13

#back to the subroutine
j endcurrent_to_prevf

###SAVE CURRENT STATE TO PREVIOUS STATE
current_to_prevb:
#move $10-$13 to $14-$17
add $14, $0, $10
add $15, $0, $11
add $16, $0, $12
add $17, $0, $13

#back to the subroutine
j endcurrent_to_prevb


###DRAWBACKWARD: bkd x
DRAW_BACKWARD:
#$12 has the angle

#store operations to move old x, y values in temp registers $6, $7
#store $14 into temp register $6 for x-coord
add $6, $0, $14

#store $15 into temp register $7 for y-coord
add $7, $0, $15

#Determine direction it's currently facing
#and call a subroutine that moves it forward

bne $12, $0, drawnorthb     #imem SHOULD BE BEQ
#set $1=1 to check for east
addi $1, $0, 1
bne $12, $1, draweastb      #imem SHOULD BE BEQ
#set $1=2 to check for south
addi $1, $0, 2
bne $12, $1, drawsouthb     #imem SHOULD BE BEQ
#set $1=1 to check for west
addi $1, $0, 3
bne $12, $1, drawwestb      #imem SHOULD BE BEQ

drawnorthb:
#increment y

#increment $7 (old y) until it equals $11 (new y)
#and leave a trail (SVGA)
drawnorthb_loop:

#if $7 == $11, end
bne $7, $11, enddrawbackward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $7, $7, 1
#loop
j drawnorthb_loop

#below jump is not really necessary but may prevent errors
j enddrawbackward

draweastb:
#decrement x

#decrement $6 (old x) until it equals $10 (new x)
#and leave a trail (SVGA)
draweastb_loop:

#if $6 == $10, end
bne $6, $10, enddrawbackward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $6, $6, -1
#loop
j draweastb_loop

#below jump is not really necessary but may prevent errors
j enddrawbackward

drawsouthb:
#decrement y

#decrement $7 (old y) until it equals $11 (new y)
#and leave a trail (SVGA)
drawsouthb_loop:

#if $7 == $11, end
bne $7, $11, enddrawbackward      #imem SHOULD BE BEQ
#else, leave a trail and decrement
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $7, $7, -1
#loop
j drawsouthb_loop

#below jump is not really necessary but may prevent errors
j enddrawbackward

drawwestb:
#increment x

#decrement $6 (old x) until it equals $10 (new x)
#and leave a trail (SVGA)
drawwestb_loop:

#if $6 == $10, end
bne $6, $10, enddrawbackward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $6, $6, 1
#loop
j drawwestb_loop

#below jump is not really necessary but may prevent errors
j enddrawbackward

enddrawbackward:
#clear the argument register
addi $4, $0, 0
#clear $6 and $7
addi $6, $0, 0
addi $7, $0, 0

#back to return label
j ENDDRAW_BACKWARD




###DRAWFORWARD: fwd x
DRAW_FORWARD:
#$12 has the angle

#store operations to move old x, y values in temp registers $6, $7
#store $14 into temp register $6 for x-coord
add $6, $0, $14

#store $15 into temp register $7 for y-coord
add $7, $0, $15

#Determine direction it's currently facing
#and call a subroutine that moves it forward


bne $12, $0, drawnorthf     #imem SHOULD BE BEQ
#set $1=1 to check for east
addi $1, $0, 1
bne $12, $1, draweastf      #imem SHOULD BE BEQ
#set $1=2 to check for south
addi $1, $0, 2
bne $12, $1, drawsouthf     #imem SHOULD BE BEQ
#set $1=1 to check for west
addi $1, $0, 3
bne $12, $1, drawwestf      #imem SHOULD BE BEQ

drawnorthf:
#decrement y

#decrement $7 (old y) until it equals $11 (new y)
#and leave a trail (SVGA)
drawnorthf_loop:

#if $7 == $11, end
bne $7, $11, enddrawforward     #imem SHOULD BE BEQ
#else, leave a trail and decrement
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $7, $7, -1
#loop
j drawnorthf_loop

#below jump is not really necessary but may prevent errors
j enddrawforward


draweastf:
#increment x

#decrement $6 (old x) until it equals $10 (new x)
#and leave a trail (SVGA)
draweastf_loop:

#if $6 == $10, end
bne $6, $10, enddrawforward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE



addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $6, $6, 1
#loop
j draweastf_loop

#below jump is not really necessary but may prevent errors
j enddrawforward


drawsouthf:
#increment y

#increment $7 (old y) until it equals $11 (new y)
#and leave a trail (SVGA)
drawsouthf_loop:

#if $7 == $11, end
bne $7, $11, enddrawforward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE

addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1

noop
addi $7, $7, 1
#loop
j drawsouthf_loop

#below jump is not really necessary but may prevent errors
j enddrawforward


drawwestf:
#decrement x

#decrement $6 (old x) until it equals $10 (new x)
#and leave a trail (SVGA)
drawwestf_loop:

#if $6 == $10, end
bne $6, $10, enddrawforward      #imem SHOULD BE BEQ
#else, leave a trail and increment
#SVGA CODE HERE
addi $30, $30, 1
sw $31, 0($30)
jal DRAW_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
noop
addi $6, $6, -1
#loop
j drawwestf_loop

#below jump is not really necessary but may prevent errors
j enddrawforward

enddrawforward:
#clear the argument register
addi $4, $0, 0
#clear $6 and $7
addi $6, $0, 0
addi $7, $0, 0

#back to return label
j ENDDRAW_FORWARD


###FILLCELL: svga wrapper for svga per cell for lines
DRAW_FILLCELL:
#Put the svga snippet here
#Use $6 for x, $7 for y, $13 for color

#Initialize temp registers
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0

#calculate top left starting pixel index
#and store it in $20
#(640*15*row) + 15*col + 80 = (640*15*y) + 15*x + 80
#$21 = 640*15
#row = $7, col = $6 !!
addi $27, $0, 15
addi $21, $0, 9600

add $28, $21, $0
add $5, $7, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0
#mul $20, $21, $7		# $20 = 640 * 15 * y

add $28, $27, $0
add $5, $6, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $27, $28, $0
#mul $27, $27, $6		# $27 = 15x


add $20, $20, $27		# $20 = (640 * 15 * y) + 15x
addi $20, $20, 80		# $20 = (640 * 15 * y) + 15x + 80
addi $21, $0, 640       # reset $21 to hold 640

#$22 = 15 (go from 0 to 14)
#$23, $24 are loop variables
addi $22, $0, 15
addi $23, $0, 0
addi $24, $0, 0
addi $27, $0, 1

loopcol11:

bne $23, $22, endloop11 #$22=15	  #imem: SHOULD BE BEQ (11101)!!!

#get the index for this iteration
#$24 is the temporary index
add $24, $20, $23

#color it
sw $13, 0($24)	# imem: SHOULD BE SVGA (01111)!!

#increment index
addi $23, $23, 1


j loopcol11




endloop11:

#ran this outer loop 15 times? then you're done!
bne $27, $22, endloop21	#imem: SHOULD BE BEQ (11101)!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol11


endloop21:
#cell all filled, clear the variables and return
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

jr $31


###DELETE_TURTLE: delete turtle from the prev x and prev y
DELETE_TURTLE:
#Put the svga snippet here
#Use $14 for prev x, $15 for prev y, $13 for color

#Initialize temp registers
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0

#calculate top left starting pixel index
#and store it in $20
#(640*15*row) + 15*col + 80 = (640*15*y) + 15*x + 80
#$21 = 640*15
#row = $7, col = $6 !!
addi $27, $0, 15
addi $21, $0, 9600

add $28, $21, $0
add $5, $15, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0
#mul $20, $21, $7		# $20 = 640 * 15 * y

add $28, $27, $0
add $5, $14, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $27, $28, $0
#mul $27, $27, $6		# $27 = 15x


add $20, $20, $27		# $20 = (640 * 15 * y) + 15x
addi $20, $20, 80		# $20 = (640 * 15 * y) + 15x + 80
addi $21, $0, 640       # reset $21 to hold 640

#$22 = 15 (go from 0 to 14)
#$23, $24 are loop variables
addi $22, $0, 15
addi $23, $0, 0
addi $24, $0, 0
addi $27, $0, 1

loopcol11:

bne $23, $22, endloop11 #$22=15	  #imem: SHOULD BE BEQ (11101)!!!

#get the index for this iteration
#$24 is the temporary index
add $24, $20, $23

#color it using previous line color-> just color it black!!!
sw $17, 0($24)	# imem: SHOULD BE SVGA (01111)!!
#svga $13, 0($24) #TODO: change to svga! : hl130

#increment index
addi $23, $23, 1


j loopcol11




endloop11:

#ran this outer loop 15 times? then you're done!
bne $27, $22, endloop21	#imem: SHOULD BE BEQ (11101)!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol11


endloop21:
#cell all filled, clear the variables and return
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

jr $31


###TURTLE_FILLCELL: svga wrapper for svga per cell for rendering turtle
TURTLE_FILLCELL:
#Put the svga snippet here
#Use $10 for x, $11 for y, $12 for direction, use DMEM

#Initialize temp registers
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
addi $26, $0, 225   # temporarily store size of turtle image, used to index orientation

add $28, $26, $0
add $5, $12, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $26, $28, $0      # $26 = 225*orientation
addi $5, $0, 900
add $28, $18, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $26, $28, $26     # $26 = 225*orientation + 900*index

#mul $26, $12, $26   # multiply orientation by 225 to find starting location
#calculate top left starting pixel index
#and store it in $20
#(640*row) + col + 80 = (640*y) + x + 80
#$21 = 640
#row = $11, col = $10 !!
addi $27, $0, 15
addi $21, $0, 640

add $28, $11, $0
add $5, $21, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0
# mul $20, $21, $11   # $20 = 640 * y

add $28, $20, $0
add $5, $27, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0
#mul $20, $20, $27   # $20 = (640 * y) * 15

add $28, $27, $0
add $5, $10, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult
noop
lw $31, 0($30)
addi $30, $30, -1
add $27, $28, $0
#mul $27, $10, $27       # $27 = x * 15

add $20, $20, $27       # $20 = (640 * y) * 15 + x * 15
addi $20, $20, 80       # $20 = (640*15y) + 15x + 80
addi $27, $0, 1         # reset $27 to 1

#$22 = 15 (go from 0 to 14)
#$23, $24 are loop variables
addi $22, $0, 15
addi $23, $0, 0
addi $24, $0, 0

#$25: color value for turtle from DMEM
#$26: offset in DMEM [0, 254]

loopcol1ti:

bne $23, $22, endloop1ti #$22=15	imem: SHOULD BE BEQ (11101)!!!

#get the index for this iteration
#$24 is the temporary index
add $24, $20, $23


#color it

#first, load from DMEM using DMEM offset
lw $25, 0($26)

sw $25, 0($24)	# imem: SHOULD BE SVGA (01111)!!
#svga $25, 0($24) #TODO: change to svga! : hl130

#increment index
addi $23, $23, 1

#increment DMEM offset
addi $26, $26, 1

j loopcol1ti


endloop1ti:

#ran this outer loop 15 times? then you're done!
bne $27, $22, endloop2ti   # imem: SHOULD BE BEQ (11101)!!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol1ti


endloop2ti:
#cell all filled, clear the variables and return
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

jr $31





###LEFT ROTATE: lrt x
LEFTROTATE:


  ## WRITE L
  addi $6, $0, 1
  addi $26, $0, 23
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE R
  addi $6, $0, 2
  addi $26, $0, 30
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE T
  addi $6, $0, 3
  addi $26, $0, 33
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE WHITESPACE
  addi $6, $0, 4
  addi $26, $0, 40
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE NUMBER
  addi $6, $0, 5
  addi $26, $4, 0
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  # #save state in DMEM
  # addi $30, $30, 1
  # sw $31, 0($30)
  # jal SAVESTATE
  # nop
  # nop
  # lw $31, 0($30)
  # addi $30, $30, -1
  # nop
  # nop

  #$12 has current direction

  #process argument
  j modfour_l
  nop
  endmodfour_l:

  sub $12, $12, $4 #subtract

  #if $12 is negative, add 4
  blt $12, $0, addfour_l
  nop
  endaddfour_l:

  #re-render the turtle
  nop
  nop
  addi $30, $30, 1
  sw $31, 0($30)
  jal TURTLE_FILLCELL
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  nop
  nop


  jr $31 # return after leftrotate


###RIGHT ROTATE: rrt x
RIGHTROTATE:


  ## WRITE R
  addi $6, $0, 1
  addi $26, $0, 30
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE R
  addi $6, $0, 2
  addi $26, $0, 30
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE T
  addi $6, $0, 3
  addi $26, $0, 33
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE WHITESPACE
  addi $6, $0, 4
  addi $26, $0, 40
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1

  ## WRITE NUMBER
  addi $6, $0, 5
  addi $26, $4, 0
  addi $30, $30, 1
  sw $31, 0($30)
  jal WRITE_LETTER
  noop
  lw $31, 0($30)
  addi $30, $30, -1



  # #save state in DMEM
  # addi $30, $30, 1
  # sw $31, 0($30)
  # jal SAVESTATE
  # nop
  # nop
  # lw $31, 0($30)
  # addi $30, $30, -1
  # nop
  # nop

  #$12 has current direction

  #process argument
  j modfour_r
  nop
  endmodfour_r:

  add $12, $12, $4 #add

  #if $12 is greater than 4, we adjust the number
  #subtract 4 and do a blt
  addi $12, $12, -4
  blt $12, $0, addfour_r

  endaddfour_r:

  #re-render the turtle
  nop
  nop
addi $30, $30, 1
  sw $31, 0($30)
  jal TURTLE_FILLCELL
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  nop
  nop

  jr $31 # return after rightrotate




###ARGUMENT PROCESSING FOR ROTATE
modfour_l:
  #Get modulo 4 of the argument
  #and stores it back into $4
  #$6-$9 are temp registers
  #assumes multdiv does not have mod implemented

  #initialize
  addi $6, $0, 4 #$6 = 4
  addi $7, $0, 0
  addi $8, $0, 0
  addi $9, $0, 0

  add $28, $4, $0
  add $5, $6, $0
  addi $30, $30, 1
  sw $31, 0($30)
  jal divide
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  add $7, $28, $0
  #div $7, $4, $6
     add $28, $6, $0
  add $5, $7, $0
  addi $30, $30, 1
  sw $31, 0($30)
  jal mult
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  add $8, $28, $0
  #mul $8, $6, $7

  sub $9, $4, $8

  #store it back to $4
  add $4, $0, $9

  #clear registers--redundant?
  #addi $6, $0, 4 #$6 = 4
  #addi $7, $0, 0
  #addi $8, $0, 0
  #addi $9, $0, 0

  j endmodfour_l #return to rotate

###ARGUMENT PROCESSING FOR ROTATE
modfour_r:
  #Get modulo 4 of the argument
  #and stores it back into $4
  #$6-$9 are temp registers
  #assumes multdiv does not have mod implemented

  #initialize
  addi $6, $0, 4 #$6 = 4
  addi $7, $0, 0
  addi $8, $0, 0
  addi $9, $0, 0

    add $28, $4, $0
  add $5, $6, $0
  addi $30, $30, 1
  sw $31, 0($30)
  jal divide
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  add $7, $28, $0
  #div $7, $4, $6
  add $28, $6, $0
  add $5, $7, $0
  addi $30, $30, 1
  sw $31, 0($30)
  jal mult
  noop
  lw $31, 0($30)
  addi $30, $30, -1
  add $8, $28, $0
  #mul $8, $6, $7
  sub $9, $4, $8

  #store it back to $4
  add $4, $0, $9

  #clear registers--redundant?
  #addi $6, $0, 4 #$6 = 4
  #addi $7, $0, 0
  #addi $8, $0, 0
  #addi $9, $0, 0

  j endmodfour_r #return to rotate


###ADD 4 TO RETURN TO [0, 3] RANGE
addfour_l:
  addi $12, $12, 4

  j endaddfour_l

###ADD 4 TO RETURN TO [0, 3] RANGE
addfour_r:
  addi $12, $12, 4

  j endaddfour_r


mult:
mul $28, $28, $5
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
jr $31

divide:
div $28, $28, $5
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
noop
jr $31


#state save subroutine
SAVESTATE:

#save x-coord
sw $10, 0($29)
addi $29, $29, 1

#save y-coord
sw $11, 0($29)
addi $29, $29, 1

#save orientation
sw $12, 0($29)
addi $29, $29, 1

#save line color (pen color)
sw $13, 0($29)
addi $29, $29, 1

#save penup/down
sw $3, 0($29)
addi $29, $29, 1

#save turtle image index
sw $18, 0($29)
addi $29, $29, 1

jr $31


#CHANGETURTLEINDEX
CHANGETURTLEINDEX:


## WRITE C
addi $6, $0, 1
addi $26, $0, 12
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE T
addi $6, $0, 2
addi $26, $0, 33
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE I
addi $6, $0, 3
addi $26, $0, 20
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE WHITESPACE
addi $6, $0, 4
addi $26, $0, 40
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1

## WRITE NUMBER
addi $6, $0, 5
addi $26, $4, 0
addi $30, $30, 1
sw $31, 0($30)
jal WRITE_LETTER
noop
lw $31, 0($30)
addi $30, $30, -1



# #save state in DMEM
# addi $30, $30, 1
# sw $31, 0($30)
# jal SAVESTATE
# nop
# nop
# lw $31, 0($30)
# addi $30, $30, -1
# nop
# nop

#change the index
#$4(arg: new index) -> $18 and $4=0
add $18, $0, $4
add $4, $0, $0

#re-render the turtle
#save state in DMEM
addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
nop
nop
lw $31, 0($30)
addi $30, $30, -1
nop
nop

jr $31


# @param: $2 is the row
# @param: $6 is the column
# @param: $26 is the letter index
WRITE_LETTER:

# Get DMEM index
add $5, $26, $0
addi $28, $0, 150
addi $30, $30, 1
sw $31, 0($30)
jal mult            # $26 = 150 * index + 3600
noop
lw $31, 0($30)
addi $30, $30, -1
addi $26, $28, 3600

# Initialize temp registers
add $20, $0, $0
addi $21, $0, 640
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
addi $27, $0, 15

add $28, $2, $0
add $5, $21, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult            # $20 = 640 * y
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0

add $28, $20, $0
add $5, $27, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult           # $20 = (640 * y) * 15
noop
lw $31, 0($30)
addi $30, $30, -1
add $20, $28, $0

addi $28, $0, 10
add $5, $6, $0
addi $30, $30, 1
sw $31, 0($30)
jal mult           # $27 = 10 * x
noop
lw $31, 0($30)
addi $30, $30, -1
add $27, $28, $0

add $20, $20, $27       # $20 = 15*(640 * y) + 10x
addi $27, $0, 1         # reset $27 to 1

#$22 = 15 (go from 0 to 14)
#$23, $24 are loop variables
addi $22, $0, 10
addi $7, $0, 15
addi $23, $0, 0
addi $24, $0, 0

#$25: color value for turtle from DMEM
#$26: offset in DMEM [0, 254]

loopcol1t:

bne $23, $22, endloop1t # $22 = 10	imem: SHOULD BE BEQ (11101)!!!

#get the index for this iteration
#$24 is the temporary index
add $24, $20, $23


#color it

#first, load from DMEM using DMEM offset
lw $25, 0($26)

sw $25, 0($24)	# imem: SHOULD BE SVGA (01111)!!
#svga $25, 0($24) #TODO: change to svga! : hl130

#increment index
addi $23, $23, 1

#increment DMEM offset
addi $26, $26, 1

j loopcol1t


endloop1t:

#ran this outer loop 15 times? then you're done!
bne $27, $7, endloop2t   # imem: SHOULD BE BEQ (11101)!!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol1t


endloop2t:
#cell all filled, clear the variables and return
add $6, $0, $0
add $7, $0, $0
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

jr $31


#UNDO
UNDO:
#initialize
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0
add $27, $0, $0
#add $6, $0, $0
#add $7, $0, $0
#add $8, $0, $0
#add $9, $0, $0

#restore the six state values $20-$25
addi $29, $29, -1
nop
nop
nop
lw $25, 0($29)
nop
nop
nop
addi $29, $29, -1
nop
nop
nop
lw $24, 0($29)
nop
nop
nop
addi $29, $29, -1
nop
nop
nop
lw $23, 0($29)
nop
nop
nop
addi $29, $29, -1
nop
nop
nop
lw $22, 0($29)
nop
nop
nop
addi $29, $29, -1
nop
nop
nop
lw $21, 0($29)
nop
nop
nop
addi $29, $29, -1
nop
nop
nop
lw $20, 0($29)
nop
nop
nop

###THE FOLLOWING BLOCK IS WRONG###
#increment the state so that next SAVESTATE is ready to store
#addi $29, $29, 1
##################################

#set pendown
addi $3, $0, 1

#just delete the path by setting pencolor to black
add $13, $0, $0

#find x-delta: prev-curr in $26
sub $26, $20, $10

#find y-delta: prev-curr in $27
sub $27, $21, $11

#satisfy the deltas by going forward
#$26 in $4: Horizontal delta and face east
add $4, $0, $26
addi, $12, $0, 1 #east
addi $30, $30, 1
sw $31, 0($30)
jal FORWARD
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#$27 in $4: Vertical delta and face south
add $4, $0, $27
addi, $12, $0, 2 #south
addi $30, $30, 1
sw $31, 0($30)
jal FORWARD
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#undo penup/down
#add $3, $24, $0
nop
nop
lw $3, 4($29)
nop
nop

#restore prev orientation
#add $12, $22, $0
nop
nop
lw $12, 2($29)
nop
nop

#restore prev pencolor
#add $13, $23, $0
nop
nop
lw $13, 3($29)
nop
nop


#restore location
#add $10, $20, $0
nop
nop
lw $10, 0($29)
nop
nop
#add $11, $21, $0
nop
nop
lw $11, 1($29)
nop
nop

#restore turtle image index
#add $18, $25, $0
nop
nop
lw $18, 5($29)
nop
nop


#refresh turtle image
addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#clear out the temp registers
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0
add $27, $0, $0

#all restored, now return
jr $31



#REDO
REDO:

#initialize
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0
add $27, $0, $0

#get the next state values $20-$25

#shift 6 forward
addi $29, $29, 6

nop
nop
nop
lw $20, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $21, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $22, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $23, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $24, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $25, 0($29)
nop
nop
nop
addi $29, $29, 1
nop
nop
nop


#find x-delta: next-curr in $26
sub $26, $20, $10

#find y-delta: next-curr in $27
sub $27, $21, $11

#satisfy the deltas by going forward
#$26 in $4: Horizontal delta and face east
add $4, $0, $26
addi, $12, $0, 1 #east
addi $30, $30, 1
sw $31, 0($30)
jal FORWARD
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#$27 in $4: Vertical delta and face south
add $4, $0, $27
addi, $12, $0, 2 #south
addi $30, $30, 1
sw $31, 0($30)
jal FORWARD
noop
lw $31, 0($30)
addi $30, $30, -1
nop

#By now, location has been redone

#redo other states

#shift 6 backward to reread
addi $29, $29, -6

nop
nop
nop
lw $10, 0($29) #x
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $11, 0($29) #y
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $12, 0($29) #orientation
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $13, 0($29) #pencolor
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $3, 0($29) #pen flag
nop
nop
nop
addi $29, $29, 1
nop
nop
nop
lw $18, 0($29) #turtle index
nop
nop
nop
addi $29, $29, 1
nop
nop
nop

# #restore next orientation
# add $12, $22, $0

# #restore next pencolor
# add $13, $23, $0

# #restore next pen up/down
# add $3, $24, $0

# #update location
# add $10, $20, $0
# add $11, $21, $0

# #restore next turtle image index
# add $18, $25, $0

#refresh turtle image
addi $30, $30, 1
sw $31, 0($30)
jal TURTLE_FILLCELL
noop
lw $31, 0($30)
addi $30, $30, -1
nop


#clear out the temp registers
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0
add $27, $0, $0



#all redone, return
jr $31



#PENDOWN
PNDN:

# #call savestate
# addi $30, $30, 1
# sw $31, 0($30)
# jal SAVESTATE
# noop
# lw $31, 0($30)
# addi $30, $30, -1
# nop

#change pen flag to 1
addi $3, $0, 1

jr $31

#PENUP
PNUP:


# #call savestate
# addi $30, $30, 1
# sw $31, 0($30)
# jal SAVESTATE
# noop
# lw $31, 0($30)
# addi $30, $30, -1
# nop

#change pen flag to 0
addi $3, $0, 0

jr $31

