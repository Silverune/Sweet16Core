// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/
// http://sta.c64.org/cbm64krnfunc.html
// https://skoolkid.github.io/sk6502/c64rom/asm/EA31.html

*=$e000 "Kernal Jump" virtual
.namespace KernalJump {
    // NOTE: Labels come after the macro here is deliberate

    // Put current color, at memory address $0286, into color RAM, pointed at by memory addresses $00F3-$00F4.
    // Input: Y = Column number.
    // Output: –
    // Used registers: A.
        Address_WordAddr($E4DA)
    CurrentColor:

    // Fetch number of screen rows and columns.
    // Input: –
    // Output: X = Number of columns (40); Y = Number of rows (25).
    // Used registers: X, Y.
        Address_WordAddr($E505)
    ScreenRowsCols:

    // Save or restore cursor position.
    // Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor row (if Carry = 0); Y = Cursor column (if Carry = 0).
    // Output: X = Cursor row (if Carry = 1); Y = Cursor column (if Carry = 1).
    // Used registers: X, Y.
        Address_WordAddr($E50A)
    SaveRestoreCursorPosition:

    // Initialize VIC; restore default input/output to keyboard/screen; clear screen.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E518)	
    VicDefaultKeyboardScreenClear:

    // Clear screen.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E544)	
    ClearScreen:

    // Move cursor home, to upper left corner of screen.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E566)
    CursorHome:

    // Set pointer at memory addresses $00D1-$00D2 to current line in screen memory and pointer at memory addresses $00F3-$00F4 to current line in Color RAM, according to current cursor row, at memory address $00D6, and column, at memory address $00D3.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E56C)	
    PointToScreenMemory:

    // Initialize VIC; restore default input/output to keyboard/screen; move cursor home.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E59A)
    VicDefaultKeyboardScreenCursor:

    // Initialize VIC; restore default input/output to keyboard/screen.
    // Input: –
    // Output: –
    // Used registers: A, X.
        Address_WordAddr($E5A0)	
    VicDefaultKeyboardScreen:

    // Initialize VIC.
    // Input: –
    // Output: –
    // Used registers: A, X.
        Address_WordAddr($E5A8)
    VicInit:

    // Read byte from screen; if input line is empty, the cursor appears and a line of data is input.
    // Input: –
    // Output: A = Byte read.
    // Used registers: A.
        Address_WordAddr($E632)
    ReadScreen:

    // Check PETSCII code; if $22, quotation mark, then toggle quotation mode switch, at memory address $00D4.
    // Input: –
    // Output: –
    // Used registers: –
        Address_WordAddr($E684)
    QuotationToggle:

    // Recompute the high bytes of pointers to lines in screen memory, at memory addresses $00D9-$00F1.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E6B6)
    RecalculateScreenMemory:

    // Write byte to screen.
    // Input: A = Byte to write.
    // Output: –
    // Used registers: –
        Address_WordAddr($E716)
    WriteToScreen:

    // Check PETSCII code; if belongs to a color, set current color, at memory address $0286.
    // Input: –
    // Output: –
    // Used registers: A, X.
        Address_WordAddr($E8CB)
    SetCurrentColor:

    // Scroll complete screen upwards.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E8EA)
    ScreenScreenUpwards:

    // Insert line before current line and scroll lower part of screen downwards.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
        Address_WordAddr($E965)
    InsertLine:

    // Set pointer at memory addresses $00D1-$00D2 to current line in screen memory, fetching high byte from table at memory addresses $00D9-$00F1.
    // Input: X = Row number.
    // Output: –
    // Used registers: A.
        Address_WordAddr($E9F0)
    PointToCurrentLine:

    // Clear screen line.
    // Input: X = Row number.
    // Output: –
    // Used registers: A, Y.
        Address_WordAddr($E9FF)
    ClearScreenLine:

    // Write character and color onto screen; set cursor phase delay to 2.
    // Input: A = Character to write; X = Color to write.
    // Output: –
    // Used registers: A, Y.
        Address_WordAddr($EA13)
    WriteCharColToScreen:    

    // Set pointer at memory addresses $00F3-$00F4 to current line in Color RAM, according to pointer at memory addresses $00D1-$00D2 to current line in screen memory.
    // Input: –
    // Output: –
    // Used registers: –    
        Address_WordAddr($EA24)
    CurrentColorRam:

        Address_WordAddr($ea31)
    ISR: 

        Address_WordAddr($ea81)
    ISRExit:

        Address_WordAddr($eeb3)
    // TXA
    // LDX #$B8
    // !:
    // DEX
    // BNE !-   // $EEB6
    // TAX
    // RTS
    MillisecondDelay:
}

