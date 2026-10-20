/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Ness Dahan"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global packed_Value,a_Multiplicand,b_Multiplier,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,abs_Product,final_Product
.type packed_Value,%gnu_unique_object
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type abs_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
packed_Value:    .word     0  
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
abs_Product:     .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: See Lab Instructions
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* the variables only get set once when the program loads, so every call
     * has to clear them or test case results would bleed into the next one */
    MOV r2, 0 /* r2 holds zero because STR can only store a register */
    LDR r3, =packed_Value /* r3 = address of packed_Value */
    STR r2, [r3] /* clear it, the real value gets saved a few lines down */
    LDR r3, =a_Multiplicand
    STR r2, [r3]
    LDR r3, =b_Multiplier
    STR r2, [r3]
    LDR r3, =a_Sign
    STR r2, [r3]
    LDR r3, =b_Sign
    STR r2, [r3]
    LDR r3, =prod_Is_Neg
    STR r2, [r3]
    LDR r3, =a_Abs
    STR r2, [r3]
    LDR r3, =b_Abs
    STR r2, [r3]
    LDR r3, =abs_Product
    STR r2, [r3]
    LDR r3, =final_Product
    STR r2, [r3]

    /* task 2: unpack A and B from the one 32 bit value in r0 */
    LDR r3, =packed_Value
    STR r0, [r3] /* save the raw input first, r0 gets reused later for the multiply */

    /* A is in the top 16 bits. asr slides it down to the bottom and copies the
     * sign bit into the top 16 bits as it goes, so the sign extension is free */
    MOV r4, r0 /* r4 = working copy so r0 stays untouched for B */
    ASR r4, r4, 16 /* r4 = A as a full 32 bit signed number */

    /* B is in the bottom 16 bits, so asr alone can't reach it. lsl first pushes B
     * up to the top where its sign bit lands in bit 31, then asr brings it back
     * down and fills the top half with that sign bit */
    MOV r5, r0 /* r5 = working copy for B */
    LSL r5, r5, 16 /* throw away A, B is now in the top 16 bits */
    ASR r5, r5, 16 /* r5 = B as a full 32 bit signed number */

    LDR r3, =a_Multiplicand
    STR r4, [r3] /* store unpacked A */
    LDR r3, =b_Multiplier
    STR r5, [r3] /* store unpacked B */

    /* the sign of a two's complement number is just bit 31, so a logical shift
     * right by 31 gives 1 for negative and 0 for positive or zero. no compare needed */
    LSR r6, r4, 31 /* r6 = sign of A */
    LSR r7, r5, 31 /* r7 = sign of B */
    LDR r3, =a_Sign
    STR r6, [r3]
    LDR r3, =b_Sign
    STR r7, [r3]

    /* absolute value of A. start with A itself and only negate it if it was below 0 */
    MOV r8, r4 /* r8 = A, already right if it's positive or zero */
    CMP r4, 0 /* flags from A vs 0 */
    BGE a_is_done /* signed compare, A is 0 or more so keep it as is */
    RSB r8, r4, 0 /* reverse subtract, 0 minus A, flips a negative into a positive */
a_is_done:
    LDR r3, =a_Abs
    STR r8, [r3]

    /* same thing for B */
    MOV r9, r5 /* r9 = B */
    CMP r5, 0
    BGE b_is_done
    RSB r9, r5, 0 /* 0 minus B */
b_is_done:
    LDR r3, =b_Abs
    STR r9, [r3]

    /* the product is negative when the signs are different, so xor of the two
     * sign bits works. but zero times anything is zero, which is never negative,
     * and a zero has a sign of 0 so xor alone would call -4 * 0 negative */
    EOR r10, r6, r7 /* r10 = 1 only if exactly one of them was negative */
    CMP r8, 0 /* is A zero? */
    BEQ prod_is_zero
    CMP r9, 0 /* is B zero? */
    BNE store_prod_sign
prod_is_zero:
    MOV r10, 0 /* a zero product doesn't get a negative sign */
store_prod_sign:
    LDR r3, =prod_Is_Neg
    STR r10, [r3]

    /* task 3: shift and add on the absolute values, r0 is the multiplicand
     * and r1 is the multiplier like the lab wants. pulling them back out of
     * memory because r0 and r1 got used for other stuff above */
    LDR r0, =a_Abs
    LDR r0, [r0] /* r0 = multiplicand */
    LDR r1, =b_Abs
    LDR r1, [r1] /* r1 = multiplier */
    MOV r2, 0 /* r2 = running product, starts empty */
mult_loop:
    LSRS r1, r1, 1 /* shift the multiplier right, the bit that falls off goes into carry */
    BCC no_add /* carry clear means that multiplier bit was 0, so skip the add */
    ADD r2, r2, r0 /* bit was 1, add the multiplicand at its current place value */
no_add:
    LSL r0, r0, 1 /* multiplicand doubles so it lines up with the next bit */
    CMP r1, 0 /* any multiplier bits left? */
    BNE mult_loop /* if so, keep going. if not, we already added everything */

    LDR r3, =abs_Product
    STR r2, [r3] /* this is always positive since both inputs were */

    /* now put the sign back using what prod_Is_Neg says */
    LDR r3, =prod_Is_Neg
    LDR r3, [r3] /* read it back from memory instead of reusing r10 */
    MOV r4, r2 /* r4 = final answer, positive unless we change it below */
    CMP r3, 0
    BEQ store_final /* not negative, leave it */
    RSB r4, r2, 0 /* 0 minus the product, turns it negative */
store_final:
    LDR r3, =final_Product
    STR r4, [r3]
    MOV r0, r4 /* the C code reads the answer out of r0 */
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




