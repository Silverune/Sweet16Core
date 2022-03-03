#importonce 

.macro Stack_Save() {
    php             // status
    pha             // A
    txa
    pha             // X
    tya
    pha             // Y
    cld             // clear decimal
}

.macro Stack_Restore() {
    pla
    tay             // Y
    pla         
    tax             // X
    pla             // A
    plp             // status
}

.macro Stack_RtsJmp(returnAddr) {
	lda #>returnAddr-1
   	pha 
   	lda #<returnAddr-1
   	pha
}

.macro Stack_SizeStore() {
	// read the stack pointer
	tsx			// copy stack pointer
	txa			// put it on the stack
	pha
}

.macro Stack_SizeCheck(error) {
	// check stack pointer is the same (assumes copy of stack pointer previously stored on stack)
	pla			// pull previous stack value
	tay
	tsx			// get current stack pointer
	txa
	cmp One.HardwareStackArea,y
	beq !+
	jmp error
!:
}

.macro Stack_Safe(subroutine, error) {
	Stack_SizeStore()
	jsr subroutine
	Stack_SizeCheck(error)
}