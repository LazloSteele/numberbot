.data
decimal_size:	.word 0		# pointer, decimal value, binary value, hex value

.globl 	decimal.new
.globl	decimal.set
.globl	decimal.decimal
.globl	decimal.binary
.globl	decimal.hex

.text
decimal.new:
	li		$a0, 16			# 4 words of memory for the 4 fields
	li		$v0, 9			# syscall for allocate memory
	syscall
	move	$s0, $v0		# store the base address of memory

####################################################################################################
# function: set_point
# purpose: to store the 
# registers used:
#	$a0 - passing arugments to subroutines
####################################################################################################
decimal.set:

decimal.decimal:


decimal.binary:
decimal.hex: