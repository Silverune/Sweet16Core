#importonce

.function Petscii_Reverse(code) {
    .return code + 128
}

.function Petscii_Set2_Offset(code) {
    .return code + 64
}

.namespace Petscii_Set2 { 
    .label TICK = Petscii_Set2_Offset(ScreenCode_Set2.TICK)       
}

// these values taken directly from the C64 Programmer's Reference Guide
.namespace ScreenCode_Set2 { 
    .label TICK = $7a
}