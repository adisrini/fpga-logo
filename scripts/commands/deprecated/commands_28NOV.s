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


###FORWARD: fwd x
forward:
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
    #clear the argument register
    addi $4, $0, 0
    jr $31 # return after forward
    

###BACKWARD: bkd x
backward:
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
    #clear the argument register
    addi $4, $0, 0
    jr $31 # return after backward
    

###LEFT ROTATE: lrt x
leftrotate:
    #$12 has current direction
    
    #process argument
    jal modfour
    
    sub $12, $12, $4 #subtract
    
    #if $12 is negative, add 4
    blt $12, $0, addfour
    
    jr $31 # return after leftrotate

    
###RIGHT ROTATE: rrt x
rightrotate:
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
    
    
