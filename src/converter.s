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
            			bne $a0, $0, increment # the null character is defined as 0 - per ASCII documentation; if the character is 0, the end of the string has been reached
            			j charloop # the end has been reach, continue on
			
			# Increment the index counter by 1,
			# and keep looping through the string
			increment:
				addi $t0, $t0, 1 # increment the index
				j getInputLength # go back to the loop

           		# Once the length of the entered user string is computed,
           		# we will work at character n, then n-1, decrementing until character 0. From the previous
           		# subroutines, $t0 will hold the string length, and the $s0 will contain the 
           		# string itself. If the next character is 0, this signifies user termination, and thus the program will enter 
           		# its exit routine and will terminate. 
			charloop:  
            			addu $s1, $s0, $t0 # add the length of the string into $s1
            			lbu $t2, 0($s1)  # load the character as a byte, per MIPS documentation, beggining at the nth character 
            			addi $t1, $0, 48 # load ASCII value of the character of 0 - a well known constant found in the ASCII documentation	
            			move $s6, $t1 # move the ASCII character into a peristent register 
            			bne $t2, $t1, mapCharacters # if the entered string is not 0, (i.e. the exit input) map the characters 
            			j exit # the entered character is 0, and therefore the program will terminate 

			# Since the user entered character is not the termination character, it is therefore a Roman Numeral. 
			# Here, this relation will serve as a "pseudo map" data structure, where there wll exist a injective funtion 
			# between each entered character and its corresponding ASCII character. Therefore, no two  characters will share the same 
			# Roman numeral mapping. Here, the $s6 register will contain the well-known ASCII character. The mapCharacters funtion will
			# "pass down" the character according to which ASCII series range it lies in. (This is done for performance purposes, since
			# this "pesudo-map" behaves more like a switch statement, and cannot be done in O(1) time, but O(n)). If the 
			# entered user character matches a corresponding ASCII key, it is then branched to that handler. Additionally, the map will
			# allow for the user to enter both upper and lowercase Roman Numerals. This design was inspired by the "pass up or die" pattern 
			# studied this semester.
			mapCharacters:
				add $t6, $0, $0 # the $t0 register is initalized - it will be used later 
				# If the character is passed down to the sixty series, its ASCII character is then checked 
				# if it is > 69. If so, it is passed down further to the next series. Else, it 
				# lies between 60-69.
				sixtySeries:
					bge $s6, 70, seventySeries # pass it down to the next series 
            				li $t1, 67 # ASCII 67 corresponds C and is loaded into $t1
            				beq $t2, $t1, conversionToHundredHandler # advance to the conversion handler for 100 in arabic
            				li $t1, 68 # ASCII 68 corresponds D and is loaded into $t1
            				beq $t2, $t1, conversionToFiveHundredHandler # advance to the conversion handler for 500 in arabic
            			# If the character is passed down to the seventy series, its ASCII character is then checked 
				# if it is > 79. If so, it is passed down further to the next series. Else, it 
				# lies between 70-79.
				seventySeries:
					bge $s6, 80, eightySeries # pass it down to the next series
            				li $t1, 73 # ASCII 73 corresponds I and is loaded into $t1
            				beq $t2, $t1, conversionToOneHandler # advance to the conversion handler for 1 in arabic
            				li $t1, 76 # ASCII 76 corresponds L and is loaded into $t1
            				beq $t2, $t1, conversionToFiftyHandler # advance to the conversion handler for 50 in arabic
            				li $t1, 77 # ASCII 77 corresponds M and is loaded into $t1
            				beq $t2, $t1, conversionToThousandHandler # advance to the conversion handler for 1000 in arabic
	    			# If the character is passed down to the eighty series, its ASCII character is then checked 
				# if it is > 89. If so, it is passed down further to the next series. Else, it 
				# lies between 80-89.
				eightySeries:     
					bge $s6, 90, ninetySeries # pass it down to the next series 
					li $t1, 86 # ASCII 86 corresponds V and is loaded into $t1
            				beq $t2, $t1, conversionToFiveHandler # advance to the conversion handler for 5 in arabic
            				li $t1, 88 # ASCII 88 corresponds X and is loaded into $t1
            				beq $t2, $t1, conversionToTenHandler # advance to the conversion handler for 10 in arabic
            			# If the character is passed down to the ninety series, its ASCII character is then checked 
				# if it is > 99. If so, it is passed down further to the next series. Else, it 
				# lies between 90-99.
           			ninetySeries:
           				bge $s6, 100, hundredSeries  # pass it down to the next series  
           				li $t1, 99 # ASCII 99 corresponds c and is loaded into $t1
            				beq $t2, $t1, conversionToHundredHandler # advance to the conversion for 100 in arabic
            			# If the character is passed down to the hundred series, there are no futher
            			# possible ASCII candidates - and thus resides here. 
           			hundredSeries:
           				li $s6, 100 # ASCII 100 corresponds d and is loaded into $t1
            				beq $t2, $t1, conversionToFiveHundredHandler # advance to the conversion for 500 in arabic
            				li $t1, 105 # ASCII 105 corresponds i and is loaded into $t1
            				beq $t2, $t1, conversionToOneHandler # advance to the conversion for 1000 in arabic
            				li $t1, 108 # ASCII 108 corresponds l and is loaded into $t1
            				beq $t2, $t1, conversionToFiftyHandler # advance to the conversion for 1 in arabic
            				li $t1, 109 # ASCII 109 corresponds m and is loaded into $t1
            				beq $t2, $t1, conversionToThousandHandler # advance to the conversion for 50 in arabic
            				li $t1, 118 # ASCII 118 corresponds v and is loaded into $t1
            				beq $t2, $t1, conversionToFiveHandler # advance to the conversion for 5 in arabic
            				li $t1, 120 # ASCII 120 corresponds x and is loaded into $t1
           				beq $t2, $t1, conversionToTenHandler # advance to the conversion for 10 in arabic
			#if you're here, it means you didn't branch earlier
            		add $t5, $0, $0   # initialize comparison register
            		j next # not valid Roman numeral; skip to next loop
			
			
			conversionToOneHandler:      
				addi $t6, $0, 1      # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToFiveHandler:       
				addi $t6, $0, 5      # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToTenHandler:        
				addi $t6, $0, 10     # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToFiftyHandler:      
				addi $t6, $0, 50     # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToHundredHandler:   
				addi $t6, $0, 100    # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToFiveHundredHandler:    
				addi $t6, $0, 500    # load Arabic value in register
            			j oper                  # jump to addition/subtraction portion
			conversionToThousandHandler:   
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
