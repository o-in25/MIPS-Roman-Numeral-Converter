# Roman Numeral Converter
A Roman numeral conversion program that accepts as input, values expressed in Roman digits and outputs the value of the input using standard “arabic” notation.


After successfully converting an input, the program allows the user to run repeated conversions without having to restart the program each time. Hence the user will repeatedly be prompted for a value to convert. The user will enter 0 to indicate they are done performing searches.


Description of Roman Numerals:
M=1000 D=500 C=100 L=50 X=10 V=5 I=1


Digit Order: Roman digits are written in non-ascending order, and digit values are added to pro- duce the represented value, except for prefixes as mentioned below.


Number of Occurrences: No more than three occurrences of M, C, X, or I may appear consecutively, and no more than one D, L, or V may appear at all.


Prefixes: The digits C, X and I can be used as prefixes, and their value is then subtracted from rather than added to the value being accumulated, as follows:
• One C may prefix an M or a D to represent 900 or 400; the prefixed M is written after the other M’s, as in MMMCM. The digits following the M or D represent a value of no more than 99.
• One X may prefix a C or an L to represent 90 or 40; the prefixed C is written after the other C’s. The digits following the C or L represent a value of no more than 9.
• One I may prefix an X or a V to represent 9 or 4. The prefixed digit must appear at the end of the numeral.
3
Some examples: MCMLXXXVIII = 1988 MCMCCIX = 1999 CCCXXXIX = 339 T
