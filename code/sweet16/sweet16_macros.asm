#importonce

.macro Sweet16_RegisterEncode(op, register, address) {
	.byte Sweet16_Opcode(op, register)
	.word address.getValue()
}

.macro Sweet16_InstallHandler(address, handler) {
	lda #<handler
    sta address
    lda #>handler
    sta address+1
}

.macro Sweet16_IncPC() {
	inc Sweet16_RL(Sweet16_PC)
    bne !incremented+ 		// inc PC
    inc Sweet16_RH(Sweet16_PC)
!incremented:
}

.macro Sweet16_Register(index, addrLow, addrHigh) {
    .label RL = addrLow
    .label RH = addrHigh
    .print "R" + toHexString(index) + " $" + toHexString(addrLow) + "-" + toHexString(addrHigh)
}

//uncomment to sanity check register placement
// .print "Sweet16 16-bit registers"
// .for (var i = 0; i < 16; i++) {
// 	Sweet16_Register(i, Sweet16_RL(i), Sweet16_RH(i))
// }

