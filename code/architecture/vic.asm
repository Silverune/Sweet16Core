// https://sta.c64.org/cbm64mem.html
// http://www.awsm.de/mem64/ 
// https://www.pagetable.com/c64ref/c64mem/

*=$d000 "VIC-II - video display" virtual

.namespace VIC {

    // $d000
    // Sprite #0 X-coordinate (only bits #0-#7).
    Sprite0XCoordinate:
        Address_Byte()

    // $d001
    // Sprite #0 Y-coordinate.
    Sprite0YCoordinate:
        Address_Byte()
    
    // $d002
    // Sprite #1 X-coordinate (only bits #0-#7).
    Sprite1XCoordinate:
        Address_Byte()

    // $d003
    // Sprite #1 Y-coordinate.
    Sprite1YCoordinate:
        Address_Byte()

    // $d004
    // Sprite #2 X-coordinate (only bits #0-#7).
    Sprite2XCoordinate:
        Address_Byte()

    // $d005
    // Sprite #2 Y-coordinate.
    Sprite2YCoordinate:
        Address_Byte()

    // $d006
    // Sprite #3 X-coordinate (only bits #0-#7).
    Sprite3XCoordinate:
        Address_Byte()

    // $d007
    // Sprite #3 Y-coordinate.
    Sprite3YCoordinate:
        Address_Byte()

    // $d008
    // Sprite #4 X-coordinate (only bits #0-#7).
    Sprite4XCoordinate:
        Address_Byte()

    // $d009
    // Sprite #4 Y-coordinate.
    Sprite4YCoordinate:
        Address_Byte()

    // $d00a
    // Sprite #5 X-coordinate (only bits #0-#7).
    Sprite5XCoordinate:
        Address_Byte()

    // $d00b
    // Sprite #5 Y-coordinate.
    Sprite5YCoordinate:
        Address_Byte()

    // $d00c
    // Sprite #6 X-coordinate (only bits #0-#7).
    Sprite6XCoordinate:
        Address_Byte()

    // $d00d
    // Sprite #6 Y-coordinate.
    Sprite6YCoordinate:
        Address_Byte()

    // $d00e
    // Sprite #7 X-coordinate (only bits #0-#7).
    Sprite7XCoordinate:
        Address_Byte()

    // $d00f
    // Sprite #7 Y-coordinate.
    Sprite7YCoordinate:
        Address_Byte()

    // $d010
    // Sprite #0-#7 X-coordinates (bit #8). Bits:
    // Bit #x: Sprite #x X-coordinate bit #8.
    Sprite0_7XCoordinates:
        Address_Byte()

    // $d011
    // Screen control register #1. Bits:
    // Bits #0-#2: Vertical raster scroll.
    // Bit #3: Screen height; 0 = 24 rows; 1 = 25 rows.
    // Bit #4: 0 = Screen off, complete screen is covered by border; 1 = Screen on, normal screen contents are visible.
    // Bit #5: 0 = Text mode; 1 = Bitmap mode.
    // Bit #6: 1 = Extended background mode on.
    // Bit #7: Read: Current raster line (bit #8).
    // Write: Raster line to generate interrupt at (bit #8).
    // Default: $1B, %00011011.
    ScreenControl1:
        Address_Byte()

    // $d012
    // Read: Current raster line (bits #0-#7).
    // Write: Raster line to generate interrupt at (bits #0-#7).
    RasterLine:
        Address_Byte()

    // $d013
    // Light pen X-coordinate (bits #1-#8). Read-only.
    LightPenXCoordinate:
        Address_Byte()

    // $d014
    // Light pen Y-coordinate. Read-only.
    LightPenYCoordinate:
        Address_Byte()

    // $d015
    // Sprite enable register. Bits:
    // Bit #x: 1 = Sprite #x is enabled, drawn onto the screen.
    SpriteEnable:
        Address_Byte()

    // $d016
    // Screen control register #2. Bits:
    // Bits #0-#2: Horizontal raster scroll.
    // Bit #3: Screen width; 0 = 38 columns; 1 = 40 columns.
    // Bit #4: 1 = Multicolor mode on.
    // Default: $C8, %11001000.
    ScreenControl2:
        Address_Byte()

    // $d017
    // Sprite double height register. Bits:
    // Bit #x: 1 = Sprite #x is stretched to double height.
    SpriteDoubleHeight:
        Address_Byte()

    // $d018
    // Memory setup register. Bits:
    // Bits #1-#3: In text mode, pointer to character memory (bits #11-#13), relative to VIC bank, memory address $DD00. Values:
    // %000, 0: $0000-$07FF, 0-2047.
    // %001, 1: $0800-$0FFF, 2048-4095.
    // %010, 2: $1000-$17FF, 4096-6143.
    // %011, 3: $1800-$1FFF, 6144-8191.
    // %100, 4: $2000-$27FF, 8192-10239.
    // %101, 5: $2800-$2FFF, 10240-12287.
    // %110, 6: $3000-$37FF, 12288-14335.
    // %111, 7: $3800-$3FFF, 14336-16383.
    // Values %010 and %011 in VIC bank #0 and #2 select Character ROM instead.
    // In bitmap mode, pointer to bitmap memory (bit #13), relative to VIC bank, memory address $DD00. Values:
    // %0xx, 0: $0000-$1FFF, 0-8191.
    // %1xx, 4: $2000-$3FFF, 8192-16383.
    // Bits #4-#7: Pointer to screen memory (bits #10-#13), relative to VIC bank, memory address $DD00. Values:
    // %0000, 0: $0000-$03FF, 0-1023.
    // %0001, 1: $0400-$07FF, 1024-2047.
    // %0010, 2: $0800-$0BFF, 2048-3071.
    // %0011, 3: $0C00-$0FFF, 3072-4095.
    // %0100, 4: $1000-$13FF, 4096-5119.
    // %0101, 5: $1400-$17FF, 5120-6143.
    // %0110, 6: $1800-$1BFF, 6144-7167.
    // %0111, 7: $1C00-$1FFF, 7168-8191.
    // %1000, 8: $2000-$23FF, 8192-9215.
    // %1001, 9: $2400-$27FF, 9216-10239.
    // %1010, 10: $2800-$2BFF, 10240-11263.
    // %1011, 11: $2C00-$2FFF, 11264-12287.
    // %1100, 12: $3000-$33FF, 12288-13311.
    // %1101, 13: $3400-$37FF, 13312-14335.
    // %1110, 14: $3800-$3BFF, 14336-15359.
    // %1111, 15: $3C00-$3FFF, 15360-16383.
    MemorySetup:
        Address_Byte()

    // $d019
    // Interrupt status register. Read bits:
    // Bit #0: 1 = Current raster line is equal to the raster line to generate interrupt at.
    // Bit #1: 1 = Sprite-background collision occurred.
    // Bit #2: 1 = Sprite-sprite collision occurred.
    // Bit #3: 1 = Light pen signal arrived.
    // Bit #7: 1 = An event (or more events), that may generate an interrupt, occurred and it has not been (not all of them have been) acknowledged yet.
    // Write bits:
    // Bit #0: 1 = Acknowledge raster interrupt.
    // Bit #1: 1 = Acknowledge sprite-background collision interrupt.
    // Bit #2: 1 = Acknowledge sprite-sprite collision interrupt.
    // Bit #3: 1 = Acknowledge light pen interrupt.
    InterruptStatus:
        Address_Byte()

    // $d01a
    // Interrupt control register. Bits:
    // Bit #0: 1 = Raster interrupt enabled.
    // Bit #1: 1 = Sprite-background collision interrupt enabled.
    // Bit #2: 1 = Sprite-sprite collision interrupt enabled.
    // Bit #3: 1 = Light pen interrupt enabled.
    InterruptControl:
        Address_Byte()

    // $d01b
    // Sprite priority register. Bits:
    // Bit #x: 0 = Sprite #x is drawn in front of screen contents; 1 = Sprite #x is behind screen contents.
    SpritePriority:
        Address_Byte()

    // $d01c
    // Sprite multicolor mode register. Bits:
    // Bit #x: 0 = Sprite #x is single color; 1 = Sprite #x is multicolor.
    SpriteMulticolorMode:
        Address_Byte()

    // $d01d
    // Sprite double width register. Bits:
    // Bit #x: 1 = Sprite #x is stretched to double width.
    SpriteDoubleWidth:
        Address_Byte()

    // $d01e
    // Sprite-sprite collision register. Read bits:
    // Bit #x: 1 = Sprite #x collided with another sprite.
    // Write: Enable further detection of sprite-sprite collisions.
    SpriteSpriteCollision:
        Address_Byte()

    // $d01f
    // Sprite-background collision register. Read bits:
    // Bit #x: 1 = Sprite #x collided with background.
    // Write: Enable further detection of sprite-background collisions.
    SpriteBackgroundCollision:
        Address_Byte()

    // $d020
    // Border color (only bits #0-#3).
    BorderColor:
        Address_Nybble()

    // $d021
    // Background color (only bits #0-#3).    
    BackgroundColor:
        Address_Nybble()

    // $d022
    // Extra background color #1 (only bits #0-#3).
    ExtraBackgroundColor1:
        Address_Nybble()

    // $d023
    // Extra background color #2 (only bits #0-#3).
    ExtraBackgroundColor2:
        Address_Nybble()

    // $d024
    // Extra background color #3 (only bits #0-#3).
    ExtraBackgroundColor3:
        Address_Nybble()

    // $d025
    // Sprite extra color #1 (only bits #0-#3).
    SpriteExtraColor1:
        Address_Nybble()

    // $d026
    // Sprite extra color #1 (only bits #0-#3).
    SpriteExtraColor2:
        Address_Nybble()

    // $d027
    // Sprite #0 color (only bits #0-#3).
    Sprite0Color:
        Address_Nybble()

    // $d028
    // Sprite #1 color (only bits #0-#3).
    Sprite1Color:
        Address_Nybble()

    // $d029
    // Sprite #2 color (only bits #0-#3).
    Sprite2Color:
        Address_Nybble()

    // $d02a
    // Sprite #3 color (only bits #0-#3).
    Sprite3Color:
        Address_Nybble()

    // $d02b
    // Sprite #4 color (only bits #0-#3).
    Sprite4Color:
        Address_Nybble()

    // $d02c
    // Sprite #5 color (only bits #0-#3).
    Sprite5Color:
        Address_Nybble()

    // $d02d
    // Sprite #6 color (only bits #0-#3).
    Sprite6Color:
        Address_Nybble()

    // $d02e
    // Sprite 7 color (only bits #0-#3).
    Sprite7Color:
        Address_Nybble()

    // $d02F-$D03F
    // unused
    Address_Bytes(17)

    // $d040-$D3ff
    // VIC-II register images (repeated every $40, 64 bytes).
    RegisterImages:
        Address_Bytes(960)  // $3c0
}

*=$d000 "I/O - Input / Output area" virtual

.namespace IO {
    // $D000-$DFFF
    // 53248-57343
    Area:
        Address_Pages(16)              // $1000 / 4096 bytes

}

*=$d000 "Character ROM" virtual

.namespace CharacterROM {
    // $D000-$DFFF
    // 53248-57343	
    // Character ROM, shape of characters (4096 bytes).
    ROM:
        Address_Pages(16)              // $1000 / 4096 bytes

    // $D000-$D7FF
    // 53248-55295	
    // Shape of characters in uppercase/graphics character set (2048 bytes, 256 entries).
    UppercaseGraphics:
        Address_Pages(8)              // $800 / 2048 bytes

    // $D800-$DFFF
    // 55295-57343	
    // Shape of characters in lowercase/uppercase character set (2048 bytes, 256 entries).
    LowercaseUppercase:
        Address_Pages(8)              // $800 / 2048 bytes
}