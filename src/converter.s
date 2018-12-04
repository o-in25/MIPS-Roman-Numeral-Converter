.data
	# Lookup tables
	roman: .asciiz "MDCLXVI"
	values: .byte  1000, 500, 100, 50, 10, 5, 1

	# Input
	input1: .word 4
	input2: .asciiz "\n "   
	input3: .asciiz "\n "   
	input4: .asciiz "\n"

	# Conversion
	left: .word 0
	sum: .word 0

	# I/O and program control
	convertAgain: .word 2
	prompt1: .asciiz "\nPlease enter the Roman Number: "
	outRecap: .asciiz "\n Entered Roman Number: "
	outFinal: .asciiz "\n Equivalent decimal value is: "
	loopdriver: .asciiz "\nWould you like to convert another number??? Enter 1 for YES and 2 for NO: "
	stop: .asciiz "\n\nProgram complete.\n"

	# Exception handling
	error1: .asciiz "\nThe Roman number you have entered contains invalid character(s). Please try again.\n"
.text

	.globl main
	main:
		jal printPrompt
		readInput:
			# Load the word reserved for input, and read in the Roman number str input by the user   
			la $a0, input1 # Load contents of input1 (i.e. space allocated to save the input str) into $a0
			la $a1, input1 # Load the length allocated for input1 (i.e. 4 bytes or 32 bits) into $a1 to prevent overflow
			li $v0, 8 # Read str from user
			syscall
		sw $ra, 0($sp) # Push return adr onto the stack
		addi $sp, $sp, -4 # Move stack pointer   
		# Go to sub-routines for lookup and conversion
		jal init

		lw $ra, 0($sp) # Pop return adr off the stack
		addi $sp, $sp, 4 # Move stack pointer
		# Display results for the user
		display:
			# Load output str 1 to show the user their original input str
			la $a0, outRecap # load contents of outRecap into $a0
			li $v0, 4 # print str
			syscall

		jal printPrompt
		# Display the equivalent decimal value
		la $a0, outFinal # load contents of outFinal (str) into $a0
		li $v0, 4 # print str
		syscall

		# Print the sum
		lw $a0, sum # Load contents of sum into $a0
		li $v0,1 # Print int
		syscall

		# Ask the user whether they want to convert another Roman number (1 if YES; 2 if NO; default is NO)
		la $a0, loopdriver # Load contents of loopdriver (str) into $a0
		li $v0, 4 # Print str
		syscall

		# Get user input from keyboard (1 = they want to convert another Roman number; 2 = Exit; default = 2)
		li $v0, 5 # Read int input
		syscall

		# Save the user's input and jump to "Exit"
		sw $v0, convertAgain
		lw $t0, convertAgain

		bne $t0, 1, Exit # if the user enters a number != 1, go to Exit
	
		move $s0, $zero # Reinitialize
		sw $zero, sum # Reinitialize
		sw $zero, left # Reinitialize

		j main # Go back to start if the user enters 1
	printPrompt:
		la $a0, prompt1 # Load adr
		li $v0, 4 # Print prompt1
		syscall	
		jr $ra








	# Convert Roman number str to int decimal value   
	init:
		#sw $ra, 4($sp)
		sw $a1, 4($sp)
		addi $sp, $sp, -4 # move stack pointer

		la $t2, input1 #Load the adr of the str (see by looking at starting index of each the length of each str
		la $t3, roman # Load the adr of the roman lookup table into $t3
		la $t4, values # Load the adr of the decimal lookup table into $t4

		# Loop through each char of the input str
		loop1:
		lb $a0, ($t2) # This gets the next byte of the str (from L to R); change the offset to get others (i.e. lb $a0, 3($t0) = I
		beq $a0, 10, return # If the ascii char == 0, we have reached the end of the input str; jump to "return"
		beq $a0, 1, return # If the ascii char == 1, we've reached the "start of heading" (i.e. end of line; max = 12 char)

		#li $v0, 11 # print byte to console
		#syscall


		sw $ra, 8($sp) # Push return adr onto the stack
		addi $sp, $sp, -4 # Move stack pointer

		# While str[i] != null:
		jal index

		lw $ra, 8($sp) # Pop return adr off stack
		addi $sp, $sp, 4 # Move stack pointer

		addi $t2, $t2, 1 # Move to next character in input str

		sw $ra, 8($sp) # Push return adr onto the stack
		addi $sp, $sp, -4 # Move stack pointer

		jal loop1 # iterate through loop1 again

		lw $ra, 8($sp) # Pop return adr off the stack
		addi $sp, $sp, 4 # Move stack pointer

		# Find the index (i.e. offset) of the selected char in the "roman" lookup table
	index:
		lb $t5, ($t3) # Load the first byte of romans
		beqz $t5, invalid # If we reach the end of romans && char !found, INVALID char

		beq $a0, $t5, getVal # When char == element in romans table, branch to getVal to look it up in decimal table

		sw $ra, 12($sp) # Push return adr onto the stack
		addi $sp, $sp, -4 # Move stack pointer

		jal iter # If we haven't found a match, jump to where we can increment $t3 and iterate through the loop again

		lw $ra, 12($sp) # Pop return adr off the stack
		addi $sp, $sp, 4 # Move stack pointer


		getVal:
		la $t6, roman # Get the adr of the array containing Roman number characters
		la $t7, values

		sub $t8, $t3, $t6 # Get the index value of the element that matches the byte we are working with [1:7]
		add $t7, $t7, $t8
		lbu $t9, ($t7) # $t9 is the decimal value that corresponds to the letter
		bgeu $t9, 232, adjust1

	j afterGV
	adjust1:

		seq $a2, $t5, 68 # If the character in question == D, set $a2 to 1; else, 0
		mul $t9, $t9, $zero
		beq $a2, 1, adjustD
		addi $t9, $t9, 1000 # Char == M; decimal value = 1000

	j afterGV
		adjustD: addi $t9, $t9, 500
		j afterGV

		afterGV: sw $ra, 16($sp)
		addi $sp, $sp, -4 # move stack pointer


	jal setup

		addi $sp, $sp, 4 # reset the stack pointer
		lw $ra, 16($sp) # Pop return adr off stack
		# lw $t9, 12($sp) # fetch $t9

		jr $ra # go back   

		# This is the last part of the index loop
	iter:   
		addi $t3, $t3, 1 # if we haven't found a match, increment $t3 and iterate through the loop again
		jal index # loop

		# Prepare to compare current char w/previous char (i.e. if str is XI, compare I to X)
		setup:
		# Base case is that the str length == 1, and thus sum = the decimal equivalent of the only Roman number character
		lw $s0, sum # Load sum into $s0
		beqz $s0, base # If sum == 0, this is our first pass through the loop, and we just want to add the first char's decimal value to sum and return to get the next char
		sw $ra, 20($sp) # Push return adr onto stack
		addi $sp, $sp, -4 # Move stack pointer

		jal calcSum # Jump to subroutine that calculates the sum

		addi $sp, $sp, 4 # Reset the stack pointer
		lw $ra, 20($sp) # Pop return adr off stack
		jr $ra # Go back to return adr


		# Base case is our first pass through the loop, where sum == 0.
		# We just want to add the value of the first number in the str to sum, and return to loop1 to get next char.
		base: add $s0, $s0, $t9 # Add value of first char + 0 and store in $s0
		sw $s0, sum # Store contents of $s0 in sum
		sw $t9, left # Store contents of $t9 (i.e. current char) as "left" for use in next iteration

		la $t3, roman # Load adr of roman array into $t3 (reset pointer)
		addi $t2, $t2, 1 # Add 1 to $t2, so that we can select next char in input str

		jal loop1 # Jump back to beginning of loop


	# Compare current char to previous, and calculate sum accordingly, per rules of Roman numbers
	calcSum: addi $sp, $sp, 8 # Reset the stack pointer
		lw $t1, left # Pop the decimal value of the Roman number to the left of the current value in the original str   
		sw $t9, left # Reset left pointer so it points to current char ("left" of *next* char)

		la $t3, roman # Load adr of roman array into $t3 (reset pointer)
		bge $t1, $t9, plus # If value of the previous char >= current char, then add the current char's value to the sum
		blt $t1, $t9, minus # If the previous char in the str is < the current char, add: current - (2*previous) to the sum

	plus: lw $s0, sum # Load sum into $s0
		add $s0, $s0, $t9 # Add current char's decimal value to sum
		sw $s0, sum # Store the result in sum

		la $t3, roman # Load adr of roman array into $t3 (reset pointer)
		addi $t2, $t2, 1 # Add 1 to $t2, so that we can select next char in input str

		jal loop1 # Jump back to beginning of loop

	minus: lw $s0, sum # Load sum into $s0
		mul $t1, $t1, 2 # Multiply $1 by 2 (need to subtract twice, to get a net impact of -1 * $t1)
		sub $t9, $t9, $t1 # Subtract (previous char - (2* current char)) (i.e. if XIV, do 11 + (5-(2*1)) = 14)
		add $s0, $s0, $t9 # Add this result to the existing sum
		sw $s0, sum # Store the result in sum   
		la $t3, roman # Load adr of roman array into $t3 (reset pointer)
		addi $t2, $t2, 1 # Add 1 to $t2, so that we can select next char in input str
		jal loop1 # Jump back to beginning of loop
	# Go back to main   
	return:
		sw $s0, sum # Store sum
		j display # Jump to display to print output for the user

	#Exception handling: User input str contains invalid character(s)
	invalid:
		li $v0, 4 # Print str
		la $a0, error1 # Load adr for error1 (a str)
		syscall
		j main


	#System Exit
	Exit:
		# Display exit message
		li $v0, 4 # Print str
		la $a0, stop # Load adr for stop (a str)
		syscall
		li $v0, 10 # System exit
		syscall