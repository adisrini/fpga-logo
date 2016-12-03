#Convention
#JavaFX convention: x points right, y points down
#$10: x-coordinate
#$11: y-coordinate
#$12: current direction
#$4 is the argument register

#Direction code [0-3]
#THESE VALUES ARE HARD-CODED
#$0 = 0 (north), $1 = 1 (east) $2 = 2 (south) $3 = 3 (west)

#Initialization code
#Fix $0-$3 to Direction code for ease of comparison
addi $1, $0, 1 #east
addi $2, $0, 2 #south
addi $3, $0, 3 #west

#Initial turtle coordinate is the center of the grid
#Starting (15, 15), North, Red
addi $10, $0, 15
addi $11, $0, 15
addi $12, $0, 0
addi $13, $0, 0

#Default $30: pen down (1).  pen up is (0)
addi $30, $0, 1



    
    

###FORWARD: fwd x
FORWARD:
    #Save current state to previous state
    j current_to_prevf
    nop
    #return address pointer for current_to_prev
endcurrent_to_prevf:

    #$12 has the angle
    #Determine direction it's currently facing
    #and call a subroutine that moves it forward
    beq $12, $0, northf
    beq $12, $1, eastf
    beq $12, $2, southf
    beq $12, $3, westf
    
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
    sub $11, $11, $4
    j endforward



    
    
    
endforward:

    #draw turtle at the new location
    j TURTLE_FILLCELL
    nop
    ENDTURTLE_FILLCELL:

    #draw here
    j DRAW_FORWARD
    nop
    ENDDRAW_FORWARD:

    #clear the argument register
    addi $4, $0, 0
    jr $31 # return after forward
    
    

###BACKWARD: bkd x
BACKWARD:
    #Save current state to previous state
    j current_to_prevb
    nop
    #return address pointer for current_to_prev
endcurrent_to_prevb:

    #$12 has the angle
    #Determine direction it's currently facing
    #and call a subroutine that moves it backward
    beq $12, $0, northb
    beq $12, $1, eastb
    beq $12, $2, southb
    beq $12, $3, westb
    
northb:
    #add to y
    add $11, $11, $4
    j endforward
eastb:
    #sub from x
    sub $11, $11, $4
    j endforward
southb:
    #sub from y
    sub $11, $11, $4
    j endforward
westb:
    #add to x
    add $10, $10, $4
    j endforward

    
endbackward:

    #draw turtle at the new location
    j TURTLE_FILLCELL
    nop
    ENDTURTLE_FILLCELL:

    #draw here
    j DRAW_BACKWARD
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
    beq $12, $0, drawnorthb
    beq $12, $1, draweastb
    beq $12, $2, drawsouthb
    beq $12, $3, drawwestb
    
drawnorthb:
    #increment y

    #increment $7 (old y) until it equals $11 (new y)
    #and leave a trail (SVGA)
    drawnorthb_loop:

        #if $7 == $11, end
        beq $7, $11, enddrawbackward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $6, $10, enddrawbackward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $7, $11, enddrawbackward
        #else, leave a trail and decrement
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $6, $10, enddrawbackward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
    beq $12, $0, drawnorthf
    beq $12, $1, draweastf
    beq $12, $2, drawsouthf
    beq $12, $3, drawwestf
    
drawnorthf:
    #decrement y

    #decrement $7 (old y) until it equals $11 (new y)
    #and leave a trail (SVGA)
    drawnorthf_loop:

        #if $7 == $11, end
        beq $7, $11, enddrawforward
        #else, leave a trail and decrement
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $6, $10, enddrawforward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $7, $11, enddrawforward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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
        beq $6, $10, enddrawforward
        #else, leave a trail and increment
        #SVGA CODE HERE
        j DRAW_FILLCELL
        nop        
        ENDDRAW_FILLCELL:
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

# choose x, y, color
addi $6, $0, 15
addi $7, $0, 31
addi $13, $0, 1

#calculate top left starting pixel index
#and store it in $20
#(640*15*row) + 15*col + 80 = (640*15*y) + 15*x + 80
#$21 = 640*15
#row = $7, col = $6 !!
addi $27, $0, 15
addi $21, $0, 9600
mul $20, $21, $7		# $20 = 640 * 15 * y
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
mul $27, $27, $6		# $27 = 15x
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
add $20, $20, $27		# $20 = (640 * 15 * y) + 15x
addi $20, $20, 80		# $20 = (640 * 15 * y) + 15x + 80
addi $21, $0, 640       # reset $21 to hold 640

#$22 = 15 (go from 0 to 14)
#$23, $24 are loop variables
addi $22, $0, 15
addi $23, $0, 0
addi $24, $0, 0
addi $27, $0, 1

loopcol1:

bne $23, $22, endloop1 #$22=15	  imem: SHOULD BE BEQ (11101)!!!

#get the index for this iteration
#$24 is the temporary index
add $24, $20, $23

#color it
sw $13, 0($24)	# imem: SHOULD BE SVGA (01111)!!
#svga $13, 0($24) #TODO: change to svga! : hl130 

#increment index
addi $23, $23, 1


j loopcol1




endloop1:

#ran this outer loop 15 times? then you're done!
bne $27, $22, endloop2	# imem: SHOULD BE BEQ (11101)!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol1


endloop2:
#cell all filled, clear the variables and return
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

j ENDDRAW_FILLCELL

    
###TURTLE_FILLCELL: svga wrapper for svga per cell for rendering turtle
TURTLE_FILLCELL:
	#Put the svga snippet here
	#Use $10 for x, $11 for y, use DMEM 

	#Initialize temp registers
	add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $25, $0, $0
add $26, $0, $0

#calculate top left starting pixel index
#and store it in $20
#(640*row) + col + 80 = (640*y) + x + 80
#$21 = 640
#row = $11, col = $10 !!
addi $27, $0, 15
addi $21, $0, 640
mul $20, $21, $11   # $20 = 640 * y
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
mul $20, $20, $27   # $20 = (640 * y) * 15
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
mul $27, $10, $27       # $27 = x * 15
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

loopcol1t:

bne $23, $22, endloop1t #$22=15	imem: SHOULD BE BEQ (11101)!!!

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
bne $27, $22, endloop2t   # imem: SHOULD BE BEQ (11101)!!!

#first, increment the outer loop variable
addi $27, $27, 1

#one iteration is done, so add 640 to $20
add $20, $20, $21

#now set loop var to 0 and loop again 15 times
add $23, $0, $0 #inner loop var 0
j loopcol1t


	endloop2t:
#cell all filled, clear the variables and return
add $20, $0, $0
add $21, $0, $0
add $22, $0, $0
add $23, $0, $0
add $24, $0, $0
add $27, $0, $0

j ENDTURTLE_FILLCELL
    
    
###LEFT ROTATE: lrt x
LEFTROTATE:
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
    
    jr $31 # return after leftrotate

    
###RIGHT ROTATE: rrt x
RIGHTROTATE:
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
    
    div $7, $1, $6 
    mul $8, $6, $7
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
    
    div $7, $1, $6 
    mul $8, $6, $7
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