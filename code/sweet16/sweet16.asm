#importonce

// SWEET 16 INTERPRETER
// APPLE-II  PSEUDO MACHINE INTERPRETER
// COPYRIGHT (C) 1977 APPLE COMPUTER,  INC ALL  RIGHTS RESERVED S. WOZNIAK
// Additional Code: Copyright (C) 2018-2021 Enable Software Pty Ltd, Inc All Rights Reserved Rhett D. Jacobs

.macro @Sweet16() {

@Sweet16_InitializeSubroutineStack:
    lda #<Sweet16_SUBROUTINE_STACK
    sta Sweet16_RL(Sweet16_RSP)
    lda #>Sweet16_SUBROUTINE_STACK
    sta Sweet16_RH(Sweet16_RSP)
    rts

@Sweet16_Main:
    sta Sweet16_RL(Sweet16_ACC),x
    cpx #$10
	pla
	sta Sweet16_RL(Sweet16_PC)              // INIT SWEET16 PC
	pla                                     // FROM RETURN
	sta Sweet16_RH(Sweet16_PC)	            // ADDRESS

@Sweet16_Next:
	jsr Sweet16_Interpret                   // INTERPRET and EXECUTE
    jmp Sweet16_Next                        // ONE SWEET16 INSTR.

Sweet16_Interpret:
	inc Sweet16_RL(Sweet16_PC)
    bne Sweet16_Execute                     // INCR SWEET16 PC FOR FETCH
    inc Sweet16_RH(Sweet16_PC)
	
@Sweet16_Execute:
	lda #>Sweet16_SET                       // COMMON HIGH BYTE FOR ALL ROUTINES
    pha                                     // PUSH ON STACK FOR RTS
    ldy #$00
    lda (Sweet16_RL(Sweet16_PC)),Y          // FETCH INSTR
    and #$0F                                // MASK REG SPECIFICATION
    asl                                     // DOUBLE FOR TWO BYTE REGISTERS
    tax                                     // TO X REG FOR INDEXING
    lsr
    eor (Sweet16_RL(Sweet16_PC)),Y          // NOW HAVE OPCODE
    beq Sweet16_TOBR                        // IF ZERO THEN NON-REG OP
    stx Sweet16_RH(Sweet16_SR)              // INDICATE "PRIOR RESULT REG"
    lsr
    lsr                                     // OPCODE*2 TO LSB'S
    lsr
    tay                                     // TO Y REG FOR INDEXING
    lda Sweet16_OPTBL-2,Y                   // LOW ORDER ADR BYTE
    pha                                     // ONTO STACK
    rts                                     // GOTO REG-OP ROUTINE

Sweet16_TOBR:
	inc Sweet16_RL(Sweet16_PC)
    bne Sweet16_TOBR2                       // INCR PC
    inc Sweet16_RH(Sweet16_PC)
	
Sweet16_TOBR2:
	lda Sweet16_BRTBL,X                     // LOW ORDER ADR BYTE
    pha                                     // ONTO STACK FOR NON-REG OP
    lda Sweet16_RH(Sweet16_SR)              // "PRIOR RESULT REG" INDEX
    lsr                                     // PREPARE CARRY FOR BC, BNC.
    rts                                     // GOTO NON-REG OP ROUTINE

Sweet16_SETZ:
	lda (Sweet16_RL(Sweet16_PC)),Y          // HIGH ORDER BYTE OF CONSTANT
    sta Sweet16_RH(Sweet16_ACC),X
    dey
    lda (Sweet16_RL(Sweet16_PC)),Y          // LOW ORDER BYTE OF CONSTANT
    sta Sweet16_RL(Sweet16_ACC),X
    tya                                     // Y REG CONTAINS 1
    sec
    adc Sweet16_RL(Sweet16_PC)              // ADD 2 TO PC
    sta Sweet16_RL(Sweet16_PC)
    bcc Sweet16_SET2
    inc Sweet16_RH(Sweet16_PC)

Sweet16_SET2:
	rts

Sweet16_OPTBL:
	.byte <Sweet16_SET-1                    // 1X

Sweet16_BRTBL:
	.byte <Sweet16_RTN-1                    // 0
    .byte <Sweet16_LD-1                     // 2X
    .byte <Sweet16_BR-1                     // 1
    .byte <Sweet16_ST-1                     // 3X
    .byte <Sweet16_BNC-1                    // 2
    .byte <Sweet16_LDAT-1                   // 4X
    .byte <Sweet16_BC-1                     // 3
    .byte <Sweet16_STAT-1                   // 5X
    .byte <Sweet16_BP-1                     // 4
    .byte <Sweet16_LDDAT-1                  // 6X
    .byte <Sweet16_BM-1                     // 5
    .byte <Sweet16_STDAT-1                  // 7X
    .byte <Sweet16_BZ-1                     // 6
    .byte <Sweet16_POP-1                    // 8X
    .byte <Sweet16_BNZ-1                    // 7
    .byte <Sweet16_STPAT-1                  // 9X
    .byte <Sweet16_BM1-1                    // 8
    .byte <Sweet16_ADD-1                    // AX
    .byte <Sweet16_BNM1-1                   // 9
    .byte <Sweet16_SUB-1                    // BX
    .byte <Sweet16_BK-1                     // A
    .byte <Sweet16_POPD-1                   // CX
    .byte <Sweet16_RS-1                     // B
    .byte <Sweet16_CPR-1                    // DX
    .byte <Sweet16_BS-1                     // C
    .byte <Sweet16_INR-1                    // EX
    .byte <Sweet16_XJSR-1                   // D
    .byte <Sweet16_DCR-1                    // FX
    .byte <Sweet16_SETM-1                   // E
    .byte <Sweet16_NUL-1                    // UNUSED
    .byte <Sweet16_SETI-1                   // F

// THE FOLLOWING CODE MUST BE CONTAINED ON A SINGLE PAGE!
.align $100                                 // ensures page aligned
.var page_start = *
Sweet16_RTS_FIX:
	nop                                     // otherwise RTS "cleverness" not so clever
					                        // due to minus -1 yeilding $FF if Sweet16_SET is placed at $00	
Sweet16_SET:
	jmp Sweet16_SETZ                        // ALWAYS TAKEN (moved out of page)

Sweet16_LD:
	lda Sweet16_RL(Sweet16_ACC),X
    sta Sweet16_RL(Sweet16_ACC)
    lda Sweet16_RH(Sweet16_ACC),X           // MOVE RX TO R0
    sta Sweet16_RH(Sweet16_ACC)
    rts

Sweet16_BK:						            // Sweet16_SET this explicity
	brk

Sweet16_SETM:
	jmp Sweet16_SETMOutOfPage 	            // code will make block larger than 255 if placed here

Sweet16_XJSR:
	jmp Sweet16_XJSROutOfPage 	            // code will make block larger than 255 if placed here

Sweet16_ST:
	lda Sweet16_RL(Sweet16_ACC)
    sta Sweet16_RL(Sweet16_ACC),X           // MOVE R0 TO RX
    lda Sweet16_RH(Sweet16_ACC)
    sta Sweet16_RH(Sweet16_ACC),X
    rts

Sweet16_STAT:
	lda Sweet16_RL(Sweet16_ACC)	
Sweet16_STAT2: 
	sta (Sweet16_RL(Sweet16_ACC),X)         // STORE BYTE INDIRECT
    ldy #$00
Sweet16_STAT3:
	sty Sweet16_RH(Sweet16_SR)              // INDICATE R0 IS RESULT NEG
	
Sweet16_INR:
	inc Sweet16_RL(Sweet16_ACC),X
    bne Sweet16_INR2                        // INCR RX
    inc Sweet16_RH(Sweet16_ACC),X	
Sweet16_INR2:
	rts
	
Sweet16_LDAT:
	lda (Sweet16_RL(Sweet16_ACC),X)         // LOAD INDIRECT (RX)
    sta Sweet16_RL(Sweet16_ACC)             // TO R0
    ldy #$00
    sty Sweet16_RH(Sweet16_ACC)             // ZERO HIGH ORDER R0 BYTE
    beq Sweet16_STAT3                       // ALWAYS TAKEN
	
Sweet16_LDDAT:
	jsr Sweet16_LDAT                        // LOW ORDER BYTE TO R0, INCR RX
    lda (Sweet16_RL(Sweet16_ACC),X)         // HIGH ORDER BYTE TO R0
    sta Sweet16_RH(Sweet16_ACC)
    jmp Sweet16_INR                         // INCR RX
	
Sweet16_STDAT:
	jsr Sweet16_STAT                        // STORE INDIRECT LOW ORDER
    lda Sweet16_RH(Sweet16_ACC)             // BYTE AND INCR RX. THEN
    sta (Sweet16_RL(Sweet16_ACC),X)         // STORE HIGH ORDER BYTE.
    jmp Sweet16_INR                         // INCR RX AND RETURN
	
Sweet16_STPAT:
	jsr Sweet16_DCR                         // DECR RX
    lda Sweet16_RL(Sweet16_ACC)
    sta (Sweet16_RL(Sweet16_ACC),X)         // STORE R0 LOW BYTE @RX
    jmp Sweet16_POP3                        // INDICATE R0 AS LAST RESULT REG

Sweet16_DCR:
	lda Sweet16_RL(Sweet16_ACC),X
    bne Sweet16_DCR2                        // DECR RX
    dec Sweet16_RH(Sweet16_ACC),X

Sweet16_DCR2:
	dec Sweet16_RL(Sweet16_ACC),X
    rts
	
Sweet16_SUB:
	ldy #$00                                // RESULT TO R0

Sweet16_CPR:
	sec                                     // NOTE Y REG = 13*2 FOR CPR
    lda Sweet16_RL(Sweet16_ACC)
    sbc Sweet16_RL(Sweet16_ACC),X
    sta Sweet16_RL(Sweet16_ACC),Y           // R0-RX TO RY
    lda Sweet16_RH(Sweet16_ACC)
    sbc Sweet16_RH(Sweet16_ACC),X

Sweet16_SUB2:
	sta Sweet16_RH(Sweet16_ACC),Y
    tya                                     // LAST RESULT REG*2
    adc #$00                                // CARRY TO LSB
    sta Sweet16_RH(Sweet16_SR)
    rts

Sweet16_ADD:
	lda Sweet16_RL(Sweet16_ACC)
    adc Sweet16_RL(Sweet16_ACC),X
    sta Sweet16_RL(Sweet16_ACC)             // R0+RX TO R0
    lda Sweet16_RH(Sweet16_ACC)
    adc Sweet16_RH(Sweet16_ACC),X
    ldy #$00                                // R0 FOR RESULT
    beq Sweet16_SUB2                        // FINISH ADD
	
Sweet16_BS:
	lda Sweet16_RL(Sweet16_PC)              // NOTE X REG IS 12*2!
    jsr Sweet16_STAT2                       // PUSH LOW PC BYTE VIA R12
    lda Sweet16_RH(Sweet16_PC)
    jsr Sweet16_STAT2                       // PUSH HIGH ORDER PC BYTE
	
Sweet16_BR:
	clc
	
Sweet16_BNC:
	bcs Sweet16_BNC2                        // NO CARRY TEST	

Sweet16_BR1:
	lda (Sweet16_RL(Sweet16_PC)),Y          // DISPLACEMENT BYTE
    bpl Sweet16_BR2
    dey

Sweet16_BR2:
	adc Sweet16_RL(Sweet16_PC)              // ADD TO PC
    sta Sweet16_RL(Sweet16_PC)
    tya
    adc Sweet16_RH(Sweet16_PC)
    sta Sweet16_RH(Sweet16_PC)

Sweet16_BNC2:
	rts

Sweet16_BC:
	bcs Sweet16_BR
    rts

Sweet16_BP:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax                                     // TO X REG FOR INDEXING
    lda Sweet16_RH(Sweet16_ACC),X           // TEST FOR PLUS
    bpl Sweet16_BR1                         // BRANCH IF SO
    rts

Sweet16_BM:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax
    lda Sweet16_RH(Sweet16_ACC),X           // TEST FOR MINUS
    bmi Sweet16_BR1
    rts

Sweet16_BZ:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax
    lda Sweet16_RL(Sweet16_ACC),X           // TEST FOR ZERO
    ora Sweet16_RH(Sweet16_ACC),X           // (BOTH BYTES)
    beq Sweet16_BR1                         // BRANCH IF SO
    rts
	
Sweet16_BNZ:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax
    lda Sweet16_RL(Sweet16_ACC),X           // TEST FOR NON-ZERO
    ora Sweet16_RH(Sweet16_ACC),X           // (BOTH BYTES)
    bne Sweet16_BR1                         // BRANCH IF SO
    rts	

Sweet16_BM1:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax
    lda Sweet16_RL(Sweet16_ACC),X           // CHECK BOTH BYTES
    and Sweet16_RH(Sweet16_ACC),X           // FOR $FF (MINUS 1)
    eor #$FF
    beq Sweet16_BR1                         // BRANCH IF SO
    rts
	
Sweet16_BNM1:
	asl                                     // DOUBLE RESULT-REG INDEX
    tax
    lda Sweet16_RL(Sweet16_ACC),X
    and Sweet16_RH(Sweet16_ACC),X           // CHECK BOTH BYTES FOR NO $FF
    eor #$FF
    bne Sweet16_BR1                         // BRANCH IF NOT MINUS 1
	
Sweet16_NUL:
	rts
	
Sweet16_RS:
	ldx #(Sweet16_RSP * 2)                  // FOR RETURN STACK POINTER
    jsr Sweet16_DCR                         // DECR STACK POINTER
    lda (Sweet16_RL(Sweet16_ACC),X)         // POP HIGH RETURN ADDRESS TO PC
    sta Sweet16_RH(Sweet16_PC)
    jsr Sweet16_DCR                         // SAME FOR LOW ORDER BYTE
    lda (Sweet16_RL(Sweet16_ACC),X)
    sta Sweet16_RL(Sweet16_PC)
    rts

Sweet16_POP:
	ldy #$00                                // HIGH ORDER BYTE = 0
    beq Sweet16_POP2                        // ALWAYS TAKEN

Sweet16_POPD:
	jsr Sweet16_DCR                         // DECR RX
    lda (Sweet16_RL(Sweet16_ACC),X)         // POP HIGH ORDER BYTE @RX
    tay                                     // SAVE IN Y REG	
	jmp Sweet16_POP2
	
Sweet16_SETI:
	jmp Sweet16_SETIOutOfPage
	
Sweet16_RTN:
	.var page_size = * - page_start	        // sanity check
    // .print "Page Size: " + page_size + "    Page Start: $" + toHexString(page_start);
	.errorif page_size > 255, "All table entries must jump to same 255 byte page, currently: " + page_size
	jmp Sweet16_RTNZ

Sweet16_POP2:
	jsr Sweet16_DCR                         // DECR RX
    lda (Sweet16_RL(Sweet16_ACC),X)         // LOW ORDER BYTE
    sta Sweet16_RL(Sweet16_ACC)             // TO R0
    sty Sweet16_RH(Sweet16_ACC)
Sweet16_POP3:
	ldy #$00                                // INDICATE R0 AS LAST RESULT REG
    sty Sweet16_RH(Sweet16_SR)
    rts

Sweet16_RTNZ:
	pla                                     // POP RETURN ADDRESS
    pla
    jmp  (Sweet16_RL(Sweet16_PC))           // RETURN TO 6502 CODE VIA PC

@Sweet16_BreakHandler:
	pla		                                // Y
	tay		                                // restore Y
	pla		                                // X
	tax		                                // restore X
	pla		                                // restore A
	sta Sweet16_RL(Sweet16_ZP)
	plp		                                // restore Sweet16_STATUS Flags
	pla		                                // PCL discard - not useful
	pla		                                // PCH discard - not useful
	lda Sweet16_RL(Sweet16_ZP)
	jmp Sweet16_Execute

Sweet16_SETIMCommon:
	lda (Sweet16_RL(Sweet16_PC)),Y       	// dest addr high
	sta Sweet16_RL(Sweet16_ZP)
	Sweet16_IncPC()
	lda (Sweet16_RL(Sweet16_PC)),Y       	// dest addr low
	sta Sweet16_RH(Sweet16_ZP)
	Sweet16_IncPC()
	lda (Sweet16_RL(Sweet16_PC)),Y       	// dest register
	Sweet16_IncPC()
	tay
	inc Sweet16_RL(Sweet16_ZP)
	ldx #Sweet16_RL(Sweet16_ZP)
	rts

Sweet16_SETIOutOfPage:
	jsr Sweet16_SETIMCommon
	lda ($00,X)
	sta $00,Y				                // low order
	dec Sweet16_RL(Sweet16_ZP)
	lda ($00,X)
	sta $01,Y				                // high order
	jmp Sweet16_Execute				        // back to SWEET16

Sweet16_SETMOutOfPage:
	jsr Sweet16_SETIMCommon
	lda ($00,X)
	sta $01,Y				                // high order
	dec Sweet16_RL(Sweet16_ZP)
	lda ($00,X)
	sta $00,Y				                // low order
	jmp Sweet16_Execute				        // back to SWEET16

Sweet16_XJSROutOfPage: {
	lda #>((!returned+)-1)	                // so we know where to come back to as we're
	pha						                // using rts as jmps here
	lda #<((!returned+)-1)
	pha
	lda (Sweet16_RL(Sweet16_PC)),Y       	// high order byte
	pha
	Sweet16_IncPC()
	lda (Sweet16_RL(Sweet16_PC)),Y       	// low order byte
	pha
	Sweet16_IncPC()
	rts				   		                // this performs jump from stack
!returned:
	jmp Sweet16_Execute				        // back to SWEET16
}	
}