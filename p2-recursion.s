
#  compute and print fib of N
#
#  recursive version
#
        .text
        .globl  main
main:
#
# opening linkage (save return address)
#
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)
#
# prompt
#
        la      $a0, prompt
        li      $v0, 4          # "print string" syscall
        syscall
#
# get input N
#
        li      $v0, 5          # "read int" syscall
        syscall
        addi    $s0, $v0, 0     # save result in $s0
#
# $s0 for N
# $s1 for result
#

#
# echo
#
        la      $a0, echo
        li      $v0, 4          # "print string" syscall
        syscall
        addi    $a0, $s0, 0 
        li      $v0, 1          # "print int" syscall
        syscall
        la      $a0, nl
        li      $v0, 4          # "print string" syscall
        syscall


#
# compute N! (into $s1) and print
#
        add     $a0, $s0, $zero # $a0 <- N
        jal     fib
        add     $s1, $v0, $zero
#
# print result
#
        la      $a0, result
        li      $v0, 4          # "print string" syscall
        syscall
        addi    $a0, $s1, 0     # get result
        li      $v0, 1          # "print int" syscall
        syscall
        la      $a0, nl
        li      $v0, 4          # "print string" syscall
        syscall
#
# closing linkage (get return address and restore stack pointer)
#
end:
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra


fib:
# opening linkage (save return address and registers)
# save all $s registers even if we aren't using them -- "good practice"
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)
        addi    $sp, $sp, -32
        sw      $s0, 0($sp)
        sw      $s1, 4($sp)
        sw      $s2, 8($sp)
        sw      $s3, 12($sp)
        sw      $s4, 16($sp)
        sw      $s5, 20($sp)
        sw      $s6, 24($sp)
        sw      $s7, 28($sp)

# $a0 has n
# $s0 has copy of n
# return value goes in $v0

	addi	$s0, $a0, 0
	addi	$s2, $zero, 1
	

#	addi	$t2, $zero, 2
#	slt	$t1, $s0, $t2
#	bne	$t1, $zero, fib_notbase
#	j	fib_end
	beq	$s0, $zero, givezero
	beq	$s0, $s2, giveone	
	
fib_notbase:
#     tmp1 = fib(n-1) 
	addi	$a0, $s0, -1
	jal	fib
	add	$s1, $v0, $zero
#     tmp2 = fib(n-2)
	addi	$a0, $s0, -2
	jal	fib
	add	$v0, $s1, $v0


# closing linkage 
# "unwind the stack"
# (restore registers, get return address, restore stack pointer)
fib_end:
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 32
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
# return to caller
        jr      $ra
        .end    main


givezero:
	li	$v0, 0
	j	fib_end

giveone:
	li	$v0, 1
	j	fib_end

#
# area for variables and constants
#
        .data
prompt: .asciiz "Enter a non-negative integer:\n"
error:  .asciiz "Error -- negative input\n"
echo:   .asciiz "You entered:\n"
result: .asciiz "Result:\n"
nl:     .asciiz "\n" -> a
#   $s1 -> b
#   $s3 -> &D
#   $s3 -> i
#   $s4 -> j

        .text
        .globl  main
main:
#
# opening linkage (save return address)
#
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)
#
# prompt1
#
        la      $a0, prompt1
        li      $v0, 4          # "print string" syscall
        syscall

# get input
#
        li      $v0, 5          # "read int" syscall
        syscall
        addi    $s0, $v0, 0     # save result in $s0

#prompt2
        la      $a0, prompt2
        li      $v0, 4
        syscall

# get input2
#
        li      $v0, 5          # "read int" syscall
        syscall
        addi    $s1, $v0, 0     # save result in $s0

#part1
        la      $s2, array
        addi    $s3, $zero, 0       # i <- 0
        mul     $s5, $s1, $s2       # $s5 <- a*b
        addi    $s6, $zero, 0       # $k <- 0
loop1:  slt     $t0, $s3, $s0       # $t0 <- (i < a)
        beq     $t0, $zero, end1    # if !(i < a) goto end1
        addi    $s4, $zero, 0       # j <- 0
loop2:  slt     $t0, $s4, $s1       # $t0 <- (j < b)
        beq     $t0, $zero, end2    # if !(j < b) goto end2
        mul     $t0, $s1, $s3       # $t0 <- b*i
        add     $t0, $t0, $s4       # $t0 <- b*i+j
        sll     $t0, $t0, 2         # $t0 <- offset into D of element b*i+j
        add     $t0, $t0, $s2       # $t0 <- &D[b*i+j]
        add     $t1, $s3, $s4       # $t1 <- i+j
        addi    $a0, $t1, 0
        li      $v0, 1
        syscall
	la      $a0, nl
        li      $v0, 4          # "print string" syscall
        syscall
        sw      $t1, 0($t0)         # D[b*i+j] = i+j
#       li     $v0, 1              # new
#       lw      $a0, 0($t1)
#       syscall                     # new ends
        addi    $s4, $s4, 1         # j++
        j       loop2
end2:   addi    $s3, $s3, 1         # i++
        j       loop1
end1:



# closing linkage (get return address and restore stack pointer)
#
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra
        .end    main
#

#
# area for variables and constants
#

        .data
prompt1: .asciiz "Enter a line of text for a:\n"
prompt2: .asciiz "Enter a line of text for b: \n"
array:  .align 2
        .space 400
nl:      .asciiz "\n"
