# A[i] = A[i/2] + 1;
    lw     $t0, 0($gp)       # fetch i
    srl    $t0, $t0, 1       # i/2
    addi   $t1, $gp, 28      # &A[0]
    sll    $t0, $t0, 2       # turn i/2 into a byte offset (*4)
    add    $t1, $t1, $t0     # &A[i/2]
    lw     $t1, 0($t1)       # fetch A[i/2]
    addi   $t1, $t1, 1       # A[i/2] + 1
    lw     $t0, 0($gp)       # fetch i
    sll    $t0, $t0, 2       # turn i into a byte offset 
    addi   $t2, $gp, 28      # &A[0]
    add    $t2, $t2, $t0     # &A[i]
    sw     $t1, 0($t2)       # A[i] = ...
# A[i+1] = -1;
    lw     $t0, 0($gp)       # fetch i
    addi   $t0, $t0, 1       # i+1
    sll    $t0, $t0, 2       # turn i+1 into a byte offset
    addi   $t1, $gp, 28      # &A[0]
    add    $t1, $t1, $t0     # &A[i+1]
    addi   $t2, $zero, -1    # -1
    sw     $t2, 0($t1)       # A[i+1] = -1