*=$ff81 "Kernal ROM" virtual
.namespace Kernal {
    .const step = 3

    // $FF81
    // SCINIT. Initialize VIC; restore default input/output to keyboard/screen; clear screen; set PAL/NTSC switch and interrupt timer.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
    // Real address: $FF5B.
    SCINIT:
        Address_Bytes(step)
	
    // $FF84
    // IOINIT. Initialize CIA's, SID volume; setup memory configuration; set and start interrupt timer.
    // Input: –
    // Output: –
    // Used registers: A, X.
    // Real address: $FDA3.
    IOINIT:
        Address_Bytes(step)

    // $FF87
    // RAMTAS. Clear memory addresses $0002-$0101 and $0200-$03FF; run memory test and set start and end address of BASIC work area accordingly; set screen memory to $0400 and datasette buffer to $033C.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
    // Real address: $FD50.
    RAMTAS:
        Address_Bytes(step)

    // $FF8A
    // RESTOR. Fill vector table at memory addresses $0314-$0333 with default values.
    // Input: –
    // Output: –
    // Used registers: –
    // Real address: $FD15.
    RESTOR:
        Address_Bytes(step)

    // $FF8D
    // VECTOR. Copy vector table at memory addresses $0314-$0333 from or into user table.
    // Input: Carry: 0 = Copy user table into vector table, 1 = Copy vector table into user table; X/Y = Pointer to user table.
    // Output: –
    // Used registers: A, Y.
    // Real address: $FD1A.        
    VECTOR:
        Address_Bytes(step)

    // $FF90
    // SETMSG. Set system error display switch at memory address $009D.
    // Input: A = Switch value.
    // Output: –
    // Used registers: –
    // Real address: $FE18.
    SETMSG:
        Address_Bytes(step)

    // $FF93
    // LSTNSA. Send LISTEN secondary address to serial bus. (Must call LISTEN beforehands.)
    // Input: A = Secondary address.
    // Output: –
    // Used registers: A.
    // Real address: $EDB9.
    LSTNSA:
        Address_Bytes(step)

    // $FF96
    // TALKSA. Send TALK secondary address to serial bus. (Must call TALK beforehands.)
    // Input: A = Secondary address.
    // Output: –
    // Used registers: A.
    // Real address: $EDC7.
    TALKSA:
        Address_Bytes(step)

    // $FF99
    // MEMBOT. Save or restore start address of BASIC work area.
    // Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).
    // Output: X/Y = Address (if Carry = 1).
    // Used registers: X, Y.
    // Real address: $FE25.
    MEMBOT:
        Address_Bytes(step)
	
    // $FF9C
    // MEMTOP. Save or restore end address of BASIC work area.
    // Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).
    // Output: X/Y = Address (if Carry = 1).
    // Used registers: X, Y.
    // Real address: $FE34.
    MEMTOP:
        Address_Bytes(step)

    // $FF9F
    // SCNKEY. Query keyboard; put current matrix code into memory address $00CB, current status of shift keys into memory address $028D and PETSCII code into keyboard buffer.
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
    // Real address: $EA87.
    SCNKEY:
        Address_Bytes(step)

    // $FFA2
    // SETTMO. Unknown. (Set serial bus timeout.)
    // Input: A = Timeout value.
    // Output: –
    // Used registers: –
    // Real address: $FE21.
    SETTMO:
        Address_Bytes(step)
	
    // $FFA5
    // IECIN. Read byte from serial bus. (Must call TALK and TALKSA beforehands.)
    // Input: –
    // Output: A = Byte read.
    // Used registers: A.
    // Real address: $EE13.
    IECIN:
        Address_Bytes(step)

    // $FFA8
    // IECOUT. Write byte to serial bus. (Must call LISTEN and LSTNSA beforehands.)
    // Input: A = Byte to write.
    // Output: –
    // Used registers: –
    // Real address: $EDDD.
    IECOUT:
        Address_Bytes(step)

    // $FFAB
    // UNTALK. Send UNTALK command to serial bus.
    // Input: –
    // Output: –
    // Used registers: A.
    // Real address: $EDEF.
    UNTALK:
        Address_Bytes(step)

    // $FFAE
    // UNLSTN. Send UNLISTEN command to serial bus.
    // Input: –
    // Output: –
    // Used registers: A.
    // Real address: $EDFE.
    UNLSTN:
        Address_Bytes(step)

    // $FFB1
    // LISTEN. Send LISTEN command to serial bus.
    // Input: A = Device number.
    // Output: –
    // Used registers: A.
    // Real address: $ED0C.
    LISTEN:
        Address_Bytes(step)

    // $FFB4
    // TALK. Send TALK command to serial bus.
    // Input: A = Device number.
    // Output: –
    // Used registers: A.
    // Real address: $ED09.
    TALK:
        Address_Bytes(step)

    // $FFB7
    // READST. Fetch status of current input/output device, value of ST variable. (For RS232, status is cleared.)
    // Input: –
    // Output: A = Device status.
    // Used registers: A.
    // Real address: $FE07.
    READST:
        Address_Bytes(step)

    // $FFBA
    // SETLFS. Set file parameters.
    // Input: A = Logical number; X = Device number; Y = Secondary address.
    // Output: –
    // Used registers: –
    // Real address: $FE00.
    SETLFS:
        Address_Bytes(step)

    // $FFBD
    // SETNAM. Set file name parameters.
    // Input: A = File name length; X/Y = Pointer to file name.
    // Output: –
    // Used registers: –
    // Real address: $FDF9.
    SETNAM:
        Address_Bytes(step)

    // $FFC0
    // OPEN. Open file. (Must call SETLFS and SETNAM beforehands.)
    // Input: –
    // Output: –
    // Used registers: A, X, Y.
    // Real address: ($031A), $F34A.
    OPEN:
        Address_Bytes(step)

    // $FFC3
    // CLOSE. Close file.
    // Input: A = Logical number.
    // Output: –
    // Used registers: A, X, Y.
    // Real address: ($031C), $F291.
    CLOSE:
        Address_Bytes(step)

    // $FFC6
    // CHKIN. Define file as default input. (Must call OPEN beforehands.)
    // Input: X = Logical number.
    // Output: –
    // Used registers: A, X.
    // Real address: ($031E), $F20E.
    CHKIN:
        Address_Bytes(step)

    // $FFC9
    // CHKOUT. Define file as default output. (Must call OPEN beforehands.)
    // Input: X = Logical number.
    // Output: –
    // Used registers: A, X.
    // Real address: ($0320), $F250.
    CHKOUT:
        Address_Bytes(step)
	
    // $FFCC
    // CLRCHN. Close default input/output files (for serial bus, send UNTALK and/or UNLISTEN); restore default input/output to keyboard/screen.
    // Input: –
    // Output: –
    // Used registers: A, X.
    // Real address: ($0322), $F333.
    CLRCHN:
        Address_Bytes(step)

    // $FFCF
    // CHRIN. Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)
    // Input: –
    // Output: A = Byte read.
    // Used registers: A, Y.
    // Real address: ($0324), $F157.
    CHRIN:
        Address_Bytes(step)

    // $FFD2
    // CHROUT. Write byte to default output. (If not screen, must call OPEN and CHKOUT beforehands.)
    // Input: A = Byte to write.
    // Output: –
    // Used registers: –
    // Real address: ($0326), $F1CA.
    CHROUT:
        Address_Bytes(step)
	
    // $FFD5
    // LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
    // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
    // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
    // Used registers: A, X, Y.
    // Real address: $F49E.
    LOAD:
        Address_Bytes(step)

    // $FFD8
    // SAVE. Save file. (Must call SETLFS and SETNAM beforehands.)
    // Input: A = Address of zero page register holding start address of memory area to save; X/Y = End address of memory area plus 1.
    // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1).
    // Used registers: A, X, Y.
    // Real address: $F5DD.
    SAVE:
        Address_Bytes(step)

    // $FFDB
    // SETTIM. Set Time of Day, at memory address $00A0-$00A2.
    // Input: A/X/Y = New TOD value.
    // Output: –
    // Used registers: –
    // Real address: $F6E4.
    SETTIM:
        Address_Bytes(step)

    // $FFDE
    // RDTIM. read Time of Day, at memory address $00A0-$00A2.
    // Input: –
    // Output: A/X/Y = Current TOD value.
    // Used registers: A, X, Y.
    // Real address: $F6DD.
    RDTIM:
        Address_Bytes(step)

    // $FFE1
    // STOP. Query Stop key indicator, at memory address $0091; if pressed, call CLRCHN and clear keyboard buffer.
    // Input: –
    // Output: Zero: 0 = Not pressed, 1 = Pressed; Carry: 1 = Pressed.
    // Used registers: A, X.
    // Real address: ($0328), $F6ED.
    STOP:
        Address_Bytes(step)

	// $FFE4
    // GETIN. Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)
    // Input: –
    // Output: A = Byte read.
    // Used registers: A, X, Y.
    // Real address: ($032A), $F13E.
    GETIN:
        Address_Bytes(step)

    // $FFE7
    // CLALL. Clear file table; call CLRCHN.
    // Input: –
    // Output: –
    // Used registers: A, X.
    // Real address: ($032C), $F32F.
    CLALL:
        Address_Bytes(step)

    // $FFEA
    // UDTIM. Update Time of Day, at memory address $00A0-$00A2, and Stop key indicator, at memory address $0091.
    // Input: –
    // Output: –
    // Used registers: A, X.
    // Real address: $F69B.
    UDTIM:
        Address_Bytes(step)

    // $FFED
    // SCREEN. Fetch number of screen rows and columns.
    // Input: –
    // Output: X = Number of columns (40); Y = Number of rows (25).
    // Used registers: X, Y.
    // Real address: $E505.
    SCREEN:
        Address_Bytes(step)

    // $FFF0
    // PLOT. Save or restore cursor position.
    // Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor column (if Carry = 0); Y = Cursor row (if Carry = 0).
    // Output: X = Cursor column (if Carry = 1); Y = Cursor row (if Carry = 1).
    // Used registers: X, Y.
    // Real address: $E50A.
    PLOT:
        Address_Bytes(step)

    // $FFF3
    // IOBASE. Fetch CIA #1 base address.
    // Input: –
    // Output: X/Y = CIA #1 base address ($DC00).
    // Used registers: X, Y.
    // Real address: $E500.
    IOBASE:
        Address_Bytes(step)

    // $FFF6-$FFF9
    // Unused
    Address_Bytes(4)

    // $FFFA-$FFFB    
    // 65530-65531
    // NMI vector   
    NMI:
        Address_Word()

    // $FFFC-$FFFD
    // 65532-65533
    // RESET vector    
    RESET:
        Address_Word()

    // $FFFE-$FFFF
    // 65534-65535
    // IRQ / BRK vector
    IRQ_BRK:
        Address_Word()
}