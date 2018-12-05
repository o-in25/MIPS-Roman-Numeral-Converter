.data 
	romanNumerals: .asciiz "ICXLCDM"
	prompt: .asciiz "Enter a Roman numeral: "
	message: .asciiz "Arabic Equivalent: "
	input: .space 64
.text
	.globl main
		main:
			printPrompt:
				# makes a syscall to print the prompt  
				la $a0, prompt
				li $v0, 4
				syscall
			
			readString:
				# makes a syscall to read a string
				# $a0 is the address of input buffer 
				# $a1 is the maximum number of characters to read		
				la $a0, input 
				la $a1, 64
				li $v0, 8
				syscall
			# save the value of the input 
			# in the $s0 register for use
			move $s0, $a0
			# initialize the index
			li $t0, 0
		forEachCharInString:
			# store the starting address for the input in $s0,
			# and an offset of the address at $t0. which is incremented 
			# by 1 - making $s1 the stored address offset
			add $s1, $s0, $t0
			# load into $a0 that address offset
			lb $a0, 0($s1)
			# when the offset is equal to 0, that mmwans the 
			# end of the string has been reached
			beq $a0, $0, convert
			# else increment the address offset, serving as 
			# the index in this case, so it can point to the 
			# next character in the string and continue 
			addi $t0, $t0, 1
			# go again 
			j forEachCharInString
		
		convert:
			
			
				
	  		
	  				
	
			
		
		
