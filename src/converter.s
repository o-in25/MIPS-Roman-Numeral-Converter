            .globl main
main:                               # convert roman numerals to arabic numerals
            .text

            # initialize registers that we use
            add $t0, $zero, $zero
            add $t1, $zero, $zero
            add $t2, $zero, $zero
            add $t5, $zero, $zero
            add $t6, $zero, $zero
            add $t7, $zero, $zero
            add $s0, $zero, $zero
            add $s1, $zero, $zero
            add $s7, $zero, $zero

            # populate $t7 with an array containing the Roman numerals

            la $t7, romans

            # 0($t7) will contain I, 1, ascii 73
            # 1($t7) will contain V, 5, ascii 86
            # 2($t7) will contain X, 10, ascii 88
            # 3($t7) will contain L, 50, ascii 76
            # 4($t7) will contain C, 100, ascii 67
            # 5($t7) will contain D, 500, ascii 68
            # 6($t7) will contain M, 1000, ascii 77
            
            # test to make sure correct values are in array

            #li $v0, 1               # print ascii int
            #lb $a0, 0($t7)          # the first int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 1($t7)          # the second int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 2($t7)          # the third int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 3($t7)          # the fourth int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 4($t7)          # the fifth int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 5($t7)          # the sixth int of roman numerals
            #syscall                 # call operating system

            #li $v0, 1               # print ascii int
            #lb $a0, 6($t7)          # the seventh int of roman numerals
            #syscall                 # call operating system           

            
            # prompt user for input 

            li $v0, 4               # print string
            la $a0, prompt          # set string
            syscall                 # print string

            li $v0, 8               # prompt for string
            la $a0, inputString     # address for buffer
            la $a1, 64              # size of buffer
            syscall                 # get string

            # find out how long the characters are

            la $s0, inputString     # move string to register
            li $t0, 0               # initialize counter

lengloop:   add $s1, $s0, $t0       # $s1 contains string[i]
            lb $a0, 0($s1)          # load the byte of interest

            # make sure this points to the register holding the SINGLE char
            beq $a0, $zero, convert # reached end of string, stop counting

            addi $t0, $t0, 1        # increment counter (move onto next element)
            j lengloop              # go back to beginning of loop 

            # convert user input to Arabic numerals character by character

convert:    addi $t0, $t0, -1       # adjust counter

            # convert char by char

charloop:   # $t0 contains the length of the string
            # $s0 contains the string
            # work backwards on the string

            add $s1, $s0, $t0       # $s1 contains string[i]
            lb $t2, 0($s1)          # load the ascii value of interest

            # is $t2 equal to 'q'? then exit program
            addi $t1, $zero, 113    # load ascii value of 'q'
            beq $t2, $t1, exit      # jump to exit

            # which character is $s1? branches to find out

            lb $t1, 0($t7)          # load I, 1, ascii 73
            beq $t2, $t1, one       # it is a 1, jump to that

            lb $t1, 1($t7)          # load V, 5, ascii 86
            beq $t2, $t1, five      # it is a 5, jump to that

            lb $t1, 2($t7)          # load X, 10, ascii 88
            beq $t2, $t1, ten       # it is a 10, jump to that

            lb $t1, 3($t7)          # load L, 50, ascii 76
            beq $t2, $t1, fifty     # it is a 50, jump to that

            lb $t1, 4($t7)          # load C, 100, ascii 67
            beq $t2, $t1, hundred   # it is a 100, jump to that

            lb $t1, 5($t7)          # load D, 500, ascii 68
            beq $t2, $t1, fivehun   # it is a 500, jump to that

            lb $t1, 6($t7)          # load M, 1000, ascii 77
            beq $t2, $t1, thousand  # it is a 1000, jump to that

            #if you're here, it means you didn't branch earlier
            add $t5, $zero, $zero   # initialize comparison register
            j next                  # not valid Roman numeral; skip to next loop

one:        addi $t6, $zero, 1      # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

five:       addi $t6, $zero, 5      # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

ten:        addi $t6, $zero, 10     # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

fifty:      addi $t6, $zero, 50     # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

hundred:    addi $t6, $zero, 100    # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

fivehun:    addi $t6, $zero, 500    # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

thousand:   addi $t6, $zero, 1000   # load Arabic value in register
            j oper                  # jump to addition/subtraction portion

oper:       # determine whether the value needs to be added or subtracted,
            # and then do the operation

            # if current value is lower than previous value, subtract!
            blt $t6, $t5, subtract

            # otherwise, just add the new value to total
            add $s7, $s7, $t6
            j next

subtract:   sub $s7, $s7, $t6

next:       # make sure this points to the register holding the SINGLE char
            beq $t0, $zero, print   # reached start of string, exit

            move $t5, $t6           # store current value for next loop
            addi $t0, $t0, -1       # decrement (move to preceding element)
            j charloop              # go back to beginning of loop

print:      li $v0, 4               # print string
            la $a0, output          # the text for output
            syscall                 # call operating system       

            li $v0, 1               # print calculated Arabic integer
            move $a0, $s7           # the calculated Arabic integer
            syscall                 # call operating system

            # loop; continue program
            j main

exit:       li $v0, 4               # print string
            la $a0, stopped         # the text for stopped
            syscall                 # call operating system

            li $v0, 10              # finished .. stop .. return
            syscall                 # to the Operating System

            .data
inputString:
            .space 64
romans:     .asciiz "IVXLCDM"
prompt:     .asciiz "\nPlease enter Roman numerals in capital letters to convert to Arabic numerals, or the lower-case letter 'q' to exit the program:\n"
output:     .asciiz "The number you entered was "
stopped:    .asciiz "\nStopped.\n"