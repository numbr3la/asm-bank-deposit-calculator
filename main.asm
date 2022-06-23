# Program File: main.asm
# Author: Arkadiusz Zak
#
# The purpose of the programme:
# Main part of the program. The program asks
# to enter the details of the deposit in the bank and the period
# of capitalisation of funds. It then calculates the amount of money
# that will be on your account after a given time, and
# the amount after each subsequent year.

.text
main:
	
	jal podajDane
	jal oblicz
	jal wyswietl


	end:
	li $v0 , 10	
	syscall
	
	
	
# ----------- FUNCTIONS ------------
	
# oblicz() 
# Arguments to the function: 
# $f2 - interest rate per year.
# $f3 - number of capitalisations per year
# $s0, $f4 - number of years saved
#
# The function that calculates the compound percentage from the formula:
# ( 1 + p/(100*k)^(k*n)
# and storing the result from successive years on a stack
oblicz:
	# loading 4 arguments from the stack
	lwc1 $f4, 12($sp)
	lwc1 $f3, 8($sp)
	lwc1 $f2, 4($sp)
	lwc1 $f1, ($sp)
	
	move $s6, $sp
	move $sp, $s7


	# calculates x = ( 1 + p/(100*k) )
	lwc1 $f5, const100 
	div.s $f0, $f2, $f3 # p/k
	div.s $f0, $f0, $f5 # p/100
	
	lwc1 $f5, const1
	add.s $f0, $f0, $f5 # +1
	mov.s $f5, $f0	# f5 = ( 1 + p/(100*k) )
	
	
	# Loop calculating x^k
	# count in loop on 1
	lwc1 $f6, const1
	lwc1 $f7, const1
	
loop1:	c.le.s $f3, $f7	# if($f3 <= $f7)
	bc1t loop1_end # goto loop1_end
	
	mul.s $f0, $f0, $f5	# x^k
	add.s $f7, $f7, $f6	# increase of counter by 1
	j loop1
loop1_end:


	mov.s $f5, $f0 # the result of the amplification of x^k in $f5
	# Stack memory reservation
	move $s1, $s0 # w $s1 liczba lat
	sub $s1, $zero, $s1 # calculation of a negative value
	mul $s1, $s1, 4	# memory needed = number of years x 4
	add $sp, $sp, $s1 # memory reservation
	
	
	
	
	# Loop calculating x^n 
	li $t1, 1 #loop counter at 1
	
loop2:	bge $t1, $s0, loop2_end
	
	# Write x^(n*k) value into memory
	mul $t0, $t1, 4	 # calculation of current indicator, iteration*4
	add $t0, $t0, $sp 
	swc1 $f0, ($t0)	# storing in memory
	
	mul.s $f0, $f0, $f5	#  x^n
	
	addi $t1, $t1, 1 # increase counter by 1
	j loop2
loop2_end: 

	# Resetting the temporary registers
	lwc1 $f5, const0
	lwc1 $f6, const0
	lwc1 $f7, const0
	move $t0, $zero
	
	

	
	move $s7, $sp
	move $sp, $s6
	
	jr $ra
	

# ----------- DATA SECTION ------------ 
.data
const100: .float 100.0
const1: .float 1
const0: .float 0
.include "stream.asm"
