#importonce

.const Cookie_CODE = $feed;

.macro Cookie_WriteCode() {
    .byte >Cookie_CODE, <Cookie_CODE
}

// checks if the placeholder is there - Carry set if found
.macro Cookie_Check(address) {
	
	lda address
	cmp #(>Cookie_CODE) // opposite to normal so reads natural in memory inspection
	bne !nope+
	lda address+1
	cmp #(<Cookie_CODE)
	bne !nope+
	sec					// found
    jmp !done+
!nope:
	clc					// not found
!done:
}
