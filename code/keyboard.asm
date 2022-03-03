#importonce

// returns currently pressed key into A
.macro Keyboard_Get() {
    jsr Kernal.SCNKEY   // scan keyboard
    jsr Kernal.GETIN    // put result into A
}

// returns when a key is pressed
.macro Keyboard_Any() {
!:
	Keyboard_Get()
	beq !-
}

.macro Keyboard_ReadSetup() {
	lda #%11111111  // CIA#1 Port A set to output 
    sta CIA1.PortADataDirection            
    lda #%00000000  // CIA#1 Port B set to input
    sta CIA1.PortBDataDirection
}

.macro Keyboard_CheckKey(row, column, address) {
	lda #row
    sta CIA1.PortA 
    lda CIA1.PortB           // load column information
    and #column
    beq address
}

.macro Keyboard_CheckSpace(address) {
	Keyboard_CheckKey(%01111111, %00010000, address)
}

.macro Keyboard_CheckQ(address) {
	Keyboard_CheckKey(%01111111, %01000000, address)
}
