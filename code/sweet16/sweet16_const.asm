#importonce

.label Sweet16_ZP_BASE = Zm32.Two           // Start of 16 bit registers in zero page - needs to 32 bytes contiguous (16 2-byte registers)
.label Sweet16_SUBROUTINE_STACK = Zm16.Two  // Location for subroutine address stack

// Sweet16 relative register numbers
.label Sweet16_ACC = 0                      // Accumulator - used for ADD and SUB
.label Sweet16_ZP = 11			            // Extension - Zero Page location used by SETI
.label Sweet16_RSP = 12			            // Subroutine Return Pointer - initialized at entry
.label Sweet16_CPR = 13	                    // Compare instruction result
.label Sweet16_SR = 14                      // Stack Register - High order byte contains previous register index * 2.  LSBit is the carry flag
.label Sweet16_PC = 15			            // Program Counter
