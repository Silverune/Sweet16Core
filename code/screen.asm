#importonce

.macro Screen_ClearDefault() {
	Screen_Clear(Default.SCREEN_MEMORY)
}

.macro Screen_SetCharMemory(charSlot) {
    lda VIC.MemorySetup
    and #%11110001
    ora #charSlot
    sta VIC.MemorySetup
}

.macro Screen_SetUpperLowerCase() {
	.encoding "petscii_mixed"			// put this before any strings placed in memory for use in this mode
	Screen_SetCharMemory(%00000110)
}

// Clears the screen with the current background color (non-kernal)
.macro Screen_Clear(screenAddress) {
	lda #Ascii.SPACE
	ldx #$00
!loop:
	sta screenAddress,x
	sta screenAddress+$100,x
	sta screenAddress+$200,x
	sta screenAddress+$300,x
	inx
	bne !loop-
}

.macro Screen_Border(color) {
	lda #color
	sta VIC.BorderColor
}

.macro Screen_Background(color) {
	lda #color
	sta VIC.BackgroundColor
}

.macro Screen_Color(color) {
	lda #color
	sta Two.CurrentCharColor
}

.macro Screen_OutputString(preprocessorString) {
	Screen_Output(!data+)
	jmp !done+
!data:
	.text preprocessorString	// store in memory
	.byte 0						// terminate
!done:
}

.macro Screen_OutputStringLine(msg) {
	Screen_OutputString(msg)
	Screen_OutputNewline()
}

.macro Screen_OutputStringColor(msg, color) {
	lda Two.CurrentCharColor
	pha
	Screen_Color(color)
	Screen_OutputString(msg)
	pla
	sta Two.CurrentCharColor
}

.macro Screen_OutputColor(msg, color) {
	lda Two.CurrentCharColor
	pha
	Screen_Color(color)
	Screen_Output(msg)
	pla
	sta Two.CurrentCharColor
}

.macro Screen_Binary2Petscii() {
	ora #$30
}

.macro Petscii2Binary() {
	and #$0f
}
	
.macro TwosComplimentA() {
	eor #$ff
	adc #$01
}

.macro Screen_OutputNewline() {
	lda #Ascii.RETURN
	jsr Kernal.CHROUT
}

.macro Screen_OutputLine_Indirect(indirectAddress) {
	ldy #$00
!loop:
	lda (indirectAddress),y
	beq !done+
	jsr Kernal.CHROUT
	iny
	jmp !loop-
!done:	
	Screen_OutputNewline()
}

// assumes null terminated memory address
.macro Screen_Output(address) {
	ldx #$00
!loop:
	lda address,x
	beq !done+
	jsr Kernal.CHROUT
	inx
	jmp !loop-
!done:	
}

.macro Screen_Output_Indirect(indirectAddress) {
	ldy #$00
!loop:
	lda (indirectAddress),y
	beq !done+
	jsr Kernal.CHROUT
	iny
	jmp !loop-
!done:	
}

.macro Screen_OutputLine(address) {
	Screen_Output(address)
	Screen_OutputNewline()
}

// Y contains the loop counter
.macro Screen_CalcReference(value, reference) {
	lda value
	cmp #reference
	bcc !done+
	ldy #$00		// counter
!loop:
	iny				// count references's
	sbc #reference
	cmp #reference
	bcs !loop-		// still larger than reference
!done:
}
	
.macro Screen_OutputNumber2Digit(value) {
	.const TWO_DIGIT = $0a
	lda value
	cmp #TWO_DIGIT
	bcc !oneDigit+
	Screen_CalcReference(value, TWO_DIGIT)
	tya
	pha
	Screen_Binary2Petscii() 					// display value
	jsr Kernal.CHROUT
	pla
	tay
	lda value
!subby:
	sec
	sbc #TWO_DIGIT
	dey
	bne !subby-
	Screen_Binary2Petscii() 					// display value
	jsr Kernal.CHROUT
	jmp !done+
!oneDigit:
	Screen_Binary2Petscii() 					// display value
	jsr Kernal.CHROUT
!done:	
}

// output to the screen the value stored at the passed in address
// only up to 255 is supported	
.macro Screen_OutputNumber(value, tempAddress) {
	.const THREE_DIGIT = $64		// 100
	lda value
	cmp #THREE_DIGIT
	bcc !twoDigit+
	Screen_CalcReference(value, THREE_DIGIT)
	tya
	pha
	Screen_Binary2Petscii() 					// display value
	jsr Kernal.CHROUT
	pla
	tay
	lda value
!subby:
	sec
	sbc #THREE_DIGIT
	dey
	bne !subby-
	sta tempAddress
	Screen_OutputNumber2Digit(tempAddress)
	jmp !done+
!twoDigit:
	Screen_OutputNumber2Digit(value)
!done:	
}

.macro Screen_TwoDigitValue2BufferX(bufferAddress) {
	tay
	lsr
	lsr
	lsr
	lsr
	ora	#'0'
	sta	bufferAddress,x
	inx

	tya
	and	#$0f
	ora	#'0'
	sta	bufferAddress,x
	inx
}

.macro Screen_WaitForFrame(frameRow) {
!:
	lda VIC.RasterLine
	cmp #frameRow
	bne !-
}

.macro Screen_WaitForOffscreen() { // wait for offscreen (row 300)
vwos0:	 
	lda VIC.ScreenControl1	// wait for raster msb clear..
    and #$80
    bne vwos0
vwos1:
	lda VIC.ScreenControl1 // wait for raster msb set (line 256)..
    and #$80
    beq vwos1
vwos2:	 
	lda VIC.RasterLine // wait for raster line 300 (256 + 44)...
    cmp #44
    bne vwos2
}

.macro Screen_OutputChar(char) {
	lda #char
	jsr Kernal.CHROUT
}