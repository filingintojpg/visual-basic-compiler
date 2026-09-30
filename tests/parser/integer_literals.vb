' Тестируется:
' - десятичные литералы, в том числе с разделителями "_"
' - шестнадцатеричные (&H), восьмеричные (&O) и двоичные (&B) литералы в любом регистре
' - суффиксы S, I, L, US, UI, UL в любом регистре
' - суффиксы у литералов &H/&O/&B и у литералов с разделителями
' - отрицательные значения, литералы в выражениях и константах
Class Main
    Shared Sub Main()
        Dim zero = 0
        Dim plain = 123
        Dim grouped = 1_000_000
        Dim doubleSeparator = 1_00__0
        Dim beyondInteger = 34359738368
        Dim longMax = 9223372036854775807L

        Dim hexUpper = &H1F
        Dim hexLower = &hff
        Dim hexGrouped = &HFF_FF
        Dim hexZero = &H0
        Dim octal = &O17
        Dim octalLower = &o777
        Dim octalGrouped = &O7_7
        Dim binary = &B1010
        Dim binaryGrouped = &B1010_1010
        Dim binaryLower = &b1

        Dim shortValue = 100S
        Dim integerValue = 100I
        Dim longValue = 100L
        Dim ushortValue = 100US
        Dim uintValue = 100UI
        Dim ulongValue = 100UL
        Dim lowerShort = 100s
        Dim lowerLong = 100l
        Dim mixedCaseULong = 100Ul

        Dim hexShort = &H7FS
        Dim hexUShort = &HFFUS
        Dim hexUInteger = &HFFUI
        Dim hexULong = &HFFFFFFFFFUL
        Dim hexLong = &HFF_FFL
        Dim binaryULong = &B11UL
        Dim octalInteger = &O7I
        Dim groupedULong = 1_000UL

        Dim negative = -42
        Dim negativeHex = -&HFF
        Dim mixed = 1_0 + &H10 * &B10 - &O10
        Dim typedShort As Short = -32768S
        Dim typedUInteger As UInteger = 4294967295UI
        Const bigConstant As Long = 34359738368
        Print(255, &HFF, &B11111111, &O377)
    End Sub
End Class
