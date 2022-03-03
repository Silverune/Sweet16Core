// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

*=$300 "Three Page" virtual
.namespace Three {
    
    // $0300-$0301
    // 768-769    
    // Execution address of warm reset, displaying optional BASIC error message and entering BASIC idle loop.
    // Default: $E38B.
    WarmReset:
        Address_Word()

    // $0302-$0303
    // 770-771
    // Execution address of BASIC idle loop.
    // Default: $A483.
    BasicIdle:
        Address_Word()

    // $0304-$0305
    // 772-773
    // Execution address of BASIC line tokenizater routine.
    // Default: $A57C.
    BasicLineTokenizater:
        Address_Word()

    // $0306-$0307
    // 774-775
    // Execution address of BASIC token decoder routine.
    // Default: $A71A.
    BasicTokenDecoder:
        Address_Word()

    // $0308-$0309
    // 776-777
    // Execution address of BASIC instruction executor routine.
    // Default: $A7E4.
    BasicInstructionExecutor:
        Address_Word()

    // $030A-$030B
    // 778-779
    // Execution address of routine reading next item of BASIC expression.
    // Default: $AE86.
    BasicNextItem:
        Address_Word()

    // $030C
    // 780
    // Default value of register A for SYS.
    // Value of register A after SYS.
    DefaultASys:
        Address_Byte()

    // $030D
    // 781
    // Default value of register X for SYS.
    // Value of register X after SYS.
    DefaultXSys:
        Address_Byte()

    // $030E
    // 782
    // Default value of register Y for SYS.
    // Value of register Y after SYS.
    DefaultYSys:
        Address_Byte()

    // $030F
    // 783
    // Default value of status register for SYS.
    // Value of status register after SYS.
    DefaultStatusSys:
        Address_Byte()

    // $0310-$0312
    // 784-786
    // JMP ABS machine instruction, jump to USR() function.
    // $0311-$0312, 785-786: Execution address of USR() function.
    JmpAbsUsr:
        Address_Bytes(3)

    // $0313
    // 787
    // unusued
    Address_Byte()

    // $0314-$0315
    // 788-789
    // Execution address of interrupt service routine.
    // Default: $EA31.
    InterruptServiceRoutine:
        Address_Word()

    // $0316-$0317
    // 790-791
    // Execution address of BRK service routine.
    // Default: $FE66.
    BRK:
        Address_Word()

    // $0318-$0319
    // 792-793
    // Execution address of non-maskable interrupt service routine.
    // Default: $FE47.
    NMI:
        Address_Word()

    // $031A-$031B
    // 794-795
    // Execution address of OPEN, routine opening files.
    // Default: $F34A.
    OPEN:
        Address_Word()

    // $031C-$031D
    // 796-797
    // Execution address of CLOSE, routine closing files.
    // Default: $F291.
    CLOSE:
        Address_Word()

    // $031E-$031F
    // 798-799
    // Execution address of CHKIN, routine defining file as default input.
    // Default: $F20E.
    CHKIN:
        Address_Word()

    // $0320-$0321
    // 800-801
    // Execution address of CHKOUT, routine defining file as default output.
    // Default: $F250.
    CHKOUT:
        Address_Word()

    // $0322-$0323
    // 802-803
    // Execution address of CLRCHN, routine initializating input/output.
    // Default: $F333.
    CLRCHN:
        Address_Word()

    // $0324-$0325
    // 804-805
    // Execution address of CHRIN, data input routine, except for keyboard and RS232 input.
    // Default: $F157.
    CHRIN:
        Address_Word()

    // $0326-$0327
    // 806-807
    // Execution address of CHROUT, general purpose data output routine.
    // Default: $F1CA.
    CHROUT:
        Address_Word()

    // $0328-$0329
    // 808-809
    // Execution address of STOP, routine checking the status of Stop key indicator, at memory address $0091.
    // Default: $F6ED.
    STOP:
        Address_Word()

    // $032A-$032B
    // 810-811
    // Execution address of GETIN, general purpose data input routine.
    // Default: $F13E.
    GETIN:
        Address_Word()

    // $032C-$032D
    // 812-813
    // Execution address of CLALL, routine initializing input/output and clearing all file assignment tables.
    // Default: $F32F.
    CLALL:
        Address_Word()

    // $032E-$032F
    // 814-815
    // Unused.
    // Default: $FE66.
    Address_Word()

    // $0330-$0331
    // 816-817
    // Execution address of LOAD, routine loading files.
    // Default: $F4A5.
    LOAD:
        Address_Word()

    // $0332-$0333
    // 818-819
    // Execution address of SAVE, routine saving files.
    // Default: $F5ED.
    SAVE:
        Address_Word()

    // $0334-$033B
    // 820-827
    // Unused (8 bytes).
    Address_Bytes(8)

    // $033C-$03FB
    // 828-1019
    // Datasette buffer (192 bytes).
    DatasetteBuffer:
        Address_Bytes(192)      // $c0

    // $03FC-$03FF
    // 1020-1023
    // Unused (4 bytes).
    Address_Bytes(4)
}