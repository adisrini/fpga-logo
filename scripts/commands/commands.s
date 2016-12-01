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
    j current_to_prev
    nop
    #return address pointer for current_to_prev
endcurrent_to_prev:

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
    j current_to_prev
    nop
    #return address pointer for current_to_prev
endcurrent_to_prev:

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

    #draw here
    j DRAW_BACKWARD:
    nop
    ENDDRAW_BACKWARD:


    #clear the argument register
    addi $4, $0, 0
    jr $31 # return after backward
    

    
###SAVE CURRENT STATE TO PREVIOUS STATE
current_to_prev:
    #move $10-$13 to $14-$17
    addi $14, $0, $10
    addi $15, $0, $11
    addi $16, $0, $12
    addi $17, $0, $13 
    
    #back to the subroutine
    j endcurrent_to_prev
    
    
    
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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
        j STOREVGA 
        ENDSTOREVGA:
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


###STOREVGA wrapper for svga per cell
STOREVGA:
    #Put the svga snippet here
    #Use $6 for x, $7 for y, $13 for color

    j ENDSTOREVGA

    
    
    
    
    
###LEFT ROTATE: lrt x
LEFTROTATE:
    #$12 has current direction
    
    #process argument
    jal modfour
    
    sub $12, $12, $4 #subtract
    
    #if $12 is negative, add 4
    blt $12, $0, addfour
    
    jr $31 # return after leftrotate

    
###RIGHT ROTATE: rrt x
RIGHTROTATE:
    #$12 has current direction
    
    #process argument
    jal modfour
    
    add $12, $12, $4 #add
    
    #if $12 is greater than 4, we adjust the number
    #subtract 4 and do a blt
    addi $12, $12, -4
    blt $12, $0, addfour
    
    jr $31 # return after rightrotate
    
    
    
    
###ARGUMENT PROCESSING FOR ROTATE
modfour:
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
    
    jr $31 #return to rotate

    
###ADD 4 TO RETURN TO [0, 3] RANGE
addfour:
    addi $12, $12, 4
    jr $31
    
    
