// .const IsrAddress = $314
// .const InterruptControlRegister = $d01a;
// .const ScreenControlRegister1 = $d011;	// Bit #7 is top bit of raster line from $d012
//.const RasterLine = $d012
//.const InterruptStatusRegister = $d019
// .const BorderColor = $d020
// .const InterruptControlStatusRegister = $dc0d
// .const KernalISR = $ea31
// .const KernalISRExit = $ea81

// from https://github.com/1888games/Fire-Game-Watch/tree/master/Lionel
// see https://gitlab.com/retro-coder/commodore/kick-assembler-vscode-ext
TEMP2:		.byte $00
TEMP3:		.byte $00
TEMP4:		.byte $00
TEMP5:		.byte $00
TEMP6:		.byte $00
TEMP7:		.byte $00
TEMP8:		.byte $00
TEMP9:		.byte $00
TEMP10:		.byte $00
TEMP11:		.byte $00
TEMP12:		.byte $00

VECTOR1: 	.word $00
VECTOR2: 	.word $00
VECTOR3: 	.word $00
VECTOR4: 	.word $00
VECTOR5: 	.word $00
VECTOR6: 	.word $00

SCREEN_RAM: .word $00
COLOR_RAM: .word $00

ZP_COUNTER: 	.byte $00

}

C64: {
	
	.label IRQControlRegister1 = $dc0d
	.label IRQControlRegister2 = $dd0d
	.label Processor_Port = $01
	.label Serial_Bus_Port_A = $dd00

	Frequency: .word $d400, $d407, $d40e
	FrequencyMSB: .word $d401, $d408, $d40f
	Pulse_Width: .word $d402, $d409, $d410
	AttDec: .word $d405, $d40c, $d413
	Sustain: .word $d406, $d40d, $d414
	Control: .word $d404, $d40b, $d412

	.label VOICE_1_FREQUENCY = $d400		// & $d401
	.label VOICE_1_PULSE_WIDTH = $d402	// & $d403
	.label VOICE_1_CONTROL = $d404		// Noise, Rect, Saw, Tri, Reset, Ring, Sync, On/off
	.label VOICE_1_ATTDEC = $d405		// Attack 4-bits Decay 4-bits
	.label VOICE_1_SUSTAIN = $d406 	// Volume 4-bits Release 4-bits
	.label VOLUME_FILTER = $d418

	.label VOICE_2_FREQUENCY = $d407		// & $d401
	.label VOICE_2_PULSE_WIDTH = $d409	// & $d403
	.label VOICE_2_CONTROL = $d40b		// Noise, Rect, Saw, Tri, Reset, Ring, Sync, On/off
	.label VOICE_2_ATTDEC = $d40c		// Attack 4-bits Decay 4-bits
	.label VOICE_2_SUSTAIN = $d40d 	// Volume 4-bits Release 4-bits

	.label VOICE_3_FREQUENCY = $d40e		// & $d401
	.label VOICE_3_PULSE_WIDTH = $d410	// & $d403
	.label VOICE_3_CONTROL = $d412		// Noise, Rect, Saw, Tri, Reset, Ring, Sync, On/off
	.label VOICE_3_ATTDEC = $d413		// Attack 4-bits Decay 4-bits
	.label VOICE_3_SUSTAIN = $d414 	// Volume 4-bits Release 4-bits





	PlayNote: {

		.if(target == "C64") {

		
			txa
			asl
			tax


			//MSB
			lda Control, x
			sta SetControl + 1

			lda AttDec, x
			sta SetAttDec + 1

			lda Sustain, x
			sta SetSustain + 1

			lda Frequency, x
			sta SetFrequency + 1

			
			lda FrequencyMSB, x
			sta SetFrequencyMSB + 1

			inx
			lda Control, x
			sta SetControl + 2

			lda AttDec, x
			sta SetAttDec + 2

			lda Sustain, x
			sta SetSustain + 2

			lda Frequency, x
			sta SetFrequency + 2

			lda FrequencyMSB, x
			sta SetFrequencyMSB + 2

			ldy #0

			lda #%00100001

			SetControl:

				sta $BEEF

			lda #%00000101

			SetAttDec: 

				sta $BEEF

			lda #%11110011

			SetSustain:

				sta $BEEF

			lda SOUND.NoteValue

			SetFrequency:

				sta $BEEF

			lda SOUND.NoteValue + 1

			SetFrequencyMSB:

				sta $BEEF

			dex
			txa
			lsr
			tax

			Finish:



		}

		rts
	}


	StopNote: {


		.if(target == "C64") {

		
			txa
			asl
			tax


			//MSB
			lda Control, x
			sta SetControl + 1

			inx
			lda Control, x
			sta SetControl + 2

			lda Sustain, x
			sta SetSustain + 2

			lda #%00100000

			SetControl:

				sta $BEEF

			lda #%00000000

			SetSustain:

				sta $BEEF


			dex
			txa
			lsr
			tax

			Finish:

		}

		rts
	}

	DisableCIA: {

		.if(target == "C64") {

		// prevent CIA interrupts now the kernal is banked out
			lda #$7f
			sta IRQControlRegister1
			sta IRQControlRegister2
		}

		rts

	}


	BankOutKernalAndBasic:{

		.if(target == "C64") {

			lda Processor_Port
			and #%11111000
			ora #%00000101
			sta Processor_Port

		}

		rts
	}


	SetC64VICBank: {

		.if(target == "C64") {


			.label ValueToSave = TEMP1

			sta ValueToSave

			lda C64.Serial_Bus_Port_A
			and #%11111100
			ora ValueToSave
			sta C64.Serial_Bus_Port_A

		}

		rts

	}




}



 

