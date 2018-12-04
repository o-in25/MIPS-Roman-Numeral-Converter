.data 
	# This data will serve as our map between the roman
	# and the decimal numbers. Here, each list will 
	# serve as our makeshift "array", where the conversion
	# from decimal to roman will be according to each indice,
	# i.e. decimalNumeral[i] will dictate romanNumeral[i].
	# This also will be useful when converting roman to 
	# decimal, as romanNumeral[i] will dictate decimalNumeral[i]
	decimalNumeral: .word 1000 100 50 10 5 1 # the decimal map
	romanNumeral: .asciiz "MDCLXVI" # the roman map
	buffer: .word 4
	
	# Request the user for a roman numeral.
	req: .asciiz "Roman Numeral: "
	# The error message that will be displayed if the 
	# format is invalid or contains a token that is not
	# a valid roman/decimal numeral.
	err: .asciiz "Input contains invalid tokens or format"
.text 
	.globl main
			main:
				getRequest:
					# Per MIPS documentation, $a0 is 
					# the address of null-terminated string to print - 
					# in this case, it is our request prompt to the user.
					li $v0, 4
					# Load the request.
					la $a0, req
					# Issue the syscall - the request to the kernel.
					syscall
				loadRequest:
					# Per the MIPS documentation,
					# $a0 is the address of an input buffer and
					# $a1 is the maximum number of characters to read. 
					la $a0, buffer
					# Set the maximum number of characters to be 32 bits
					# i.e. one word
					li $a1, 32
					li $v0, 8 # Read str from user
					# Issue the syscall - the request to the kernel.
					syscall
				
				jal conversion
			conversion:
				# Then load the address of the buffer for the user input,
				# the array for the roman numeral, and array 
				# for the decimal numeral.
				la $t0, buffer
				# the roman numeral array
				la $t1, romanNumeral
				# The decimal numeral array. 
				la $t2, decimalNumeral
				
				 
			
	
