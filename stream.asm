# Program File: stream.asm
# Author: Arkadiusz Zak

# Purpose of the program:
# The program includes additional functions to handle
# the input and output of the program

.text

# podajDane() 
# The function asks for the next necessary data
# To calculate the amount on a bank deposit after a given time
# Writes to:
# $f1 - initial capital
# $f2 - annualised interest rate
# $f3 - number of capitalisations per year
# $s0, $f4 - number of years saved
podajDane:


	add $sp, $sp, -16 # stack memory reservation for 4 items
	move $s7, $sp

	# display string podajM
	li $v0 , 52
	la $a0 , podajM
	syscall
	swc1 $f0, ($sp)	# storing in memory
	
	# display string podajP
	li $v0 , 52
	la $a0 , podajP
	syscall
	swc1 $f0, 4($sp)	# storing in memory
	
	# display string podajK
	li $v0 , 52
	la $a0 , podajK
	syscall
	swc1 $f0, 8($sp)	# storing in memory


	# display string podajN
	li $v0 , 51
	la $a0 , podajN
	syscall
	move $s0, $a0
	
	#int to float
	#=======
	mtc1 $v0, $f0
	cvt.s.w $f0, $f0
	swc1 $f0, 12($sp)	# storing in memory
	
	
	jr $ra

	
# wyswietl()
# Arguments of the function: 
# $f0 - final percentage
# $f1 - initial capital
# $s0 - number of years saved
# $sp - pointer to stack with written data
#
# The function displays the final amount on the stack
# after a given time, then reads from the stack the deposit values from previous years
# and displays them.
wyswietl:
	
	move $s6, $sp
	move $sp, $s7
	

	# display result
	li $v0 , 4
	la $a0 , wynik1a
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, wynik1b
	syscall
	li $v0, 2
	mov.s $f12, $f0
	mul.s $f12, $f12, $f1 # percentage * initial capital
	syscall
	
	# display dialog box
	la $a0, wynik1
	li $v0, 57
	syscall
	
	
	# Enumeration loop, displaying
	# 
	move $t1, $s0 #loop count = number of years - 1
	addi $t1, $t1, -1
	
loop3:	ble $t1, $zero, loop3_end
	# display string
	li $v0 , 4
	la $a0 , wynik2a
	syscall
	
	# Displaying the number of years
	li $v0 , 1
	move $a0, $t1
	syscall
	
	# display string
	li $v0 , 4
	la $a0 , wynik2b
	syscall
	
	# Taking a percentage from the stack
	mul $t0, $t1, 4	 # calculation of current indicator, iteration*4 - 4
	add $t0, $t0, $sp
	lwc1 $f12, ($t0)
	# Display amount
	li $v0, 2
	mul.s $f12, $f12, $f1 # percentage * initial capital
	syscall

	addi $t1, $t1, -1
	j loop3

loop3_end:
	# Release of memory
	move $s7, $sp
	move $sp, $s6
	
	move $s1, $s0 # in $s1 number of years
	mul $s1, $s1, 4	# memory needed = number of years x 4
	add $sp, $sp, $s1 # release of memory
	
	jr $ra
	
	
		
# ----------- DATA SECTION ------------ 
.data
podajM: .asciiz "Enter initial capital: " 
podajP: .asciiz "Enter annualised interest rate: "
podajK: .asciiz "Enter the number of capitalisations per year: "
podajN: .asciiz "Enter the total number of years saved: "
newline: .asciiz "-----------------------------------------------\n"
wynik1: .asciiz "After the specified number of years the account will contain "
wynik1a: .asciiz "On deposit after "
wynik1b: .asciiz  " years will be on the deposit "
wynik2a: .asciiz "\nAfter "
wynik2b: .asciiz " years: "

