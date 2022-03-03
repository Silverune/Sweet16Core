// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

// "Unused" Zero Page locations if not using BASIC, however, does assume may want to use KERNAL
// None of these should overlap each other in Zb, Zw or Zm nor should be required at a specific address


// Zero Page contiguous memory buffers

.var zpAddress = $2;					// first KERNAL free Zero Page address

// .print "ZpVars starting: $" + toHexString(zpAddress)

Zm32: {
	.const allocationSize = 32

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	One:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Two:
}

Zm16: {
	.const allocationSize = 16

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	One:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Two:

	// if not using Zm16 as a whole block can reuse as variable additional variable storage
	.label W1 = Zm16.One 
	.label W2 = Zm16.One + 2 
	.label W3 = Zm16.One + 4
	.label W4 = Zm16.One + 6
	.label W5 = Zm16.One + 8
	.label W6 = Zm16.One + 10
	.label W7 = Zm16.One + 12
	.label W8 = Zm16.One + 14
	.label W9 = Zm16.Two
	.label WA = Zm16.Two + 2
	.label WB = Zm16.Two + 4
	.label WC = Zm16.Two + 6
	.label WD = Zm16.Two + 8
	.label WE = Zm16.Two + 10
	.label WF = Zm16.Two + 12
	.label WX = Zm16.Two + 14
}

Zqw: {
	.const allocationSize = 8

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// One:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Two:
}

Zdw: {
	.const allocationSize = 4

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	One:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Two:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Three:
}

Zw: {
	.const allocationSize = 2

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	One:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Two:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Three:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Four:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Five:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Six:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Seven:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Eight:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Nine:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Ten:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Eleven:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Twelve:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Thirteen:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Fourteen:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Fifteen:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Sixteen:
}

Zb: {
	.const allocationSize = 1
		
	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	One:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Two:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Three:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Four:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Five:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Six:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Seven:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Eight:

	Address_BytesAddr(zpAddress, allocationSize)
	.eval zpAddress += allocationSize;
	Nine:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Ten:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Eleven:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Twelve:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Thirteen:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Fourteen:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Fifteen:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Sixteen:

	// Address_BytesAddr(zpAddress, allocationSize)
	// .eval zpAddress += allocationSize;
	// Seventeen:
}
// .print "Final Address: $" + toHexString(zpAddress)