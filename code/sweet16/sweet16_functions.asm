#importonce

.function Sweet16_RL(register) {
	.return Sweet16_ZP_BASE + (register * 2)
}

.function Sweet16_RH(register) {
	.return Sweet16_RL(register) + 1
}

.function Sweet16_Opcode(operand, register) {
	.if (register.getType() == AT_IMMEDIATE || register.getType() == AT_ABSOLUTE)
		.return operand + register.getValue()
	.error "Register must be a number"
}

// An effective address (ea) is calculated by adding the signed displacement byte (d) to the PC. The PC contains the address of the instruction immediately following the BR, or the address of the BR op plus 2. The displacement is a signed two's complement value from -128 to +127. Branch conditions are not changed.	
.function Sweet16_CalcEffectiveAddress(d, currentAddress) {
	.var finalAddress
	.if (d >= $80) {
		.eval finalAddress = currentAddress + 2 - ($100 - d)
	}
	else {	
		.eval finalAddress = currentAddress + 2 + d 
	}
	.errorif finalAddress < 0, "PC cannot be negative"
	.return finalAddress
}

// NOTE - this directly tests documentation I found on SWEET16 in the BR instruction, however, using Kick I do not need to use the calc_effective_address function as can simply calculate it as shown in the "effective_address" implementation below 
.function Sweet16_TestCalculateEffectiveAddress(currentAddress) {
	.var values = List().add($80, $81, $ff, $00, $01, $7e, $7f)
	.for (var i = 0	; i < values.size(); i++) {
	}
}
	
.function Sweet16_EffectiveAddress(ea, currentAddress) {

	.var d = (ea.getValue() - currentAddress)
	.errorif d > 127, "Displacement too far forward " + d + ".  Move the branch within 127 bytes"
	.errorif d < -128, "Displacement too far backward " + d + ".  Move the branch within 127 bytes"
	.var relativeAddress = <(ea.getValue() - currentAddress - 2) // account for byte offset
	.return relativeAddress
}
