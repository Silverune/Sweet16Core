#importonce

// convenience entry point
// save - (optional) if non-zero will save registers on entry and restore on exit
// subroutine_setup - (optional) sets up the subroutine stack pointer to safe memory so that subroutine calls work
// break_handler - (optional) installs a ISR to called if the "bk" command is in ever used (6502 "brk" as well).  The routine restores the state and sets up to continue execution.  Useful for debugging in assembly monitors 
.pseudocommand @sweet16 save : subroutine_setup : break_handler {

	.var save_restore = 1
	.if (save.getType() != AT_NONE)
		.eval save_restore = save.getValue()
	.if (save_restore != 0) {
		Stack_Save()
		lda #1											// store that need to restore for RTN
	}
	else
		lda #0											// ignore stack in RTN
	pha

	.var install_subroutine_stack = 0					// off by default
	.if (subroutine_setup.getType() != AT_NONE)
		.eval install_subroutine_stack = subroutine_setup.getValue()
	.if (install_subroutine_stack != 0)
		jsr Sweet16_InitializeSubroutineStack

	.var install_break = 0								// off by default
	.if (break_handler.getType() != AT_NONE)
		.eval install_break = break_handler.getValue()
	.if (install_break != 0)
		Address_Load(install_break == 1 ? Sweet16_BreakHandler : install_break, Three.BRK)

	jsr Sweet16_Main
}
.pseudocommand @SWEET16 save : subroutine_setup : break_handler { sweet16 save : subroutine_setup : break_handler }

// debugging convenience to load into the X and Y regsiters the specified SWEET16 register
.pseudocommand @ldxy register {
	ldx Sweet16_RL(register.getValue())
	ldy Sweet16_RH(register.getValue())
}
.pseudocommand @LDXY register { ldxy register }

// Nonregister Ops	
.pseudocommand @rtn { .byte $00
	pla
	beq !+
	Stack_Restore()
!:
 }
.pseudocommand @RTN { rtn }

.pseudocommand @br ea { .byte $01, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BR ea { br ea }

.pseudocommand @bnc ea { .byte $02, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BNC ea { bnc ea }

.pseudocommand @bc ea { .byte $03, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BC ea { bc ea }

.pseudocommand @bp ea { .byte $04, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BP ea { bp ea }

.pseudocommand @bm ea { .byte $05, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BM ea { bm ea }

.pseudocommand @bz ea { .byte $06, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BZ ea { bz ea }

.pseudocommand @bnz ea { .byte $07, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BNZ ea { bnz ea }

.pseudocommand @bm1 ea { .byte $08, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BM1 ea { bm1 ea }

.pseudocommand @bnm1 ea { .byte $09, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BNM1 ea { bnm1 ea }

.pseudocommand @bk { .byte $0a }
.pseudocommand @BK { bk }

.pseudocommand @rs { .byte $0b }
.pseudocommand @RS { rs }

.pseudocommand @bs ea { .byte $0c, Sweet16_EffectiveAddress(ea,*) }
.pseudocommand @BS ea { bs ea }

// extensions
.pseudocommand @xjsr address {
	.byte $0d
	.byte >(address.getValue()-1)
	.byte <(address.getValue()-1)
}
.pseudocommand @XJSR address { xjsr address }

// Register Ops
.pseudocommand @set register : address { Sweet16_RegisterEncode($10, register, address) }
.pseudocommand @SET register : address { set register : address }

.pseudocommand @ld register { .byte Sweet16_Opcode($20, register) }
.pseudocommand @LD register { ld register }

.pseudocommand @st register { .byte Sweet16_Opcode($30, register) }
.pseudocommand @ST register { st register }

.pseudocommand @ldi register { .byte Sweet16_Opcode($40, register) }
.pseudocommand @LDI register { ldi register }

.pseudocommand @sti register { .byte Sweet16_Opcode($50, register) }
.pseudocommand @STI register { sti register }

.pseudocommand @lddi register { .byte Sweet16_Opcode($60, register) }
.pseudocommand @LDDI register { lddi register }

.pseudocommand @stdi register { .byte Sweet16_Opcode($70, register) }
.pseudocommand @STDI register { stdi register }

.pseudocommand @popi register { .byte Sweet16_Opcode($80, register) }
.pseudocommand @POPI register { popi register }

.pseudocommand @stpi register { .byte Sweet16_Opcode($90, register) }
.pseudocommand @STPI register { stpi register }

.pseudocommand @add register { .byte Sweet16_Opcode($a0, register) }
.pseudocommand @ADD register { add register }

.pseudocommand @sub register { .byte Sweet16_Opcode($b0, register) }
.pseudocommand @SUB register { sub register }

.pseudocommand @popdi register { .byte Sweet16_Opcode($c0, register) }
.pseudocommand @POPDI register { popdi register }

.pseudocommand @cpr register { .byte Sweet16_Opcode($d0, register) }
.pseudocommand @CPR register { cpr register }

.pseudocommand @inr register { .byte Sweet16_Opcode($e0, register) }
.pseudocommand @INR register { inr register }

.pseudocommand @dcr register { .byte Sweet16_Opcode($f0, register) }
.pseudocommand @DCR register { dcr register }

// extensions
.pseudocommand @seti register : address {
	.byte $0f
	.word address.getValue()
	.byte Sweet16_RL(register.getValue())
}
.pseudocommand @SETI register : address { seti register : address }

.pseudocommand @setm register : address {
	.byte $0e
	.word address.getValue()
	.byte Sweet16_RL(register.getValue())
}
.pseudocommand @SETM register : address { setm register : address }
	
// "You can perform absolute jumps within SWEET 16 by loading the ACC (R0) with the address you wish to jump to (minus 1) and executing a ST R15 instruction."  This is not a core SWEET16 instruction
.pseudocommand @ajmp address {
	set Sweet16_ACC : address.getValue()-1
	st Sweet16_PC
}
.pseudocommand @AJMP address { ajmp address }
