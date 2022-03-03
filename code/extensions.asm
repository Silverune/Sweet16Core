#importonce

// a = Math.pow(b, c); -> c = Math.log(a)/Math.log(b)
.function Log2(value) {
    // .print "Log2: " + toHexString(value) + " -> " + toHexString(log(value) / log(2))
    .return log(value) / log(2)
}

// Jump SubRoutine Indirect - performs the equivalent of a JSR (address) which is not supported by 6502.
// Only JMP can be indirectly addressed routine performs two main tricks to achieve this
// - Place the return address - 1 onto the stack so the called routine's RTS will come back 
//   to this routine even though we have to jump (not JSR) to the subroutine.
// - State is able to be preserved by storing the processor flags (and A) on entry to a ZP
//   location so the stack can be manipulated for the RTS but then restored in full for
//   the jump to the indirect address using an interrupt return RTI.   Even though this is
//   not an interrupt the processor flags are restored from the stack
// Processor register values / flags are preserved, optionally A register can be not restored
// if unused
.pseudocommand jsri src : zw : ignoreA {

	.var zwStore = zw       // if no ZP variable specified use a default
    .if (zw.getType() == AT_NONE) 
        .eval zwStore = Zw.One

	php						// store flags on stack
    .if (ignoreA.getType() != AT_NONE) 
	    sta zwStore+1		// store A
	pla						// 
	sta zwStore    		    // store flags

    lda #>(ret-1)			// load up return address (-1) so remote 'rts' will return to 'ret'
    pha     
    lda #<(ret-1)           
    pha

    // AT_ABSOLUTE	$1000
    .if (src.getType() == AT_ABSOLUTE) {
        lda src.getValue() + 1  // load indirect jump address from specified location (MSB)
        pha
        lda src.getValue()      // LSB
        pha
    } 
    // else .if (src.getType() == AT_ABSOLUTEY) {
    //     lda src.getValue() + 1
    //     clc
    //     adc Y  // load indirect jump address from specified location (MSB)
    //     pha
    //     lda src.getValue() + Y      // LSB
    //     pha
    // }
    // AT_ABSOLUTEX	$1000,x
    // AT_ABSOLUTEY	$1000,y
    // AT_IMMEDIATE	#10
    // AT_INDIRECT	($1000)
    // AT_IZEROPAGEX	($10,x)
    // AT_IZEROPAGEY	($10),y


	lda zwStore         // put original flags on the stack
	pha	
    .if (ignoreA.getType() != AT_NONE) 
    	lda zwStore+1		// restore A to entry state as well - flags change but ignored by RTI

	rti						// jumps to the subroutine

ret:
}