' Тестируется:
' - десятичные литералы, в том числе с разделителями "_"
' - шестнадцатеричные (&H), восьмеричные (&O) и двоичные (&B) литералы в любом регистре
' - суффикс I в любом регистре
' - суффиксы у литералов &H/&O/&B и у литералов с разделителями
' - отрицательные значения, литералы в выражениях и константах
Class Main
    Shared Sub Main()
        Dim zero = 0
        Dim plain = 123
        Dim grouped = 1_000_000
        Dim doubleSeparator = 1_00__0

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

        Dim integerValue = 100I
        Dim lowerInteger = 100i

        Dim hexInteger = &HFFI
        Dim hexGroupedInteger = &HFF_FFI
        Dim octalInteger = &O7I
        Dim binaryInteger = &B11I
        Dim groupedInteger = 1_000I

        Dim negative = -42
        Dim negativeHex = -&HFF
        Dim mixed = 1_0 + &H10 * &B10 - &O10
        Dim typedInteger As Integer = -2147483647I
        Const bigConstant As Integer = 2147483647
        Print(255, &HFF, &B11111111, &O377)
    End Sub
End Class
