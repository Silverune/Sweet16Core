#importonce

.macro Address_Word() {
    .label lo = *       // naming consistency with .lohifill
    .label hi = *+1     // naming consistency with .lohifill
    .word $0000
}

.macro Address_WordAddr(addr) {
    *=addr virtual
    .label lo = *       // naming consistency with .lohifill
    .label hi = *+1     // naming consistency with .lohifill
    .word $0000
    *=addr virtual
}

.macro Address_WordsAddr(addr, number) {
    *=addr virtual
#if VERBOSE_LABELS
    .for(var i = 0; i < number; i++) {
        .label lo = *       // naming consistency with .lohifill
        .label hi = *+1     // naming consistency with .lohifill
        .word $00
    }
#else
    .fill number * 2, $00
#endif
    *=addr virtual
}

.macro Address_Byte() {
    .byte $00
}

.macro Address_ByteAddr(addr) {
    *=addr virtual
    .byte $00
    *=addr virtual
}

.macro Address_Bytes(number) {
#if VERBOSE_LABELS
    .for(var i = 0; i < number; i++) {        
        .label by = *
        .byte $00
    }
#else
    .fill number, $00
#endif
}

.macro Address_BytesAddr(addr, number) {
    *=addr virtual
#if VERBOSE_LABELS
    .for(var i = 0; i < number; i++) {
        .label by = *
        .byte $00
    }
#else
    .fill number, $00
#endif
    *=addr virtual
}

.macro Address_Nybble() {
    .byte $0
}

.macro Address_NybbleAddr(addr) {
    *=addr virtual
    .byte $00
    *=addr virtual
}

.macro Address_Page() {
    .fill $100, $00
}

.macro Address_Pages(number) {
    .fill number * $100, $00
}

.macro Address_PageAddr(addr) {
    *=addr virtual
    .fill $100, $00
    *=addr virtual
}

.macro Address_PagesAddr(addr, number) {
    *=addr virtual
#if VERBOSE_LABELS
    .for(var i = 0; i < number; i++) {
        .label pg = *
        .fill number * $100, $00
    }
#else
    .fill number * $100, $00
#endif
    *=addr virtual
}

.macro Address_LoadImmediate(immediate, address) {
    lda #<immediate
    sta address
    lda #>immediate
    sta address+1
}

.macro Address_LoadImmediateByte(immediate, address) {
    lda #immediate
    sta address
}

.macro Address_LoadFull(address, lowByte, highByte) {
	lda #<address
    sta lowByte
    lda #>address 
    sta highByte
}

// Loads the address pointed to at the address passed in.  e.g.,  if $03 contains the
// value $1234 and the value at $1234 contains the value $feed then the value in X and Y
// will be $feed
// X the LSB, Y the MSB
.macro Address_LoadIndirectXY(indirectAddress) {
    ldy #$00
    lda (indirectAddress),y
    tax
    iny
    lda (indirectAddress),y
    tay
}

// Loads the address pointed to at the address passed in.  e.g.,  if $03 contains the
// value $1234 and the value at $1234 contains the value $feed then the value in X and Y
// will be $feed
// Y the MSB, X the LSB
.macro Address_LoadIndirectYX(indirectAddress) {
    ldy #$01
    lda (indirectAddress),y
    tax
    dey
    lda (indirectAddress),y
    tay
}

.macro Address_Load(address, lowByte) {
	Address_LoadFull(address, lowByte, lowByte + 1)
}

.macro Address_CopyByte(address, byte) {
	lda address
	sta byte
}

.macro Address_CopyWord(address, wordLowByte) {
    Address_CopyByte(address, wordLowByte)
    Address_CopyByte(address+1, wordLowByte+1)
}

// when jump too far work around to use a JMP instead of branching call
.macro Address_Bne2Jmp(addr) {
    bne !+
    jmp !++
!:
    jmp addr
!:
}

// when jump too far work around to use a JMP instead of branching call
.macro Address_Beq2Jmp(addr) {
    beq !+
    jmp !++
!:
    jmp addr
!:
}

// when jump too far work around to use a JMP instead of branching call
.macro Address_Bcs2Jmp(addr) {
    bcs !+
    jmp !++
!:
    jmp addr
!:
}

// when jump too far work around to use a JMP instead of branching call
.macro Address_Bcc2Jmp(addr) {
    bcc !+
    jmp !++
!:
    jmp addr
!:
}

// allows the address to point to a routine which can then call "rts" to return to the calling code
// value of A lost, if need A preserverd
.macro Address_Functor(functorPointer) {
    Stack_RtsJmp(!+)
    jmp (functorPointer)
!:
}

// allows the address to point to a routine which can then call "rts" to return to the calling code
// value of A preserved, value of X is lost
.macro Address_FunctorA(functorPointer) {
    tax
    Stack_RtsJmp(!+)
    txa
    jmp (functorPointer)
!:
}

.macro Address_BranchIfEven(even) {
	lsr                  // bit 0 to Carry
	bcc even
}

.macro Address_BranchIfOdd(odd) {
	lsr                  // bit 0 to Carry
	bcs odd
}

.macro Address_BranchLogical(even, odd) {
	lsr                  // bit 0 to Carry
	bcc even
	bcs odd
}

// Checks if a value of zero has been passed in instead of a regular address.  Checks if that means $0, $1 is the address
.macro Address_IsNull(address, isNull) {
    lda #<address
    bne !nonNull+
    lda #<address+1
    cmp #1
    bne !nonNull+
    lda #0
    jmp isNull
!nonNull:
}
