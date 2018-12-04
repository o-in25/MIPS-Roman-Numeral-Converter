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
	
	# Request the user for a roman numeral.
	req: .asciiz "Roman Numeral: "
	# The error message that will be displayed if the 
	# format is invalid or contains a token that is not
	# a valid roman/decimal numeral.
	err: .asciiz "Input contains invalid tokens or format"
.text 
	.globl main
			main:
				jal conversion
			conversion:
			
	