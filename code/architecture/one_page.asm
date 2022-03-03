// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

*=$0100 "One Page - Processor Stack" virtual
.namespace One {
    // $0100-$013E/256-318     Pointers to bytes read with error during datasette input (62 bytes, 31 entries).
    TapeInputErrorLog:
        Address_Bytes(63)       // $3f

    // $013F-$01FF/319-511     BASIC Stack Area
    BASICStack:
        Address_Bytes(193)     // $c1

    // $0100-$01FF/256-511     Processor stack. Also used for storing data related to FOR and GOSUB.
    Address_PageAddr($100)
    HardwareStackArea:
}