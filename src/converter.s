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
           		li $s3, 0 # the index of the input length loop - used to find the length of the input string 
			
			# Get the length of the input string by looping 
			# through each character until we reach the end of 
			# the input string. 
			getInputLength:
				addu $s1, $s0, $s3 # get the input string at character i
            			lbu $a0, 0($s1) # load the character as a byte, per MIPS documentation
            			bne $a0, $0, increment # the null character is defined as 0 - per ASCII documentation; if the character is 0, the end of the string has been reached
            			j traverseInputString # the end has been reach, continue on
			
			# Increment the index counter by 1,
			# and keep looping through the string
			increment:
				addi $s3, $s3, 1 # increment the index
				j getInputLength # go back to the loop

           		# Once the length of the entered user string is computed,
           		# we will work at character n, then n-1, decrementing until character 0. From the previous
           		# subroutines, $s3 will hold the string length, and the $s0 will contain the 
           		# string itself. If the next character is 0, this signifies user termination, and thus the program will enter 
           		# its exit routine and will terminate. 
			traverseInputString:  
            			addu $s1, $s0, $s3 # add the length of the string into $s1
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
				add $s2, $0, $0 # the $s3 register is initalized - it will be used later 
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
           				li $t1, 100 # ASCII 100 corresponds d and is loaded into $t1
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
            		addi $s4, $0, 0   # initialize comparison register
            		jal continue # not valid Roman numeral; skip to next loop
            		j traverseInputString
			
		
			# Handles the conversion for the corresponding character. Since the mapCharacters function will dispatch 
			# what handler to jump to, the conversion handler will simply add into the $t6 register the corresponding value
			# in arabic. Once the value is added to the regster, it is jumped to another subroutine. Since this handler will
			# be entered when the branch condition is satisfied, there is no need to perform a jal - since the map will 
			# jump to the appropriate handler. 
			conversionHandler:
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 1000
				conversionToThousandHandler:   
					addi $s2, $0, 1000 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString                  # jump to addition/subtraction portion
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 500
				conversionToFiveHundredHandler:    
					addi $s2, $0, 500 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString              # jump to addition/subtraction portion
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 100
				conversionToHundredHandler:   
					addi $s2, $0, 100 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString                # jump to addition/subtraction portion
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 50
				conversionToFiftyHandler:      
					addi $s2, $0, 50 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString                 # jump to addition/subtraction portion
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 10
				conversionToTenHandler:        
					addi $s2, $0, 10 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString           # jump to addition/subtraction portion
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 5
				conversionToFiveHandler:       
					addi $s2, $0, 5 # load the corresponding value 
					jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString
				# When the branch is jumped to this memory location, the 
				# corresponding Arabic character is 1	
				conversionToOneHandler:      
					addi $s2, $0, 1 # load the corresponding value 
            				jal prefixHandler # not valid Roman numeral; skip to next loop
            				j traverseInputString


		# The final handler will take the values in the $s2 and $s4 register and will determine 
		# whether or not to subtract or add the next character. If the next character is larger than
		# the previous character, it is subtracted from the original. If it is larger, it is added.
		# When the proper prefix calculation is complete, the program jumps to the continue function,
		# which will move the current value into the $s4 register so that this handler may operate again 
		# on the n-1th character.
		prefixHandler:
			# Check for addition
			performAddition:       
            			blt $s2, $s4, performSubtraction # The case where the next string is larger than the previous will cause a branch
            			add $s7, $s7, $s2 # The next string is larger, perform addition 
            			j continue # jump to the continue function
			# Check for subtraction
			performSubtraction:   
				sub $s7, $s7, $s2 # The next string is smaller, perform subtraction 
				
				j continue # jump to the continue function
		# Finally, the continur function simply dictates the control flow of the loop. If the null character
		# is reached, (i.e. 0), then the final value is printed and the program will accept new user 
		# input until 0 is enetered. Should there be remaining characters, the index of the character 
		# loop is decremented - since the loop begins at character n - the current valu of the digit stored 
		# in $s2 is moved to $s4 to be reused, and the register jumps to the previously stored PC value in 
		# the $ra register. 
		continue:
			beq $s3, $0, print # the null character is defined as 0 - when we reach it, we exit
            		addi $s3, $s3, -1 # decrement the index of the character loop - used to find the length of the input string 
            		move $s4, $s2 # save the current value in a persistent register
            		jr $ra # return to where we came from
            	
		# Prints the converted Arabic numeral. Per the MIPS documenttion, $a0 will conatin the 
		# address of null-terminated string to print (i.e. asciiz). Here, since the converted 
		# Arabic number is stored in the $s7 register, it must first be moved to $a0. Then, make a request 
           	# to the OS kernel with  a syscall by placing the value 1 in the $v0 register to read 
            	# the string. Finally, since the print funciton can only be reached if the user entered a non-terminating 
            	# character, in this case 0, it will jump back to main
		print:     
            		move $a0, $s7 # the calculated conversion must be placed in the $a0 register to issue a syscal
            		li $v0, 1 # print string
           		syscall # make a syscall to the kernel 
            		j main # loop again until the user dictates otherwise

		# When this labeled is reached, the user has entered a terminating character - in this case, 0.
		# The $a0 register will conatin the address of 
           	# null-terminated string to print - in this case a simple goodbye message to signify that the process has
           	# indeed ceased. Then, make a request 
           	# to the OS kernel with  a syscall by placing the value 4 in the $v0 register to read 
            	# the string. Finally, another request 
           	# to the OS kernel is made with a syscall by placing the value 10 in the $v0 register to terminate 
           	# the running program.
		exit:      
			li $v0, 4 # print goodbye - to signify exit
            		la $a0, exitPrompt # the text for stopped
            		syscall # make a syscall to the kernel
            		li $v0, 10 # terminate the program
            		syscall # make a syscall to the kernel 
