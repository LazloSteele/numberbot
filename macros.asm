####################################################################################################
# macro: print_str
# purpose: to make printing messages more eloquent
# registers used:
#	$v0 - syscall codes
#	$a0 - message storage for print
# variables used:
#	%x - message to be printed
####################################################################################################		
.macro print_str (%message)		#
	li $v0 4					# prepare to print string
	la $a0, %message			# load the message argument
	syscall						# print!
.end_macro						#
####################################################################################################
# macro: read_str
# purpose: to make printing messages more eloquent
# registers used:
#	$v0 - syscall codes
#	$a0 - message storage for print
# variables used:
#	%x - message to be printed
####################################################################################################		
.macro read_str (%buffer_address, %buffer_size)		#
	reset_buffer (%buffer_address, %buffer_size)	# clear the buffer
	li $v0, 8										# prepare to read string
	la $a0, %buffer_address							# load the buffer address
	li $a1, %buffer_size							# load the number of characters (+1 for line termination)
	syscall											# read that string!
.end_macro											#
####################################################################################################
# macro: upper
# purpose: to make printing messages more eloquent
# registers used:
#	$t0 - string to check for upper case
#	$t1 - ascii 'a', 'A'-'Z' is all lower value than 'a'
# variables used:
#	%message - message to be printed
####################################################################################################		
.macro upper (%buffer)			#
	la $t0, %buffer				# load the buffer address
	li $t1, 'a'					# lower case a to compare
	upper_loop:					#
		lb $t2, 0($t0)			# load next byte from buffer
		blt $t2, $t1, is_upper	# bypass uppercaserizer if character is already upper case (or invalid)
		to_upper:				# 
			subi $t2, $t2, 32	# Convert to uppercase (ASCII difference between 'a' and 'A' is 32)
		is_upper:				#
			sb $t2, 0($t0)		# store byte
		addi $t0, $t0, 1		# next byte
		bne $t2, 0, upper_loop	# if not end of buffer go again!
.end_macro						#
####################################################################################################
# function: again
# purpose: to user to repeat or close the program
# registers used:
#	$v0 - syscall codes
#	$a0 - message storage for print and buffer storage
#	$t0 - stores the memory address of the buffer and first character of the input received
#	$t1 - ascii 'a', 'Y', and 'N'
####################################################################################################
.macro again					#
	print_str (repeat_msg) 		# load address of result_msg_m1 into $a0
	read_str (buffer, 4)		# load the address of the buffer
	upper (buffer)				# load the buffer for string manipulation
								#
	la $t0, buffer				#
	lb $t0, 0($t0)				#
	li $t1, 'Y'					# store the value of ASCII 'Y' for comparison
	beq $t0, $t1, main			# If yes, go back to the start of main
	li $t1, 'N'					# store the value of ASCII 'N' for comparison
	beq $t0, $t1, end_program	# If no, goodbye!
	j invalid					# if invalid try again...
								#
	end_program:				#
		end						#
								#
	invalid:					#
		print_str (invalid_msg)	#
.end_macro						#
####################################################################################################
# function: reset_buffer
# purpose: to reset the buffer for stability and security
# registers used:
#	$t0 - buffer address
#	$t1 - buffer length
#	$t2 - reset value (0)
#	$t3 - iterator
####################################################################################################	
.macro reset_buffer (%buffer, %buffer_length)	#
	la $t0, %buffer								# buffer to $t0
	li $t1, %buffer_length						# buffer_size to $t1
	li $t2, 0									# to reset values in buffer
	li $t3, 0									# initialize iterator
	reset_buffer_loop:							#
		bge $t3, $t1, reset_buffer_return		#
		sw $t2, 0($t0)							# store a 0
		addi $t0, $t0, 4						# next word in buffer
		addi $t3, $t3, 1						# iterate it!
		j reset_buffer_loop 					# and loop!
	reset_buffer_return:						#
.end_macro
####################################################################################################
# function: end
# purpose: to eloquently terminate the program
# registers used:
#	$v0 - syscall codes
####################################################################################################	
.macro end 					#
	print_str (bye)	 		# load address of bye into $a0
	li 		$v0, 10			# system call code for returning control to system
	syscall					# GOODBYE!
.end_macro					#
####################################################################################################
.macro call (%function)
							# Save registers (prologue)
	addi	$sp, $sp, -20	# Make space on stack for $ra and $a0
	sw		$ra, 0($sp)		# Save return address
	sw		$a0, 4($sp)		# Save argument (if any)
	sw		$a1, 8($sp)		# Save argument (if any)
	sw		$a2, 12($sp)	# Save argument (if any)
	sw		$a3, 16($sp)	# Save argument (if any)
    						#
    jal %function			# Call the function!
    						#
							# Restore registers (epilogue)
    lw		$a3, 16($sp)	# Restore argument (if any)
    lw		$a2, 12($sp)	# Restore argument (if any)
    lw		$a1, 8($sp)		# Restore argument (if any)
    lw		$a0, 4($sp)		# Restore argument (if any)
    lw		$ra, 0($sp)		# Restore return address
    addi	$sp, $sp, 20	# Adjust stack pointer
.end_macro