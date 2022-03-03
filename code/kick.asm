#importonce

.function Kick_FormatFilename(name, border) {
    .return Kick_FormatFilename(name, border, " ")
}

.function Kick_FormatFilename(name, border, spacer) {
    .return Kick_FormatFilename(name, border, spacer, 999)
}

.function Kick_FormatFilename(name, border, spacer, lengthOverride) {
    .const dumpDebug = false;
    .const totalLength = 16
    .var length = min(totalLength, lengthOverride)
    .eval spacer = spacer.charAt(0)
    .var toFill = length - name.size() - border.size() * 2    
    .errorif (name.size() + border.size() * 2 > length), "Name too long, must be less than " + (length + border.size() * 2).string()
    
    .var retval = border;
    .var left = mod(toFill, 2) + floor(toFill / 2);
    .var right = floor(toFill / 2);
    .for (var i = 0; i < left; i++) {
        .eval retval += spacer
    }
    .eval retval = retval + name.toUpperCase()
    .for (var i = 0; i < right; i++) {
        .eval retval += spacer
    }
    .eval retval += border;
    
    .if (dumpDebug) {
    .print "[" + retval + "] " + retval.size()
    }
    .return retval
}

// ensures that the string is encoded in the specified format
.macro Kick_PetsciiAscii(str) {
    .encoding "ascii"
	.text str
}

.macro Kick_PetsciiMixed(str) {
    .encoding "petscii_mixed"
	.text str
}

.macro Kick_PetsciiUpper(str) {
    .encoding "petscii_upper"
	.text str
}

.macro Kick_ScreencodeMixed(str) {
    .encoding "screencode_mixed"
	.text str
}

.macro Kick_ScreencodeUpper(str) {
    .encoding "screencode_upper"
	.text str
}

.function Kick_CommaSerialize(list) {
    .var serialized = ""
    .for (var i = 0; i < list.size(); i++) {
        .if (i != 0)
            .eval serialized += ", "
        .eval serialized += list.get(i)
    }
    .return serialized
}

// if the Kick char is lowercase converts to uppercase
.function Kick_CharToUpper(char) {
    .const alphabetOffset = 'A' - 'a'
    .return char >= 'a' && char <= 'z' ? char + alphabetOffset : char
}

.function Kick_BinaryToDecimalComponents(binary, decimalComponents) {
    .if (binary == 0) {
        .return 0
    } else {
        .var leftover = mod(binary, 10)
        .eval decimalComponents.add(leftover)
        .return Kick_BinaryToDecimalComponents(floor(binary / 10), decimalComponents)
    }
}

.function Kick_DecimalComponentsToBCD(decimalComponents) {
    .var value = 0
    .for (var i = 0; i < decimalComponents.size(); i++) {
        .eval value = value | decimalComponents.get(i) << (i*4)
    }
    .return value
}

.function Kick_BinaryToBCD(binary) 
{
    .var decimalComponents = List()
    .if (binary == 0)
        .eval decimalComponents.add(0)
    else
        .eval Kick_BinaryToDecimalComponents(binary, decimalComponents)

    .return Kick_DecimalComponentsToBCD(decimalComponents)
}