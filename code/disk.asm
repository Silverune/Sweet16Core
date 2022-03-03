#importonce
// https://codebase64.org/doku.php?id=base:loading_a_file
// Loads registers for calls to kernal load a file

.macro Disk_SetupLoadRegisters(filename, length) {
    ldx #<filename
    ldy #>filename
    lda length
}

// Assumes X / Y contains address of filename.   A contains length of filename
// On error calls error handler with A set to error:
// a = $05 (device not present)
// a = $04 (file not found)
// a = $1d (load error)
// a = $00 (break, run/stop has been pressed during loading)
.macro Disk_Load(errorHandler) {
    jsr Kernal.SETNAM
    lda #$01                        // logical number
    ldx Zero.CurrentDeviceNumber    // last used device number
    bne !skip+
    ldx #DEFAULT_DEVICE             // default
!skip:
    ldy #$01                         // $01 means: load to address stored in file
    jsr Kernal.SETLFS

    lda #$00                         // $00 means: load to memory (not verify)
    jsr Kernal.LOAD
    bcs errorHandler                 // if carry set, a load error has happened
}

.macro Disk_Load_Functor(errorHandlerPointer) {
    Disk_Load(!+)
    jmp !++
!:  // load errors will branch to here
    Address_FunctorA(errorHandlerPointer)
!:
}

// Loads file into memory at address passed to routine
// On error calls error handler with A set to error:
// a = $05 (device not present)
// a = $04 (file not found)
// a = $1d (load error)
// a = $00 (break, run/stop has been pressed during loading)
.macro Disk_LoadTo(destAddress, errorHandler) {
    jsr Kernal.SETNAM
    lda #$01                        // logical number
    ldx Zero.CurrentDeviceNumber    // last used device number
    bne !skip+
    ldx #DEFAULT_DEVICE             // default
!skip:
    ldy #$00                         // $00 means: load to new address
    jsr Kernal.SETLFS

    ldx #<destAddress
    ldy #>destAddress
    lda #$00                         // $00 means: load to memory (not verify)
    jsr Kernal.LOAD
    bcs errorHandler                 // if carry set, a load error has happened
}

.macro Disk_LoadToAddress(indirectAddress, errorHandler) {
    jsr Kernal.SETNAM
    lda #$01                        // logical number
    ldx Zero.CurrentDeviceNumber    // last used device number
    bne !skip+
    ldx #DEFAULT_DEVICE             // default
!skip:
    ldy #$00                         // $00 means: load to new address
    jsr Kernal.SETLFS
    Address_LoadIndirectXY(indirectAddress)
    lda #$00                         // $00 means: load to memory (not verify)
    jsr Kernal.LOAD
    bcs errorHandler                 // if carry set, a load error has happened
}

.macro Disk_LoadList(fileList, loadInstance) {
	.var offset = 0;
	.for (var i = 0; i < fileList.size(); i++) {
		Disk_SetupLoadRegisters(!filenames+ + offset, !lengths+ + i)        
		jsr loadInstance
		.eval offset += fileList.get(i).size()
	}
	jmp !done+
!filenames:
	.for (var i = 0; i < fileList.size(); i++) {
		.text fileList.get(i)
	}
!lengths:
	.for (var i = 0; i < fileList.size(); i++) {
		.byte fileList.get(i).size()
	}
!done:
}


.macro Disk_LoadListToAddress(fileList, addressList, loadToInstance, sourceAddress) {
	.var offset = 0;
	.for (var i = 0; i < fileList.size(); i++) {
        Address_Load(!addresses+ + (2*i), sourceAddress)
		Disk_SetupLoadRegisters(!filenames+ + offset, !lengths+ + i)
		jsr loadToInstance
		.eval offset += fileList.get(i).size()
	}
	jmp !done+
!filenames:
	.for (var i = 0; i < fileList.size(); i++) {
		.text fileList.get(i)
	}
!lengths:
	.for (var i = 0; i < fileList.size(); i++) {
		.byte fileList.get(i).size()
	}
!addresses:
	.for (var i = 0; i < addressList.size(); i++) {
		.word addressList.get(i)
	}
!done:
}
