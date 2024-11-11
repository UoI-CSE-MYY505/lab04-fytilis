
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
            lbu  t0, 0(a0)
            lbu  t1, 0(a1)
            sub  t2, t0,   t1  
            addi a0, a0,   1
            addi a1, a1,   1
            add  t3, t1,   t0 
            beq  t3, t0,   ret_strcmp  
           
            beq  t2, zero, str_ge  #still equal, loop
ret_strcmp:
            srli a0, t2, 31  
            xori a0, a0, 1
            jr   ra
 
recCheck:
            slti t0, a1,   2
            beq  t0, zero, checkFirstTwo
            addi a0, zero, 1 
            jr   ra
checkFirstTwo:
            addi sp, sp,   -12
            sw   ra, 8(sp)
            sw   a0, 4(sp)
            sw   a1, 0(sp)
            lw   a1, 0(a0)  # 1st
            lw   a0, 4(a0)  # 2nd 
            jal  str_ge
            beq  a0, zero, return  # return 0, a0 is already 0
            # do recursion
            lw   a0, 4(sp)    
            lw   a1, 0(sp)
            addi a0, a0,   4   
            addi a1, a1,   -1  
            jal  recCheck
return:
            lw   ra, 8(sp)
            addi sp, sp,   12
            jr   ra
