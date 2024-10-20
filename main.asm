# Program #8: Number Base Converter
# Author: Lazlo F. Steele
# Due Date : Oct. 19, 2024 Course: CSC2025-2H1
# Created: Oct. 14, 2024
# Last Modified: Oct. 14, 2024
# Functional Description: Given a 32-bit numeric value provided by the user, convert from base 2/10/16 to base 2/10/16.
# Language/Architecture: MIPS 32 Assembly
####################################################################################################
# Algorithmic Description:
#	
####################################################################################################

.include 	"macros.asm"
.include	"messages.asm"

.data
			.align	2
	buffer:	.space	32

.globl	main

.text
main:
	call (welcome)
	call (prompt)
	
	j again_loop
	
welcome:
	print_str (welcome_msg)
	jr $ra
prompt:
	print_str (mode_msg)
	print_str (mode_prmpt)
	
	read_str(buffer, 32)
	
	jr $ra

again_loop:
	again
	j again_loop
