.data

	entryPrompt: .asciiz "\nEnter Roman Numerals or 0 to quit: \n"
	exitPrompt: .asciiz "\So long, and thanks for all the fish\n"
	output: .asciiz "Arabic Numeral:  "
	input: .word 64 # 2 words - just in case

		
.text 
	.globl main
		main:                               
            		# Prints the prompt for the user to enter a 
           		# Roman numeral. The operation will support both 
           		# upper and lower case numerals, as documented below. Per the 
           		# MIPS documentation, $a0 will conatin the address of 
           		# null-terminated string to print (i.e. asciiz). Then, make a request 
           		# to the OS kernel with  a syscall by placing the value 4 in the $v0 register to read 
            		# the string.
            		promptInput:
           			la $a0, entryPrompt # set string
           			li $v0, 4 # print string
           			syscall # make a syscall to the kernel 
            		
            		# Gets the input from the user, and stores the value in the 
            		# $a0 register. Per the MIPS documentation, 
            		# $a0 will conatin the address of input buffer and 
            		# $a1 will contain maximum number of characters to read. 
            		# In this case, the maximum number of characters to read will 
            		# simply be 2 words. Then, make a request to the OS kernel with 
            		# a syscall by placing the value 8 in the $v0 register to read 
            		# the string.
            		getInput:
            			la $a0, input # the address of input buffer (string)
            			move $a1, $a0 # maximum number of characters to read - the same as the input string 
            			li $v0, 8 # prompt for string
            			syscall # make a syscall to the kernel
            		move $s0, $a0 # the $a0 register will contain the user input
           		add $s7, $0, $0 # initialize the $s7 register - it will be used later
           		li $t0, 0 # the index of the input length loop - used to find the length of the input string =
			
			# Get the length of the input string by looping 
			# through each character until we reach the end of 
			# the input string. 
			getInputLength:
				addu $s1, $s0, $t0 # get the input string at character i
            			lbu $a0, 0($s1) # load the character as a byte, per MIPS documentation
            			bne $a0, $0, increment # if we are not at the end, increment the counter
            			j charloop # the end has been reach, continue on
			
			# Increment the index counter by 1,
			# and keep looping through the string
			increment:
				addi $t0, $t0, 1 # increment the index
				j getInputLength # go back to the loop


           		# convert char by char
			charloop:   
				# $t0 contains the length of the string
            			# $s0 contains the string
           			# work backwards on the string
            			addu $s1, $s0, $t0 # get the input string at character i
            			lbu $t2, 0($s1)  # load the character as a byte, per MIPS documentationt
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
            		la $a0, exitPrompt         # the text for stopped
            		syscall                 # call operating system
            		li $v0, 10              # finished .. stop .. return
            		syscall                 # to the Operating System
