    /*
     * Compare two floating-point values.  Puts 0, 1, or -1 into the
     * destination register based on the results of the comparison.
     *
     * int compare(x, y) {
     *     if (x == y) {
     *         return 0;
     *     } else if (x < y) {
     *         return -1;
     *     } else if (x > y) {
     *         return 1;
     *     } else {
     *         return 1;
     *     }
     * }
     */
    /* op vAA, vBB, vCC */
    FETCH r0, 1                         @ r0<- CCBB
    mov     r9, rINST, lsr #8           @ r9<- AA
    and     r2, r0, #255                @ r2<- BB
    mov     r3, r0, lsr #8              @ r3<- CC
    VREG_INDEX_TO_ADDR r2, r2           @ r2<- &vBB
    VREG_INDEX_TO_ADDR r3, r3           @ r3<- &vCC
    fldd    d0, [r2]                    @ d0<- vBB
    fldd    d1, [r3]                    @ d1<- vCC
    vcmpe.f64 d0, d1                    @ compare (vBB, vCC)
    FETCH_ADVANCE_INST 2                @ advance rPC, load rINST
    mov     r0, #1                      @ r0<- 1 (default)
    GET_INST_OPCODE ip                  @ extract opcode from rINST
    fmstat                              @ export status flags
    mvnmi   r0, #0                      @ (less than) r1<- -1
    moveq   r0, #0                      @ (equal) r1<- 0
    SET_VREG r0, r9                     @ vAA<- r0
    GOTO_OPCODE ip                      @ jump to next instruction
