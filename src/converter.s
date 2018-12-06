.data
	inputString: .space 64
	romans: .asciiz "IVXLCDM"
	prompt: .asciiz "\nEnter Roman Numerals or 0 to quit: \n"
	output: .asciiz "The number you entered was: "
	stopped: .asciiz "\nStopped.\n"
		
.text 
	.globl main
		main:                               # convert roman numerals to arabic numerals
         
            		# initialize registers that we use
          		#add $t0, $zero, $zero
            		#add $t1, $zero, $zero
            		#add $t2, $zero, $zero
            		#add $t5, $zero, $zero
            		#add $t6, $zero, $zero
            		add $t7, $zero, $zero
            		add $s0, $zero, $zero
            		add $s1, $zero, $zero
            		add $s7, $zero, $zero

            		# populate $t7 with an array containing the Roman numerals

            		la $t7, romans
            
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
            		add $t0, $0, $0
           		li $t0, 0               # initialize counter

			lengloop:   
				add $s1, $s0, $t0       # $s1 contains string[i]
            			lb $a0, 0($s1)          # load the byte of interest
            			# make sure this points to the register holding the SINGLE char
            			beq $a0, $0, convert # reached end of string, stop counting
            			addi $t0, $t0, 1        # increment counter (move onto next element)
            			j lengloop              # go back to beginning of loop 

            		# convert user input to Arabic numerals character by character
			convert:   
				addi $t0, $t0, -1       # adjust counter

           		# convert char by char
			charloop:   
				# $t0 contains the length of the string
            			# $s0 contains the string
           			# work backwards on the string
            			add $s1, $s0, $t0       # $s1 contains string[i]
            			add $t2, $0, $0
            			lb $t2, 0($s1)          # load the ascii value of interest

           			# is $t2 equal to 'q'? then exit program

           			add $t1, $0, $0
            			addi $t1, $0, 48    # load ascii value of 'q'
            			beq $t2, $t1, exit      # jump to exit

            		# which character is $s1? branches to find out

		        add $t6, $0, $0
            		addi $t1, $0, 73         # load I, 1, ascii 73
            		beq $t2, $t1, one       # it is a 1, jump to that
	    		addi $t1, $0, 105         # load I, 1, ascii 73
            		beq $t2, $t1, one       # it is a 1, jump to that
		
            		addi $t1, $0, 86          # load V, 5, ascii 86
            		beq $t2, $t1, five      # it is a 5, jump to that
            		addi $t1, $0, 118          # load V, 5, ascii 86
            		beq $t2, $t1, five      # it is a 5, jump to that

            		addi $t1, $0, 88          # load X, 10, ascii 88
            		beq $t2, $t1, ten       # it is a 10, jump to that
	   		addi $t1, $0, 120          # load X, 10, ascii 88
           		beq $t2, $t1, ten       # it is a 10, jump to that

            		addi $t1, $0, 76          # load L, 50, ascii 76
            		beq $t2, $t1, fifty     # it is a 50, jump to that
   	    		addi $t1, $0, 108          # load L, 50, ascii 76
            		beq $t2, $t1, fifty     # it is a 50, jump to that

            		addi $t1, $0, 67          # load C, 100, ascii 67
            		beq $t2, $t1, hundred   # it is a 100, jump to that
            		addi $t1, $0, 99          # load C, 100, ascii 67
            		beq $t2, $t1, hundred   # it is a 100, jump to that

            		addi $t1, $0, 68          # load D, 500, ascii 68
            		beq $t2, $t1, fivehun   # it is a 500, jump to that
            		addi $t1, $0, 100          # load D, 500, ascii 68
            		beq $t2, $t1, fivehun   # it is a 500, jump to that

           		addi $t1, $0, 77          # load M, 1000, ascii 77
            		beq $t2, $t1, thousand  # it is a 1000, jump to that
            		addi $t1, $0, 109          # load M, 1000, ascii 77
            		beq $t2, $t1, thousand  # it is a 1000, jump to that

            		#if you're here, it means you didn't branch earlier
            		add $t5, $0, $0   # initialize comparison register
            		j next                  # not valid Roman numeral; skip to next loop
			one:      
				addi $t6, $0, 1      # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			five:       
				addi $t6, $0, 5      # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			ten:        
				addi $t6, $0, 10     # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			fifty:      
				addi $t6, $0, 50     # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			hundred:   
				addi $t6, $0, 100    # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			fivehun:    
				addi $t6, $0, 500    # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			thousand:   
				addi $t6, $0, 1000   # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion

		oper:       
			# determine whether the value needs to be added or subtracted,
			# and then do the operation
            		# if current value is lower than previous value, subtract!
            		blt $t6, $t5, subtract
            		# otherwise, just add the new value to total
            		add $s7, $s7, $t6
            		j next

		subtract:   sub $s7, $s7, $t6

		next:       # make sure this points to the register holding the SINGLE char
            		beq $t0, $0, print   # reached start of string, exit
            		move $t5, $t6           # store current value for next loop
            		addi $t0, $t0, -1       # decrement (move to preceding element)
            		j charloop              # go back to beginning of loop

		print:      
			li $v0, 4               # print string
            		la $a0, output          # the text for output
            		syscall                 # call operating system       

            		li $v0, 1               # print calculated Arabic integer
            		move $a0, $s7           # the calculated Arabic integer
            		syscall                 # call operating system

            		# loop; continue program
            		j main

		exit:      
			li $v0, 4               # print string
            		la $a0, stopped         # the text for stopped
            		syscall                 # call operating system
            		li $v0, 10              # finished .. stop .. return
            		syscall                 # to the Operating System
