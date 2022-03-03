// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

*=$0200 "Two Page" virtual
.namespace Two {

	// $0200-$0258/512-600     BASIC Input Buffer (Input Line from Screen)
	BASICInputBuffer:
		Address_Bytes(89)		// $59

	// $0259-$0262/601-610     Active logical File numbers
	ActiveLogicalFileNumbers:
		Address_Bytes(10)		// $a

	// $0263-$026C/611-620     Active File First Addresses (Device numbers)
	ActiveFileFirstAddress:
		Address_Bytes(10)		// $a

	// $026D-$0276/621-630     Active File Secondary Addresses
	ActiveFileSecondaryAddress:
		Address_Bytes(10)		// $a

	// $0277-$0280/631-640     Keyboard Buffer Queue (FIFO)
	KeyboardBufferQueue:
		Address_Bytes(10)		// $aa

	// $0281-$0282/641-642     Pointer to beginning of BASIC area after memory test. Default: $0800, 2048.
	MemoryBottom:
		Address_Word()

	// $0283-$0284/643-644     Pointer to end of BASIC area after memory test.  Default: $A000, 40960.
	MemoryTop:
		Address_Word()

	// $0285/645               Serial IEEE Bus timeout defeat Flag
	SerialBusTimeout:
		Address_Byte()

	// $0286/646               Current color, cursor color. Values: $00-$0F, 0-15.
	CurrentCharColor:
		Address_Nybble()

	// $0287/647               Color of character under cursor. Values: $00-$0F, 0-15.
	BackgroundColorUnderCursor:
		Address_Nybble()

	// $0288/648               High byte of pointer to screen memory for screen input/output.  Default: $04, $0400, 1024.
	ScreenMemoryAddressHighByte:
		Address_Byte()

	// $0289/649               Maximum length of keyboard buffer. Values:
	// $00, 0: No buffer.
	// $01-$0F, 1-15: Buffer size.
	KeyboardBufferMaxBytes:
		Address_Byte()

	// $028A/650               Flag: Repeat keys
	// Bits #6-#7: %00 = Only cursor up/down, cursor left/right, Insert/Delete and Space repeat; %01 = No key repeats; %1x = All keys repeat.
	RepeatKeys:
		Address_Byte()

	// $028B/651               Delay counter during repeat sequence, for delaying between successive repeats. Values:
	// $00, 0: Must repeat key.
	// $01-$04, 1-4: Delay repetition.	
	RepeatKeySpeedCounter:
		Address_Byte()

	// $028C/652               Repeat sequence delay counter, for delaying before first repetition. Values:
	// $00, 0: Must start repeat sequence.
	// $01-$10, 1-16: Delay repeat sequence.	
	RepeatKeyFirstRepeatDelay:
		Address_Byte()

	// $028D/653               Shift key indicator. Bits:
	// Bit #0: 1 = One or more of left Shift, right Shift or Shift Lock is currently being pressed or locked.
	// Bit #1: 1 = Commodore is currently being pressed.
	// Bit #2: 1 = Control is currently being pressed.	
	ShiftKeys:
		Address_Byte()

	// $028E/654               Previous value of shift key indicator. Bits:
	// Bit #0: 1 = One or more of left Shift, right Shift or Shift Lock was pressed or locked at the time of previous check.
	// Bit #1: 1 = Commodore was pressed at the time of previous check.
	// Bit #2: 1 = Control was pressed at the time of previous check.	
	LastShiftKey:
		Address_Byte()

	// $028F-$0290/655-656     Execution address of routine that, based on the status of shift keys, sets the pointer at memory address $00F5-$00F6 to the appropriate conversion table for converting keyboard matrix codes to PETSCII codes.
	// Default: $EB48.
	KeyboardTable:
		Address_Word()

	// $0291/657               Commodore-Shift switch. Bits
	// Bit #7: 0 = Commodore-Shift is disabled; 1 = Commodore-Shift is enabled, the key combination will toggle between the uppercase/graphics and lowercase/uppercase character set.	
	UpperLowerCase:
		Address_Byte()

	// $0292/658               Scroll direction switch during scrolling the screen. Values:
	// $00: Insertion of line before current line, current line and all lines below it must be scrolled 1 line downwards.
	// $01-$FF: Bottom of screen reached, complete screen must be scrolled 1 line upwards.	
	AutoScrollDown:
		Address_Byte()

	// $0293/659               RS232 control register. Bits:
	// Bits #0-#3: Baud rate, transfer speed. Values:
	// %0000: User specified.
	// %0001: 50 bit/s.
	// %0010: 75 bit/s.
	// %0011: 110 bit/s.
	// %0100: 150 bit/s.
	// %0101: 300 bit/s.
	// %0110: 600 bit/s.
	// %0111: 1200 bit/s.
	// %1000: 2400 bit/s.
	// %1001: 1800 bit/s.
	// %1010: 2400 bit/s.
	// %1011: 3600 bit/s.
	// %1100: 4800 bit/s.
	// %1101: 7200 bit/s.
	// %1110: 9600 bit/s.
	// %1111: 19200 bit/s.
	// Bits #5-#6: Byte size, number of data bits per byte; %00 = 8; %01 = 7, %10 = 6; %11 = 5.
	// Bit #7: Number of stop bits; 0 = 1 stop bit; 1 = 2 stop bits.	
	RS232Control:
		Address_Byte()

	// $0294/660               RS232 command register. Bits:
	// Bit #0: Synchronization type; 0 = 3 lines; 1 = X lines.
	// Bit #4: Transmission type; 0 = Duplex; 1 = Half duplex.
	// Bits #5-#7: Parity mode. Values:
	// %xx0: No parity check, bit #7 does not exist.
	// %001: Odd parity.
	// %011: Even parity.
	// %101: No parity check, bit #7 is always 1.
	// %111: No parity check, bit #7 is always 0.	
	RS232Command:
		Address_Byte()

	// $0295-$0296/661-662     Default value of RS232 output timer, based on baud rate. (Must be filled with actual value before RS232 input/output if baud rate is "user specified" in RS232 control register, memory address $0293.)
	RS232NonStandardBits:
		Address_Word()

	// $0297/663               Value of ST variable, device status for RS232 input/output. Bits:
	// Bit #0: 1 = Parity error occurred.
	// Bit #1: 1 = Frame error, a stop bit with the value of 0, occurred.
	// Bit #2: 1 = Input buffer underflow occurred, too much data has arrived but it has not been read from the buffer in time.
	// Bit #3: 1 = Input buffer is empty, nothing to read.
	// Bit #4: 0 = Sender is Clear To Send; 1 = Sender is not ready to send data to receiver.
	// Bit #6: 0 = Receiver reports Data Set Ready; 1 = Receiver is not ready to receive data.
	// Bit #7: 1 = Carrier loss, a stop bit and a data byte both with the value of 0, detected.	
	RS232Status:
		Address_Byte()
		
	// $0298/664               RS232 byte size, number of data bits per data byte, default value for bit counters.
	RS232BitsToSend:
		Address_Byte()

	// $0299-$029A/665-666     Default value of RS232 input timer, based on baud rate. (Calculated automatically from default value of RS232 output timer, at memory address $0295-$0296.)
	RS232BaudRate:
		Address_Word()

	// $029B/667               Offset of byte received in RS232 input buffer.
	RS232InputBufferEnd:
		Address_Byte()

	// $029C/668               Offset of current byte in RS232 input buffer.
	RS232InputBufferHighByte:
		Address_Byte()

	// $029D/669               Offset of byte to send in RS232 output buffer.
	RS232OutputBifferHighByte:
		Address_Byte()

	// $029E/670               Offset of current byte in RS232 output buffer.
	RS232OutputBufferEnd:
		Address_Byte()

	// $029F-$02A0/671-672     Temporary area for saving pointer to original interrupt service routine during datasette input output. Values:
	// $0000-$00FF: No datasette input/output took place yet or original pointer has been already restored.
	// $0100-$FFFF: Original pointer, datasette input/output currently in progress.
	IRQVectorTapeIO:
		Address_Word()

	// $02A1/673               Temporary area for saving original value of CIA#2 interrupt control register, at memory address $DD0D, during RS232 input/output.
	RS232Enables:
		Address_Byte()

	// $02A2/674               Temporary area for saving original value of CIA#1 timer #1 control register, at memory address $DC0E, during datasette input/output.
	TapeIOSenseTOD:
		Address_Byte()

	// $02A3/675               Temporary storage during Tape READ
	TapeREADStore:
		Address_Byte()

	// $02A4/676               Temporary D1IRQ Indicator during Tape READ
	D1IRQREADIndicator:
		Address_Byte()

	// $02A5/677               Temporary for Line Index
	LineIndex:
		Address_Byte()

	// $02A6/678               PAL/NTSC switch, for selecting RS232 baud rate from the proper table. Values:
	// $00: NTSC.
	// $01: PAL.	
	TVStandard:
		Address_Byte()

	// $02A7-$02FF / 679-767    Unused (89 bytes).
		Address_Bytes(89)		// $59
}