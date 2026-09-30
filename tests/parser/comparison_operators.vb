' Тестируется:
' - операторы < > <= >= <> =
' - Is и IsNot, в том числе сравнение с Nothing
' - сравнение чисел, строк, символов, вещественных значений и результатов вызовов
' - приоритет относительно арифметики, скобки
' - сравнения в условиях If и While
Class Main
    Shared Sub Main()
        Dim less = a < b
        Dim greater = a > b
        Dim lessOrEqual = a <= b
        Dim greaterOrEqual = a >= b
        Dim notEqual = a <> b
        Dim equal = a = b

        Dim withArithmetic = a + 1 < b * 2
        Dim withDivision = (a + b) \ 2 >= c - 1
        Dim ofStrings = name = "text"
        Dim ofChars = letter <> "x"c
        Dim ofFloats = ratio <= 0.5
        Dim ofCalls = Foo() = Bar()
        Dim ofMembers = first.Value > second.Value
        Dim grouped = (a < b) = (c < d)

        Dim sameObject = first Is second
        Dim differentObject = first IsNot second
        Dim isNothing = first Is Nothing
        Dim isNotNothing = first IsNot Nothing

        If a <= b Then
            Print(1)
        End If

        While a <> b
            a = a + 1
        End While
    End Sub
End Class
