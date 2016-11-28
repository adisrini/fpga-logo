#Convention
#JavaFX convention: x points right, y points down
#$20: x-coordinate
#$21: y-coordinate
#$22: angle with up being 0 degree, clockwise
#$10-20 temporary registers?
#$1 is an argument register

#Code angle 0-3
#$2 = 0 (north), $3 = 1 (east) $4 = 2 (south) $5 = 3 (west)



#####fwd x
forward:
    #These two lines not needed--Hunter
    #lw $10, 0($20) #load x coordinate
    #lw $11, 0($21) #load y coordinate
    
    #$22 has the angle
    beq $22, 0, north
    beq $22, 1, east
    beq $22, 2, south
    beq $22, 3, west
    
north:
    #sub from y
    sub $21, $21, $1
    j endforward
east:
    #add to x
    add $20, $20, $1
    j endforward
south:
    #add to y
    add $21, $21, $1
    j endforward
west:
    #sub from x
    sub $21, $21, $1
    j endforward

endforward:
    jr $31 # return after forward