.macro SetC64VICBank(value) {

		.if (target == "C64") {

			Lookup: .byte 3, 2, 1, 0
			.label ValueToSave = TEMP1

			ldx #value
			lda Lookup, x
			sta ValueToSave

			lda ValueToSave

			lda C64.Serial_Bus_Port_A
			and #%11111100
			ora ValueToSave
			sta C64.Serial_Bus_Port_A

			lda #0
			sta C64.Serial_Bus_Port_A


		}


}


.macro SetC64ScreenMemory (location) {

	.if(target == "C64") {

		lda #<location
		sta SCREEN_RAM
		lda #>location
		sta SCREEN_RAM + 1

		.label ShiftedPointer = TEMP1
		lda #C64ScreenRamLocations.get(location)
		asl
		asl
		asl
		asl
		sta ShiftedPointer

		lda Memory_Setup_Register
		and #%00001111
		ora ShiftedPointer
		sta Memory_Setup_Register

		lda #C64ScreenRamBanks.get(location)

		jsr C64.SetC64VICBank

	}

	
}


.macro SetC64CharacterMemory (location) {

	.if(target == "C64") {

		.label ShiftedPointer = TEMP1
		lda #C64CharRamLocations.get(location)
		asl
		sta ShiftedPointer

		lda Memory_Setup_Register
		and #%11110001
		ora ShiftedPointer
		sta Memory_Setup_Register

	}

	
}

	.var C64ScreenRamLocations = Hashtable()
	.var C64ScreenRamBanks = Hashtable()
	.var C64CharRamLocations = Hashtable()
	.var NoteValuesC64 = Hashtable()

	.var currentAddress = $0000
	.var currentBank = 0

	.if(target == "C64") {

	.eval C64ScreenRamLocations.put($0000, 0)
	.eval C64ScreenRamLocations.put($0400, 1)
	.eval C64ScreenRamLocations.put($0800, 2)
	.eval C64ScreenRamLocations.put($0C00, 3)
	.eval C64ScreenRamLocations.put($1000, 4)
	.eval C64ScreenRamLocations.put($1400, 5)
	.eval C64ScreenRamLocations.put($1800, 6)
	.eval C64ScreenRamLocations.put($1C00, 7)
	.eval C64ScreenRamLocations.put($2000, 8)
	.eval C64ScreenRamLocations.put($2400, 9)
	.eval C64ScreenRamLocations.put($2800, 10)
	.eval C64ScreenRamLocations.put($2C00, 11)
	.eval C64ScreenRamLocations.put($3000, 12)
	.eval C64ScreenRamLocations.put($3400, 13)
	.eval C64ScreenRamLocations.put($3000, 14)
	.eval C64ScreenRamLocations.put($3400, 15)
	.eval C64ScreenRamLocations.put($3800, 14)
	.eval C64ScreenRamLocations.put($3C00, 15)

	.eval C64ScreenRamLocations.put($0000 + $4000, 0)
	.eval C64ScreenRamLocations.put($0400 + $4000, 1)
	.eval C64ScreenRamLocations.put($0800 + $4000, 2)
	.eval C64ScreenRamLocations.put($0C00 + $4000, 3)
	.eval C64ScreenRamLocations.put($1000 + $4000, 4)
	.eval C64ScreenRamLocations.put($1400 + $4000, 5)
	.eval C64ScreenRamLocations.put($1800 + $4000, 6)
	.eval C64ScreenRamLocations.put($1C00 + $4000, 7)
	.eval C64ScreenRamLocations.put($2000 + $4000, 8)
	.eval C64ScreenRamLocations.put($2400 + $4000, 9)
	.eval C64ScreenRamLocations.put($2800 + $4000, 10)
	.eval C64ScreenRamLocations.put($2C00 + $4000, 11)
	.eval C64ScreenRamLocations.put($3000 + $4000, 12)
	.eval C64ScreenRamLocations.put($3400 + $4000, 13)
	.eval C64ScreenRamLocations.put($3800 + $4000, 14)
	.eval C64ScreenRamLocations.put($3C00 + $4000, 15)

	.eval C64ScreenRamLocations.put($0000 + $8000, 0)
	.eval C64ScreenRamLocations.put($0400 + $8000, 1)
	.eval C64ScreenRamLocations.put($0800 + $8000, 2)
	.eval C64ScreenRamLocations.put($0C00 + $8000, 3)
	.eval C64ScreenRamLocations.put($1000 + $8000, 4)
	.eval C64ScreenRamLocations.put($1400 + $8000, 5)
	.eval C64ScreenRamLocations.put($1800 + $8000, 6)
	.eval C64ScreenRamLocations.put($1C00 + $8000, 7)
	.eval C64ScreenRamLocations.put($2000 + $8000, 8)
	.eval C64ScreenRamLocations.put($2400 + $8000, 9)
	.eval C64ScreenRamLocations.put($2800 + $8000, 10)
	.eval C64ScreenRamLocations.put($2C00 + $8000, 11)
	.eval C64ScreenRamLocations.put($3000 + $8000, 12)
	.eval C64ScreenRamLocations.put($3400 + $8000, 13)
	.eval C64ScreenRamLocations.put($3800 + $8000, 14)
	.eval C64ScreenRamLocations.put($3C00 + $8000, 15)

	.eval C64ScreenRamLocations.put($0000 + $C000, 0)
	.eval C64ScreenRamLocations.put($0400 + $C000, 1)
	.eval C64ScreenRamLocations.put($0800 + $C000, 2)
	.eval C64ScreenRamLocations.put($0C00 + $C000, 3)
	.eval C64ScreenRamLocations.put($1000 + $C000, 4)
	.eval C64ScreenRamLocations.put($1400 + $C000, 5)
	.eval C64ScreenRamLocations.put($1800 + $C000, 6)
	.eval C64ScreenRamLocations.put($1C00 + $C000, 7)
	.eval C64ScreenRamLocations.put($2000 + $C000, 8)
	.eval C64ScreenRamLocations.put($2400 + $C000, 9)
	.eval C64ScreenRamLocations.put($2800 + $C000, 10)
	.eval C64ScreenRamLocations.put($2C00 + $C000, 11)
	.eval C64ScreenRamLocations.put($3000 + $C000, 12)
	.eval C64ScreenRamLocations.put($3400 + $C000, 13)
	.eval C64ScreenRamLocations.put($3800 + $C000, 14)
	.eval C64ScreenRamLocations.put($3C00 + $C000, 15)

	.eval C64ScreenRamBanks.put($0000, 3)
	.eval C64ScreenRamBanks.put($0400, 3)
	.eval C64ScreenRamBanks.put($0800, 3)
	.eval C64ScreenRamBanks.put($0C00, 3)
	.eval C64ScreenRamBanks.put($1000, 3)
	.eval C64ScreenRamBanks.put($1400, 3)
	.eval C64ScreenRamBanks.put($1800, 3)
	.eval C64ScreenRamBanks.put($1C00, 3)
	.eval C64ScreenRamBanks.put($2000, 3)
	.eval C64ScreenRamBanks.put($2400, 3)
	.eval C64ScreenRamBanks.put($2800, 3)
	.eval C64ScreenRamBanks.put($2C00, 3)
	.eval C64ScreenRamBanks.put($3000, 3)
	.eval C64ScreenRamBanks.put($3400, 3)
	.eval C64ScreenRamBanks.put($3000, 3)
	.eval C64ScreenRamBanks.put($3400, 3)
	.eval C64ScreenRamBanks.put($3800, 3)
	.eval C64ScreenRamBanks.put($3C00, 3)

	.eval C64ScreenRamBanks.put($0000 + $4000, 2)
	.eval C64ScreenRamBanks.put($0400 + $4000, 2)
	.eval C64ScreenRamBanks.put($0800 + $4000, 2)
	.eval C64ScreenRamBanks.put($0C00 + $4000, 2)
	.eval C64ScreenRamBanks.put($1000 + $4000, 2)
	.eval C64ScreenRamBanks.put($1400 + $4000, 2)
	.eval C64ScreenRamBanks.put($1800 + $4000, 2)
	.eval C64ScreenRamBanks.put($1C00 + $4000, 2)
	.eval C64ScreenRamBanks.put($2000 + $4000, 2)
	.eval C64ScreenRamBanks.put($2400 + $4000, 2)
	.eval C64ScreenRamBanks.put($2800 + $4000, 2)
	.eval C64ScreenRamBanks.put($2C00 + $4000, 2)
	.eval C64ScreenRamBanks.put($3000 + $4000, 2)
	.eval C64ScreenRamBanks.put($3400 + $4000, 2)
	.eval C64ScreenRamBanks.put($3800 + $4000, 2)
	.eval C64ScreenRamBanks.put($3C00 + $4000, 2)

	.eval C64ScreenRamBanks.put($0000 + $8000, 1)
	.eval C64ScreenRamBanks.put($0400 + $8000, 1)
	.eval C64ScreenRamBanks.put($0800 + $8000, 1)
	.eval C64ScreenRamBanks.put($0C00 + $8000, 1)
	.eval C64ScreenRamBanks.put($1000 + $8000, 1)
	.eval C64ScreenRamBanks.put($1400 + $8000, 1)
	.eval C64ScreenRamBanks.put($1800 + $8000, 1)
	.eval C64ScreenRamBanks.put($1C00 + $8000, 1)
	.eval C64ScreenRamBanks.put($2000 + $8000, 1)
	.eval C64ScreenRamBanks.put($2400 + $8000, 1)
	.eval C64ScreenRamBanks.put($2800 + $8000, 1)
	.eval C64ScreenRamBanks.put($2C00 + $8000, 1)
	.eval C64ScreenRamBanks.put($3000 + $8000, 1)
	.eval C64ScreenRamBanks.put($3400 + $8000, 1)
	.eval C64ScreenRamBanks.put($3800 + $8000, 1)
	.eval C64ScreenRamBanks.put($3C00 + $8000, 1)

	.eval C64ScreenRamBanks.put($0000 + $C000, 0)
	.eval C64ScreenRamBanks.put($0400 + $C000, 0)
	.eval C64ScreenRamBanks.put($0800 + $C000, 0)
	.eval C64ScreenRamBanks.put($0C00 + $C000, 0)
	.eval C64ScreenRamBanks.put($1000 + $C000, 0)
	.eval C64ScreenRamBanks.put($1400 + $C000, 0)
	.eval C64ScreenRamBanks.put($1800 + $C000, 0)
	.eval C64ScreenRamBanks.put($1C00 + $C000, 0)
	.eval C64ScreenRamBanks.put($2000 + $C000, 0)
	.eval C64ScreenRamBanks.put($2400 + $C000, 0)
	.eval C64ScreenRamBanks.put($2800 + $C000, 0)
	.eval C64ScreenRamBanks.put($2C00 + $C000, 0)
	.eval C64ScreenRamBanks.put($3000 + $C000, 0)
	.eval C64ScreenRamBanks.put($3400 + $C000, 0)
	.eval C64ScreenRamBanks.put($3800 + $C000, 0)
	.eval C64ScreenRamBanks.put($3C00 + $C000, 0)

	.eval C64CharRamLocations.put($0000, 0)
	.eval C64CharRamLocations.put($0800, 1)
	.eval C64CharRamLocations.put($1000, 2)
	.eval C64CharRamLocations.put($1800, 3)
	.eval C64CharRamLocations.put($2000, 4)
	.eval C64CharRamLocations.put($2800, 5)
	.eval C64CharRamLocations.put($3000, 6)
	.eval C64CharRamLocations.put($3800, 7)

	.eval C64CharRamLocations.put($0000 + $4000, 0)
	.eval C64CharRamLocations.put($0800 + $4000, 1)
	.eval C64CharRamLocations.put($1000 + $4000, 2)
	.eval C64CharRamLocations.put($1800 + $4000, 3)
	.eval C64CharRamLocations.put($2000 + $4000, 4)
	.eval C64CharRamLocations.put($2800 + $4000, 5)
	.eval C64CharRamLocations.put($3000 + $4000, 6)
	.eval C64CharRamLocations.put($3800 + $4000, 7)

	.eval C64CharRamLocations.put($0000 + $8000, 0)
	.eval C64CharRamLocations.put($0800 + $8000, 1)
	.eval C64CharRamLocations.put($1000 + $8000, 2)
	.eval C64CharRamLocations.put($1800 + $8000, 3)
	.eval C64CharRamLocations.put($2000 + $8000, 4)
	.eval C64CharRamLocations.put($2800 + $8000, 5)
	.eval C64CharRamLocations.put($3000 + $8000, 6)
	.eval C64CharRamLocations.put($3800 + $8000, 7)

	.eval C64CharRamLocations.put($0000 + $C000, 0)
	.eval C64CharRamLocations.put($0800 + $C000, 1)
	.eval C64CharRamLocations.put($1000 + $C000, 2)
	.eval C64CharRamLocations.put($1800 + $C000, 3)
	.eval C64CharRamLocations.put($2000 + $C000, 4)
	.eval C64CharRamLocations.put($2800 + $C000, 5)
	.eval C64CharRamLocations.put($3000 + $C000, 6)
	.eval C64CharRamLocations.put($3800 + $C000, 7)

.macro BitsSet(bits, address) {
                lda #bits
                ora address
                sta address
}

.macro BitsUnset(bits, address) {
                lda #~(bits)
                and address
                sta address
}

.macro BitsSetA(address) {
                ora address
                sta address
}

.macro BitsUnsetA(address) {
		eor #$ff
                and address
                sta address
}


.macro BitSet(bitIndex, address) {
    BitsSet(1 << bitIndex, address)
}               

.macro BitUnset(bitIndex, address) {
    BitsUnset(1 << bitIndex, address)
}

.macro BitShift(bitLocation) {
	lda #1
	ldx bitLocation
	beq !done+
	clc
!shift:
	asl
	dex
	bne !shift-
!done:
}

.macro BitSetZP(bitLocation, address) {
	BitShift(bitLocation)
	BitsSetA(address)
}               

.macro BitUnsetZP(bitLocation, address) {
	BitShift(bitLocation)
	BitsUnsetA(address)
}

.macro SaveRegisters() {
                pha
                txa
                pha
                tya
                pha
}

.macro RestoreRegisters() {
                pla
                tay
                pla
                tax
                pla
}


////////// Taken from old ColorMode repo - not well tested

// $fb/$fc - L/H source address
// $fd/$fe - L/H destination address
// $4e/$4f - L/H size
.macro CopyMemoryZeroPageSize() {
   ldy #$00
   sty $50     // LSB size
   sty $51     // MSH size
!loop:
   lda $4f
   cmp $51
   beq !msb_match+
!copy:   
   lda ($fb),y 
	sta ($fd),y

   inc $50
   beq inc_msb
!cont:
   iny
   bne !loop-
!next:
   inc $fc 	// inc MSB source 
   inc $fe 	// inc MSB dest 
 	jmp !loop-

inc_msb:
   inc $51
   jmp !cont-

!msb_match:
   lda $4e
   cmp $50
   beq !done+
   jmp !copy-

!done:
}


// $fb/$fc - L/H source address
// $fd/$fe - L/H destination address
// $4e/$4f - L/H source end address
.macro CopyMemoryZeroPage() {
	ldy #$00
!comp:
   tya
   clc
   adc $fb
   bcs !overflow+

   cmp $4e
   bne !loop+
   ldx $fc
   cpx $4f
   beq !done+
   jmp !loop+

 !overflow:
   cmp $4e  // overflow with end address
   bne !loop+
   ldx $fc  
   inx
   cpx $4f
   beq !done+

!loop:
	lda ($fb),y 
	sta ($fd),y
   iny
 	bne !comp-  // next block
   inc $fc 	// inc MSB source 
   inc $fe 	// inc MSB dest 
   jmp !comp-

!done:
}

// Self modifying memory copy
.macro CopyMemorySelfModifying(source, dest, size)
{
	.const source_end = source + size
	ldx #$00
relative_source:
	lda source,x 
relative_dest:
	sta dest,x 
    inx

    cpx #<source_end   // LSB
 	bne fine

 check_again:
    lda relative_source+2 
    cmp #>source_end 
	beq done

fine:
    cpx #$00
 	bne relative_source  // next page

normal:
    inc relative_source+2
    inc relative_dest+2 
    lda relative_source+2

    cmp #>source_end
    bne relative_source

    cpx #<source_end
 	bne relative_source

done:
	// self modifying code - revert back for next time
	lda #>source
	sta relative_source+2
	lda #<source
	sta relative_source+1
	lda #>dest
	sta relative_dest+2
	lda #<dest
	sta relative_dest+1
}


.macro CopyMemoryPageAligned(source, dest, size)
{
  .const source_end = source + size//
   ldx #$00 

relative_source:
   lda source,x 
relative_dest:
	sta dest,x 
    inx 
 	bne relative_source

    inc relative_source+2 
    inc relative_dest+2 
    lda relative_source+2 
    cmp #>source_end 
    bne relative_source
}

// #importonce

// Profile routines mainly to ensure macros() aren't being called too much where instances should be created.
// As in, macros will often loop unwind which is memory inefficent if done multiple times.
.enum { ProfileSeverityUnknown, ProfileSeverityLow, ProfileSeverityMedium, ProfileSeverityHigh }

.var Profile = Hashtable()
.struct Profile_Struct { CallCount, Cost, Severity }

.macro Profile_New(profile, routine, struct) {
    .eval profile.put(routine, struct)
}

.macro Profile_Update(profile, routine) {
    .eval profile.get(routine).CallCount++
}

.macro Profile_Add(routine, cost)
{
    // .if (Profile.containsKey(routine) == false)
    //     Profile_New(routine, Profile_Struct(1, cost, ProfileSeverityUnknown))
    // else
    //     Profile_Update(routine)
}

.macro Profile_AddWithSeverity(routine, cost, severity)
{
    .define ht {
        .var ht = Profile.lock()
        .if (ht.containsKey(routine) == false)
            .eval ht.put(routine, Profile_Struct(1, cost, severity))//Profile_New(ht, routine, Profile_Struct(1, cost, severity))
        else
            .eval ht.get(routine).CallCount++
            // Profile_Update(ht, routine)
    // .if (Profile.containsKey(routine) == false)
    //     Profile_New(routine, Profile_Struct(1, cost, severity))
    // else
    //     Profile_Update(routine)
    }
}

.macro Profile_Print() {
    .print "Profile Results"
    .print "--------------- "
    // .define ht, keys {
        .var ht = Profile
        .var keys = ht.keys()
        // .for (var i = 0; i < keys.size() ; i++) {
        //     .var entry = ht.get(keys.get(i))
        //     .print " " + keys.get(i) + ": " + Debug_HexDec(entry.CallCount) + " [" + entry.Severity + "]"
        // }
    // }
}

    Profile_AddWithSeverity("Address_Load", !out+ - !in-, ProfileSeverityLow)
