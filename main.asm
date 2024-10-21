# Program #8: Number Base Converter
# Author: Lazlo F. Steele
# Due Date : Oct. 26, 2024 Course: CSC2025-2H1
# Created: Oct. 20, 2024
# Last Modified: Oct. 20, 2024
# Functional Description: Given a 32-bit numeric value provided by the user, convert from base 2/10/16 to base 2/10/16.
# Language/Architecture: MIPS 32 Assembly
####################################################################################################
# Algorithmic Description:
#	
####################################################################################################

.include 	"macros.asm"
.include	"messages.asm"

.data
	mode_flag:	.byte	0		# 0 - off, 1 - integer, 2 - binary, 3 - hex
				.align	2
	buffer:		.space	32

.globl	main

.text
####################################################################################################
# function: main
# purpose: to control program flow
# registers used:
#	$a0 - passing arugments to subroutines
####################################################################################################
main:
	call(welcome)
	call(get_mode)
	call(get_number)
	
	j again_loop
	
welcome:
	print_str(welcome_msg)
	jr $ra
	
get_mode:
	print_str(mode_msg)
	print_str(mode_prmpt)
	
	mode_input:
		read_str(buffer, 1)
	
	la	$t0, buffer
	lw	$t1, 0($t0)
	blt $t1, 49, invalid_mode
	bgt $t1, 51, invalid_mode
	
	addi $t1, $t1, -48
	
	la	$t2, mode_flag
	sb	$t1, 0($t2)

	jr $ra
	
	invalid_mode:
		print_str(invalid_msg)
		j get_mode

get_number:
	lb $t0, mode_flag
	
	beq $t0, 1, get_decimal
	beq $t0, 2, get_binary
	beq $t0, 3, get_hex

	get_decimal:
		print_str(decimal_msg)
		read_str(buffer, 10)
		jr $ra
	get_binary:
		print_str(binary_msg)
		read_str(buffer, 32)
		jr $ra
	get_hex:
		print_str(hex_msg)
		read_str(buffer, 8)
		jr $ra
		
again_loop:
	again
	j again_loop
