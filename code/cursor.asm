#importonce

.macro Cursor_StoreKernal(cursorWordAddress) {
	sec											// set to "save"
	jsr KernalJump.SaveRestoreCursorPosition	// fetch current position (X get ROW, Y get COL)
	stx cursorWordAddress
	sty cursorWordAddress + 1
}

.macro Cursor_RestoreKernal(cursorWordAddress) {
	ldx cursorWordAddress
	ldy cursorWordAddress + 1	
	clc											// set to "restore"
	jsr KernalJump.SaveRestoreCursorPosition	// set current position (X get ROW, Y get COL)
}

.macro Cursor_StoreRom(cursorWordAddress) {
	ldx Zero.CursorLogicalColumn
	stx cursorWordAddress
	ldx Zero.CursorPhysicalLineNumber
	stx cursorWordAddress + 1
}

.macro Cursor_RestoreRom(cursorWordAddress) {
	Cursor_RowColumn(cursorWordAddress, cursorWordAddress+1)
}

// sets the register - still requires kernal call
.macro Cursor_SetRowRegister(row) {
	lda #row
	sta Zero.CursorLogicalColumn
}

// sets the register - still requires kernal call
.macro Cursor_SetColumnRegister(column) {
	lda #column
	sta Zero.CursorPhysicalLineNumber
}

.macro Cursor_RowColumn(row, column) {
	Cursor_SetRowRegister(row)
	Cursor_SetColumnRegister(column)
	jsr KernalJump.PointToScreenMemory
}

.macro CursorRow(row) {
	Cursor_SetRowRegister(row)
	jsr KernalJump.PointToScreenMemory
}

.macro Cursor_Column(column) {
	Cursor_SetColumnRegister(column)
	jsr KernalJump.PointToScreenMemory
}