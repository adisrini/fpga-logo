#Convention
#JavaFX convention: x points right, y points down
#$20: x-coordinate
#$21: y-coordinate
#$22: angle with up being 0 degree, clockwise
#$10-20 temporary registers?
#$1 is an argument register

#Code angle 0-3
#$2 = 0 (north), $3 = 1 (east) $4 = 2 (south) $5 = 3 (west)



#####bkd x
backward:

    #$22 has the angle
    beq $22, 0, northb
    beq $22, 1, eastb
    beq $22, 2, southb
    beq $22, 3, westb
    
northb:
    #add to y
    add $21, $21, $1
    j endforward
eastb:
    #sub from x
    sub $21, $21, $1
    j endforward
southb:
    #sub from y
    sub $21, $21, $1
    j endforward
westb:
    #add to x
    add $20, $20, $1
    j endforward

endbackward:
    jr $31 # return after forward