.data 
	romanNumerals: .asciiz "ICXLCDM"
	prompt: .asciiz "Enter a Roman numeral: "
	message: .asciiz "Arabic Equivalent: "
.text
	.globl main
		main:
			la $a0, prompt
			li $v0, 4
			syscall
			
	
			
		
		
