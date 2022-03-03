// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

*=$00 "Zero Page" virtual

.namespace Zero {
	
	// $0000	0
	// Processor port data direction register. Bits:
	// 	Bit #x: 0 = Bit #x in processor port can only be read; 1 = Bit #x in processor port can be read and written.
	// 	Bits 6/7 undefined
	// Default: $2F, %00101111.
	ProcessorPortDataDirectionRegister:
		Address_Byte()

	// $0001
	// Processor port. Bits:
	// 	Bits #0-#2: Configuration for memory areas $A000-$BFFF, $D000-$DFFF and $E000-$FFFF. Values:
	// 	%x00: RAM visible in all three areas.
	// 	%x01: RAM visible at $A000-$BFFF and $E000-$FFFF.
	// 	%x10: RAM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
	// 	%x11: BASIC ROM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
	// 	%0xx: Character ROM visible at $D000-$DFFF. (Except for the value %000, see above.)
	// 	%1xx: I/O area visible at $D000-$DFFF. (Except for the value %100, see above.)
	// 	Bit #3: Datasette output signal level.
	// 	Bit #4: Datasette button status; 0 = One or more of PLAY, RECORD, F.FWD or REW pressed; 1 = No button is pressed.
	// 	Bit #5: Datasette motor control; 0 = On; 1 = Off.
	// 	Bits 6/7 undefined
	// Default: $37, %00110111.
	ProcessorPortRegister:
		Address_Byte()

#if IGNORE_BASIC
	// not using BASIC so no need to muddy ZP address space with unnecessary labels
	Address_Bytes($90-$2)
#else
	// $0002	2		Unused
		Address_Byte()

	// $0003	3	Pointer	Low Byte pointing to address 45482/$B1AA; a ROM routine for converting floating point numbers to integers
	// $0004	4	Pointer	High byte pointing to address 45482/$B1AA; a ROM routine for converting floating point numbers to integers
	// Unused - Default: $B1AA, execution address of routine converting floating point to integer.
	RomFloatToIntegerPointer:					
		Address_Word()	

	// $0005	5	Pointer	Low Byte pointing to 45969/$B391; a ROM routine for converting integer numbers to floating point format
	// $0006	6	Pointer	High byte pointing to 45969/$B391; a ROM routine for converting integer numbers to floating point format
	// Unused - Default: $B391, execution address of routine converting integer to floating point.
	RomIntegerToFloatPointer:
		Address_Word()		

	// $0007	7	Flag	Search character/temporary integer during INT, OR and AND
	// Byte being search for during various operations.
	// Current digit of number being input.
	// Low byte of first integer operand during AND and OR.
	// Low byte of integer-format FAC during INT().
	SearchCharTempIntegerFlag:				
		Address_Byte()

	// $0008	8	Flag	Scan for quote character at end of string during tokenization of BASIC commands.
	// Byte being search for during various operations.
	// Current byte of BASIC line during tokenization.
	// High byte of first integer operand during AND and OR.
	ScanQuoteEndOfStringFlag:
		Address_Byte()

	// $0009	9	Value	Cursor column position after last invocation of TAB or SPC
	// Current column number during SPC() and TAB().
	CursorColumnPosition:
		Address_Byte()

	// $000A	10	Flag	Sets condition for BASIC Interpreter function;
	// LOAD/VERIFY switch. Values:
	// 	$00: LOAD.
	// 	$01-$FF: VERIFY.
	SetBasicInterpreterFunctionFlag:
		Address_Byte()
		
	// $000B	11	Pointer	Input buffer pointer/number of subscripts for DIM, line length for tokenization
	// Current token during tokenization.
	// Length of BASIC line during insertion of line.
	// AND/OR switch; $00 = AND; $FF = OR.
	// Number of dimensions during array operations.
	InputBufferNumberPointer:
		Address_Byte()

	// $000C	12	Flag	Default size of array for DIM
	// Switch for array operations. Values:
	// 	$00: Operation was not called by DIM.
	// 	$40-$7F: Operation was called by DIM.
	DefaultArraySizeDimFlag:
		Address_Byte()

	// $000D	13	Flag	Variable type;
	// Current expression type. Values:
	// 	$00: Numerical.
	// 	$FF: String.
	VariableTypeFlag:
		Address_Byte()

	// $000E	14	Flag	Numeric variable type flag; 0 = floating-point, 128 = integer
	// Current numerical expression type. Bits:
	// 	Bit #7: 0 = Floating point; 1 = Integer.
	NumericVariableTypeFlag:
		Address_Byte()

	// $000F	15	Flag	For LIST, Garbarge Collection or tokenization
	// Quotation mode switch during tokenization; 
	// 	Bit #6: 0 = Normal mode; 1 = Quotation mode.
	// Quotation mode switch during LIST;
	//	 $01 = Normal mode; $FE = Quotation mode.
	// Garbage collection indicator during memory allocation for string variable; 
	// 	$00-$7F = There was no garbage collection yet; 
	// 	$80 = Garbage collection already took place.
	ListGarbageCollection:
		Address_Byte()

	// $0010	16	Flag	Discerns between user function call or array variable
	// Switch during fetch of variable name. Values:
	// 	$00: Integer variables are accepted.
	// 	$01-$FF: Integer variables are not accepted.
	UserFunctionOrArrayFlag:
		Address_Byte()

	// $0011	17	Flag	Discerns data entry method; 0 = INPUT, 64 = GET or 152 = READ
	// GET/INPUT/READ switch. Values:
	// 	$00: INPUT.
	// 	$40: GET.
	// 	$98: READ.
	DataEntryMethodFlag:
		Address_Byte()

	// $0012	18	Flag	Tracks sign of trigonometric function calls 
	// (255 in quadrant 2/3 for SIN or TAN or quadrant 1/2 for COS, 0 otherwise), or tracks comparison operator
	//  (1 = >, 2 = equals, 4 = <, is bit-field combination)
	// Sign during SIN() and TAN(). Values:
	// 	$00: Positive.
	// 	$FF: Negative.
	TrigSignFlag:
		Address_Byte()

	// $0013	19	Flag	Current input device number: 0 = Keyboard, 1 = Datassette, 2 = RS-232, 3 = Monitor, 4-7 = Printer, 8-31 = Floppy
	// Current I/O device number.
	// Default: $00, keyboard for input and screen for output.
	CurrentInputDeviceFlag:
		Address_Byte()

	// $0014	20	Pointer	Low Byte target line number for ON, GOTO, GOSUB and LIST, and address for PEEK, POKE and SYS
	// $0015	21	Pointer	High byte target line number for ON, GOTO, GOSUB and LIST, and address for PEEK, POKE and SYS
	// Line number during GOSUB, GOTO and RUN.
	// Second line number during LIST.
	// Memory address during PEEK, POKE, SYS and WAIT.
	TargetLineNumberPointer:
		Address_Word()

	// $0016	22	Pointer	Next available space in temporary string descriptor stack between addresses 25-33 ($0019-$0021)
	// Pointer to next expression in string stack. Values: $19; $1C; $1F; $22.
	// Default: $19.
	NextAvailableSpaceTempStringPointer:
		Address_Byte()

	// $0017	23	Pointer	last used temporary string address or string stack pointer; value = 3 less than the value at address 22 ($0016)
	// $0018	24	Pointer	last used temporary string address or string stack pointer; value = 0
	// Pointer to previous expression in string stack.
	TempStringAddressOrStackStringPointer:
		Address_Word()

	// $0019-$0021	25-33		temporary string stack: string length, start and end address of last used string
	// String stack, temporary area for processing string expressions (9 bytes, 3 entries).
	TempStringStack:
		Address_Bytes(9)

	// $0022-$0025	34-37	Pointer	utility pointer area for the BASIC interpreter
	// Temporary area for various operations (4 bytes).
	BasicInterpreterUtilityPointer:
		Address_Bytes(4)

	// $0026-$0029	38-41		floating result of multiplication or division
	// Auxiliary arithmetical register for division and multiplication (4 bytes).
	MultiplicationDivisionResult:
		Address_Bytes(4)

	// $002A	42	Unused
		Address_Byte()

	// $002B	43	Pointer	Low Byte TXTTAB, start of BASIC program text, default: 2049 / $0801
	// $002C	44	Pointer	High byte TXTTAB, start of BASIC program text, default: 2049 / $0801
	// Pointer to beginning of BASIC area.
	// Default: $0801, 2049.
	BasicStartPointer:
		Address_Word()

	// $002D	45	Pointer	Low Byte VARTAB, end of BASIC program text+1 / start of numeric variables
	// $002E	46	Pointer	High byte VARTAB, end of BASIC program text+1 / start of numeric variables
	// Pointer to beginning of variable area. (End of program plus 1.)
	NumericVariablesPointer:
		Address_Word()

	// $002F	47	Pointer	Low Byte ARYTAB, end of numeric Variables+1 / start of array variables
	// $0030	48	Pointer	High byte ARYTAB, end of numeric Variables+1 / start of array variables
	// Pointer to beginning of array variable area.
	ArrayVariablesStartPointer:
		Address_Word()

	// $0031	49	Pointer	Low Byte STREND, end of array variables+1 / lowest address for string stack
	// $0032	50	Pointer	High byte STREND, end of array variables+1 / lowest address for string stack
	// Pointer to end of array variable area.
	ArrayVariablesEndPointer:
		Address_Word()

	// $0033	51	Pointer	Low Byte FRETOP, top of string stack
	// $0034	52	Pointer	High byte FRETOP, top of string stack
	// Pointer to beginning of string variable area. (Grows downwards from end of BASIC area.)
	StringVariablesPointer:
		Address_Word()

	// $0035	53	Pointer	Low Byte FRESPC, utility pointer for strings
	// $0036	54	Pointer	High byte FRESPC, utility pointer for strings
	// Pointer to memory allocated for current string variable.
	CurrentStringVariablePointer:
		Address_Word()

	// $0037	55	Pointer	Low Byte MEMSIZ, highest BASIC RAM address / bottom of string stack
	// $0038	56	Pointer	High byte MEMSIZ, highest BASIC RAM address / bottom of string stack
	// Pointer to end of BASIC area.
	// Default: $A000, 40960.
	BasicEndPointer:
		Address_Word()

	// $0039	57	Pointer	Low Byte current BASIC line number
	// $003A	58	Pointer	High byte current BASIC line number
	// Current BASIC line number. Values:
	// 	$0000-$F9FF, 0-63999: Line number.
	// 	$FF00-$FFFF: Direct mode, no BASIC program is being executed.
	CurrentBasicLineNumberPointer:
		Address_Word()

	// $003B	59	Pointer	Low Byte previous BASIC line number for CONT after STOP
	// $003C	60	Pointer	High byte previous BASIC line number for CONT after STOP
	// Current BASIC line number for CONT.
	CurrentBasicLineNumberContPointer:
		Address_Word()

	// $003D	61	Pointer	Low Byte next BASIC statement for CONT
	// $003E	62	High byte next BASIC statement for CONT
	// Pointer to next BASIC instruction for CONT. Values:
	// 	$0000-$00FF: CONT'ing is not possible.
	// 	$0100-$FFFF: Pointer to next BASIC instruction.
	NextBasicStatementContPointer:
		Address_Word()

	// $003F	63		Low Byte current DATA line
	// $0040	64		High byte current DATA line
	// BASIC line number of current DATA item for READ.
	BasicCurrentLineNumberDataPointer:
		Address_Word()

	// $0041-$0042	65-66		next DATA item for READ
	// Pointer to next DATA item for READ.
	NextDataReadPointer:
		Address_Word()

	// $0043	67		temporary storage for INPUT
	// $0044	68		temporary storage for INPUT
	// Pointer to input result during GET, INPUT and READ.
	TempInputStoragePointer:
		Address_Word()

	// $0045	69		Name of variable to look up in variable table (VARNAM).
	// $0046	70		Name of variable to look up in variable table (VARNAM).
	// Name and type of current variable. Bits:
	// 	$0045 bits #0-#6: First character of variable name.
	// 	$0046 bits #0-#6: Second character of variable name; $00 = Variable name consists of only one character.
	// 	$0045 bit #7 and $0046 bit #7:
	// 	%00: Floating-point variable.
	// 	%01: String variable.
	// 	%10: FN function, created with DEF FN.
	// 	%11: Integer variable.
	NameTypeCurrentVariable:
		Address_Word()

	// $0047	71		VARNAM of current variable if integer; to descriptor if string
	// $0048	72		VARNAM of current variable if integer; to descriptor if string
	// Pointer to value of current variable or FN function.
	CurrentVariableFunctionPointer:
		Address_Word()

	// $0049	73		index variable of FOR ... NEXT loop
	// $004A	74		index variable of FOR ... NEXT loop
	// Pointer to value of current variable during LET.
	// Value of second and third parameter during WAIT.
	// Logical number and device number during OPEN.
	// $0049, 73: Logical number of CLOSE.
	// Device number of LOAD, SAVE and VERIFY.
	CurrentVariableLetPointer:
		Address_Word()

	// $004B	75		temporary storage for mathematical operations or TXTPTR during READ/GET/INPUT
	// $004C	76		temporary storage for mathematical operations or TXTPTR during READ/GET/INPUT
	// Temporary area for saving original pointer to current BASIC instruction during GET, INPUT and READ.
	TempStorageMathTxtPtr:
		Address_Word()

	// $004D	77		mask used during evaluation (FRMEVL) of <, >, =
	// Comparison operator indicator. Bits:
	// 	Bit #1: 1 = ">" (greater than) is present in expression.
	// 	Bit #2: 1 = "=" (equal to) is present in expression.
	// 	Bit #3: 1 = "<" (less than) is present in expression.
	ComparisonOperatorIndicator:
		Address_Byte()

	// $004E-$004F	78-79		temporary storage for FN or floating point value during FLPT
	// Pointer to current FN function.
	CurrentFnFunctionPointer:
		Address_Word()

	// $0050-$0051	80-81		strings
	// Pointer to current string variable during memory allocation.
	CurrentStringVariableMemoryAllocationPointer:
		Address_Word()

	// $0052	82		unused
		Address_Byte()

	// $0053	83		length of string variable during garbage collection
	// Step size of garbage collection. Values: $03; $07.
	GarbageCollectionStepSize:
		Address_Byte()

	// $0054	84	Constant	processor opcode "JMP absolute"; value = 76
	// JMP ABS machine instruction, jump to current BASIC function.
	JmpAboluteConstant:
		Address_Byte()

	// $0055-$0056	85-86		pointer during function evaluation
	// Execution address of current BASIC function.
	ExecutionAddressCurrentBasicFunction:
		Address_Word()

	// $0057-$005B	87-91		register for TAN (floating point accumulator (FAC) #3)
	// Arithmetic register #3 (5 bytes).
	ArithmeticRegister3:
		Address_Bytes(5)

	// $005C-$0060	92-96		register for TAN (FAC #4)
	// Arithmetic register #4 (5 bytes).
	ArithmeticRegister4:
		Address_Bytes(5)

	// $0061	97		floating point accumulator (FAC) #1 exponent
	FAC1Exponent:
		Address_Byte()
		
	// $0062	98		floating point accumulator (FAC) #1 mantissa
	// $0063	99		floating point accumulator (FAC) #1 mantissa
	// $0064	100		floating point accumulator (FAC) #1 mantissa
	// $0065	101		floating point accumulator (FAC) #1 mantissa
	FAC1Mantissa:
		Address_Bytes(4)

	// $0066	102		floating point accumulator (FAC) #1 sign
	// Sign of FAC. Bits:
	// 	Bit #7: 0 = Positive; 1 = Negative.
	FAC1Sign:
		Address_Byte()

	// $0067	103		number of terms in series evaluation
	NumTermsSeriesEvaluation:
		Address_Byte()

	// $0068	104		FAC #1: bit overflow area during normalization
	FAC1BitOverflow:
		Address_Byte()

	// $0069	105		floating point accumulator (FAC) #2 exponent
	FAC2Exponent:
		Address_Byte()

	// $006A	106		floating point accumulator (FAC) #2 mantissa
	// $006B	107		floating point accumulator (FAC) #2 mantissa
	// $006C	108		floating point accumulator (FAC) #2 mantissa
	// $006D	109		floating point accumulator (FAC) #2 mantissa
	FAC2Mantissa:
		Address_Bytes(4)

	// $006E	110		floating point accumulator (FAC) #2 sign
	FAC2Sign:
		Address_Byte()

	// $006F	111	Flag	result of signed comparison between FAC #1 and FAC #2: 0 = equal signs, 255 = different signs
	SignedComparison:
		Address_Byte()

	// $0070	112		FAC #2: low byte of FAC #1 mantissa during rounding if mantissa bigger longer than four bytes
	FAC2LowByte:
		Address_Byte()

	// $0071-$0072	113-114	Pointer	to temporary table during series evaluation
	SeriesEvaluationTempTable:
		Address_Word()

	// $0073-$008A	115-138		CHRGET routine: fetches next character of BASIC program text
	CHRGETRoutine:
		Address_Bytes(24)			// $18

	// $008B-$008F	139-143		seed stored by last invocation of RND
	RNDSeed:
		Address_Bytes(5)
#endif

	// $0090	144		KERNAL I/O STATUS indicates end of file if bit 6 is set
	KernalIOStatus:
		Address_Byte()

	// $0091	145	Flag	127 = STOP , 223 = C= , 239 = SPACE , 251 = CTRL , 255 = no key pressed
	KeyboardFlag:
		Address_Byte()

	// $0092	146		constant for timing of cassette reads
	TimingCassetteReadConstant:
		Address_Byte()

	// $0093	147	Flag	KERNAL LOAD routine: 0 = LOAD, 1 = VERIFY
	KernalLoadVerify:
		Address_Byte()

	// $0094	148	Flag	character waiting in serial bus output register
	SerialBusOutputCharWaiting:
		Address_Byte()

	// $0095	149		serial bus output register
	SerialBusOutput:
		Address_Byte()

	// $0096	150		cassette block synchronisation number
	CassetteBlockSync:
		Address_Byte()

	// $0097	151		temporary storage for X register
	TempX:
		Address_Byte()

	// $0098	152		number of open I/O file; pointer to top of file table (see addresses 601-631)
	NumOpenIOFiles:
		Address_Byte()

	// $0099	153		current input device: defaults to 0 = keyboard
	CurrentInputDevice:
		Address_Byte()

	// $009A	154		current output device for CMD: defaults to 3 = screen
	CurrentOutputDevice:
		Address_Byte()

	// $009B	155		cassette parity byte
	CassetteParityByte:
		Address_Byte()

	// $009C	156	Flag	tape byte received
	TapeByteReceived:
		Address_Byte()

	// $009D	157	Flag	KERNAL message display control: bit 6 = error messages, bit 7 = control message
	KernalMessageDisplayControl:
		Address_Byte()

	// $009E	158		cassette read pass 1 error log
	CassetteReadPass1ErrorLog:
		Address_Byte()

	// $009F	159		cassette read pass 2 error log
	CassetteReadPass2ErrorLog:
		Address_Byte()

	// $00A0-$00A2	160-162		software jiffy clock, updated by KERNAL IRQ every 1/60 second
	JiffyClock:
		Address_Bytes(3)

	// $00A3-$00A4	163-164		bit counter for serial bus / cassette I/O (EOI)
	BitCounter:
		Address_Word()

	// $00A5	165		cassette synchronization byte counter
	CassetteSyncByteCounter:
		Address_Byte()

	// $00A6	166		number of characters in cassette I/O buffer
	CassetteBufferIOCount:
		Address_Byte()

	// $00A7	167		temporary RS-232 / cassette read data register
	TempRS232ReadData:
		Address_Byte()

	// $00A8	168	Counter	RS-232 input bits received / flag: cassette read error
	CounterRS232InputBits:
		Address_Byte()

	// $00A9	169	Flag	RS-232 start bit 0 = received, 144 = not received
	RS232StartBit:
		Address_Byte()

	// $00AA	170		rs-232 input byte buffer / flag: cassette read character sync/data
	RS232InputByte:
		Address_Byte()

	// $00AB	171		rs-232 input parity/cassette leader counter
	RS232InputParity:
		Address_Byte()

	// $00AC	172	Pointer	to the starting address of a load / screen scrolling temporary storage
	// $00AD	173	Pointer	to the starting address of a load / screen scrolling temporary storage
	LoadScreenScrollingTempStorage:
		Address_Word()

	// $00AE	174	Pointer	to end address of LOAD/VERIFY/SAVE
	// $00AF	175	Pointer	to end address of LOAD/VERIFY/SAVE
	EndAddressOfLoadVerifySave:
		Address_Word()

	// $00B0	176		pointer to constant for timing of cassette reads (default: 146)
	// $00B1	177		pointer to constant for timing of cassette reads (default: 146)
	ConstantTimingCassetteReads:
		Address_Word()

	// $00B2	178	Pointer	to start of cassette buffer
	// $00B3	179	Pointer	to start of cassette buffer
	CassetteBuffer:
		Address_Word()

	// $00B4	180		RS-232 output bit counter / cassette ready to read next byte
	RSR232OutputBitCounter:
		Address_Byte()

	// $00B5	181		next output bit / cassette read block byte counter
	CassetteReadBlockByteCounter:
		Address_Byte()

	// $00B6	182		output buffer
	OutputBuffer:
		Address_Byte()

	// $00B7	183		length of current file name
	CurrentFilenameLength:
		Address_Byte()

	// $00B8	184		current logical file number
	CurrentLogicalFileNumber:
		Address_Byte()

	// $00B9	185		current secondary address
	CurrentSecondaryAddress:
		Address_Byte()

	// $00BA	186		current device number
	CurrentDeviceNumber:
		Address_Byte()

	// $00BB	187	Pointer	to current file name
	// $00BC	188	Pointer	to current file name
	PointerToCurrentFilename:
		Address_Word()

	// $00BD	189		RS-232 output parity / temporary cassette read/write register
	RS232OutputParity:
		Address_Byte()

	// $00BE	190		cassette read/write duplicate block counter
	CassetteReadWriteDuplicateBlockCounter:
		Address_Byte()

	// $00BF	191		cassette read byte register
	CassetteReadByte:
		Address_Byte()

	// $00C0	192	Flag	cassette motor 0 = off, 1 = on
	CassetteMotor:
		Address_Byte()

	// $00C1	193		start address for LOAD / SAVE
	// $00C2	194		start address for LOAD / SAVE
	LoadSaveStart:
		Address_Word()
		
	// $00C3	195		end address for LOAD / SAVE
	// $00C4	196		end address for LOAD / SAVE
	LoadSaveEnd:
		Address_Word()

	// $00C5	197		matrix coordinate of last pressed key, 64 = none
	LastKeyPressed:
		Address_Byte()

	// $00C6	198		number of characters in keyboard buffer
	KeyboardBufferCount:
		Address_Byte()

	// $00C7	199	Flag	print reverse characters, default 0 = normal
	PrintReverseCharacters:
		Address_Byte()

	// $00C8	200	Pointer	last column of current line during INPUT
	InputLastColumn:
		Address_Byte()

	// $00C9	201	Pointer	x coordinate of cursor during INPUT
	InputCursorXCoordinate:
		Address_Byte()

	// $00CA	202		y coordinate of cursor during INPUT
	InputCursorYCoordinate:
		Address_Byte()

	// $00CB	203		index to keyboard decoding table for currently pressed key, 64 = no key was depressed
	KeyboardDecodingIndex:
		Address_Byte()

	// $00CC	204	Flag	flash cursor 0 = yes, other no
	CursorFlash:
		Address_Byte()

	// $00CD	205		counter for cursor flashing, default 20, decreased every jiffy
	CursorFlashCount:
		Address_Byte()

	// $00CE	206		character at cursor position
	CursorCharacter:
		Address_Byte()

	// $00CF	207	Flag	cursor flash phase 0 = visible, >0 invisible
	CursorFlashPhase:
		Address_Byte()

	// $00D0	208	Flag	input from 0 = keyboard or 3 = screen
	Input:
		Address_Byte()

	// $00D1	209	Pointer	memory address of current screen line
	// $00D2	210	Pointer	memory address of current screen line
	CurrentScreenLine:
		Address_Word()

	// $00D3	211		Column of cursor in current logical line, used by SPC(
	CursorLogicalColumn:
		Address_Byte()

	// $00D4	212	Flag	quote mode, >0 = editor is in quote mode, i.e. control characters are printed as reverse graphic characters
	QuoteMode:
		Address_Byte()

	// $00D5	213		Maximum length of logical screen line
	LogicalScreenLineMaxLength:
		Address_Byte()

	// $00D6	214		Current physical line number of cursor
	CursorPhysicalLineNumber:
		Address_Byte()

	// $00D7	215		ASCII value of last printed character
	LastPrintedASCII:
		Address_Byte()

	// $00D8	216	Flag	Insert mode, if > 0 puts editor in quote mode (see address 212 ($00D4))
	InsertMode:
		Address_Byte()

	// $00D9-$00F2	217-242		screen line link table / temporary storage for editor; 25 bytes, one byte for each screen line: bit 0…3 index to page in screen RAM, used with address 209; bit 7 indicates the logical line is longer than 40 characters, one physical line.
	ScreenLineLinkTable:
		Address_Bytes(26)			// $1a

	// $00F3	243	Pointer	To first address in Color RAM of current screen line
	// $00F4	244	Pointer	To first address in Color RAM of current screen line
	ColorRAMCurrentScreenLine:
		Address_Word()

	// $00F5	245	Pointer	To the keyboard decoding table
	// $00F6	246	Pointer	To the keyboard decoding table
	KeyboardDecodingTable:
		Address_Word()

	// $00F7	247	Pointer	To RS-232 input buffer
	// $00F8	248	Pointer	To RS-232 input buffer
	RS232InputBuffer:
		Address_Word()
		
	// $00F9	249	Pointer	To RS-232 output buffer
	// $00FA	250	Pointer	To RS-232 output buffer
	RS232OutputBuffer:
		Address_Word()

	// $00FB	251		Unused
	// $00FC	252		Unused
	// $00FD	253		Unused
	// $00FE	254		Unused
		Address_Bytes(4)

	// $00FF-$010A 255-266 Buffer for conversion from floating point to string (12 bytes.)
	BASICFloatingPoint2ASCII:
		Address_Bytes(12)		// $c
}