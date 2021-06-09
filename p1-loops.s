#   %s0 -> a
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
