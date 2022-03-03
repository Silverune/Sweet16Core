#importonce

.function Ascii_InvertString(str)
{
	.const INVERT_OFFSET = $80
	.var invertedString = List()
	.for(var i = 0; i < str.size(); i++) {
		.eval invertedString.add(str.charAt(i) + INVERT_OFFSET)
	}
	.return invertedString
}

.namespace Ascii { 
    .label SPACE = $20
    .label RETURN = $0D
}
